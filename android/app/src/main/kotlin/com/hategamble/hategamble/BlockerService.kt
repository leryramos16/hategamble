package com.hategamble.hategamble

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.content.SharedPreferences
import android.os.SystemClock
import android.provider.Settings
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo

/**
 * Offline gambling blocker.
 *
 * - App blocking: whenever a blocked app (or one that looks like gambling) is on screen, the
 *   user is sent home and shown the urge flow (or [BlockedActivity] in discreet mode).
 * - Website blocking: browser address bars, and address/search fields in other apps, are read
 *   and matched against blocked domains and keywords (this also catches searches like
 *   "online casino"). Matching rules live in [BlockMatcher].
 *
 * No network access is used; matching happens entirely on-device.
 */
class BlockerService : AccessibilityService(), SharedPreferences.OnSharedPreferenceChangeListener {

    private lateinit var config: BlockerStore.Config
    private var lastBlockAt = 0L
    private var lastLaunchAt = 0L

    override fun onServiceConnected() {
        super.onServiceConnected()
        config = BlockerStore.load(this)
        BlockerStore.prefs(this).registerOnSharedPreferenceChangeListener(this)
    }

    override fun onSharedPreferenceChanged(prefs: SharedPreferences?, key: String?) {
        config = BlockerStore.load(this)
    }

    override fun onDestroy() {
        BlockerStore.prefs(this).unregisterOnSharedPreferenceChangeListener(this)
        super.onDestroy()
    }

    override fun onInterrupt() {}

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || !::config.isInitialized || !config.enabled) return
        val pkg = event.packageName?.toString() ?: return
        if (pkg == packageName || pkg == "com.android.systemui") return

        // Any event from a blocked app means it's on screen, not just the first
        // window change, so it's caught again however the user gets back to it.
        // Apps that look like gambling are blocked even if never picked.
        if (pkg in config.packages || looksLikeGambling(pkg)) {
            block("app", appLabel(pkg))
            return
        }

        // Typing into an address bar or search box: the event carries the text.
        if (event.eventType == AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED &&
            BlockMatcher.isUrlOrSearchField(event.source?.viewIdResourceName)
        ) {
            val typed = event.text.joinToString(" ")
            BlockMatcher.matchUrl(typed, config.domains, config.keywords)?.let { return block("site", it) }
        }

        val urlBarIds = BROWSER_URL_BAR_IDS[pkg]
        val texts = if (urlBarIds != null || pkg.contains("browser")) {
            listOfNotNull(readAddressBar(pkg, urlBarIds))
        } else {
            // Browsers we don't know, and in-app search boxes (Google app, Play
            // Store): look for address-bar or search fields, at most every 600 ms
            // per app so scanning stays cheap.
            scanUrlOrSearchFields(pkg)
        }
        for (text in texts) {
            BlockMatcher.matchUrl(text, config.domains, config.keywords)?.let { return block("site", it) }
        }
    }

    private val gamblingLookCache = HashMap<String, Boolean>()

    private fun looksLikeGambling(pkg: String): Boolean = gamblingLookCache.getOrPut(pkg) {
        BlockMatcher.looksLikeGamblingApp(appLabel(pkg), pkg)
    }

    private val lastScanAt = HashMap<String, Long>()

    private fun scanUrlOrSearchFields(pkg: String): List<String> {
        val now = SystemClock.elapsedRealtime()
        if (now - (lastScanAt[pkg] ?: 0L) < 600) return emptyList()
        lastScanAt[pkg] = now
        val root = rootInActiveWindow ?: return emptyList()
        val found = mutableListOf<String>()
        val queue = ArrayDeque<AccessibilityNodeInfo>().apply { add(root) }
        var visited = 0
        while (queue.isNotEmpty() && visited < 400) {
            val node = queue.removeFirst()
            visited++
            val text = node.text?.toString()
            if (!text.isNullOrBlank() && BlockMatcher.isUrlOrSearchField(node.viewIdResourceName)) found += text
            for (i in 0 until node.childCount) node.getChild(i)?.let(queue::add)
        }
        return found
    }

    private fun readAddressBar(pkg: String, ids: List<String>?): String? {
        val root = rootInActiveWindow ?: return null
        for (id in ids ?: listOf("url_bar", "url", "url_field", "address_bar", "search_box")) {
            val nodes: List<AccessibilityNodeInfo> = root.findAccessibilityNodeInfosByViewId("$pkg:id/$id")
            val text = nodes.firstNotNullOfOrNull { it.text?.toString()?.takeIf(String::isNotBlank) }
            if (text != null) return text
        }
        return null
    }

    private fun block(type: String, target: String) {
        val now = SystemClock.elapsedRealtime()

        // Without "Display over other apps", Android won't let Chitah come to the
        // front from here, so at least leave the gambling app or page. (Not used
        // otherwise: pressing Home makes Android hold back activity starts for a
        // few seconds, which would hide the reminder below.)
        if (!Settings.canDrawOverlays(this)) {
            performGlobalAction(GLOBAL_ACTION_HOME)
        }

        // Log once per visit, but cover the app with the reminder on every
        // detection: going straight back (Back, Recents) shows it again at once.
        if (now - lastBlockAt >= 1500) BlockerStore.appendLog(this, type, target)
        // A short gap only so a burst of events doesn't relaunch dozens of times.
        if (now - lastLaunchAt < 400) return
        lastLaunchAt = now
        lastBlockAt = now

        if (BlockerStore.isDiscreet(this)) {
            // Discreet mode: a neutral screen that reveals nothing.
            startActivity(
                Intent(this, BlockedActivity::class.java)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    .putExtra(BlockedActivity.EXTRA_TYPE, type)
                    .putExtra(BlockedActivity.EXTRA_TARGET, target)
            )
        } else {
            // Normal mode: bring the urge flow to the front. Holding the
            // SYSTEM_ALERT_WINDOW ("Display over other apps") permission lets this
            // background start reach the foreground on Android 12+.
            BlockerStore.setPendingRoute(this, "/sos")
            startActivity(
                Intent(this, MainActivity::class.java)
                    .addFlags(
                        Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP
                    )
            )
        }
    }

    private fun appLabel(pkg: String): String = try {
        packageManager.getApplicationLabel(packageManager.getApplicationInfo(pkg, 0)).toString()
    } catch (_: Exception) {
        pkg
    }

    companion object {
        /** View ids (without the "pkg:id/" prefix) of address bars in common Android browsers. */
        val BROWSER_URL_BAR_IDS: Map<String, List<String>> = mapOf(
            "com.android.chrome" to listOf("url_bar"),
            "com.chrome.beta" to listOf("url_bar"),
            "com.chrome.dev" to listOf("url_bar"),
            "com.chrome.canary" to listOf("url_bar"),
            "com.microsoft.emmx" to listOf("url_bar"),
            "com.brave.browser" to listOf("url_bar"),
            "com.vivaldi.browser" to listOf("url_bar"),
            "com.kiwibrowser.browser" to listOf("url_bar"),
            "org.chromium.chrome" to listOf("url_bar"),
            "org.mozilla.firefox" to listOf("mozac_browser_toolbar_url_view", "url_bar_title"),
            "org.mozilla.firefox_beta" to listOf("mozac_browser_toolbar_url_view", "url_bar_title"),
            "org.mozilla.fenix" to listOf("mozac_browser_toolbar_url_view"),
            "org.mozilla.focus" to listOf("mozac_browser_toolbar_url_view", "display_url"),
            "com.sec.android.app.sbrowser" to listOf("location_bar_edit_text", "custom_url_bar"),
            "com.opera.browser" to listOf("url_field"),
            "com.opera.mini.native" to listOf("url_field"),
            "com.opera.gx" to listOf("url_field"),
            "com.duckduckgo.mobile.android" to listOf("omnibarTextInput"),
            "com.mi.globalbrowser" to listOf("url"),
            "com.UCMobile.intl" to listOf("titlebar_url"),
        )
    }
}
