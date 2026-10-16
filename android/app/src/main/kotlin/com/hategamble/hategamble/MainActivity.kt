package com.hategamble.hategamble

import android.app.Activity
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors

// FlutterFragmentActivity is required by local_auth (biometrics).
class MainActivity : FlutterFragmentActivity() {

    companion object {
        const val EXTRA_ROUTE = "route"
        private const val CHANNEL = "hategamble/native"
        private const val REQ_SAVE = 4101
        private const val REQ_OPEN = 4102
    }

    private var channel: MethodChannel? = null
    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private var pendingFileResult: MethodChannel.Result? = null
    private var pendingSaveContent: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "takeInitialRoute" -> {
                        // On a cold start, honour an explicit route extra or a pending
                        // route left by the blocker.
                        val route = intent.getStringExtra(EXTRA_ROUTE)
                            ?: BlockerStore.takePendingRoute(this@MainActivity)
                        result.success(route)
                        intent.removeExtra(EXTRA_ROUTE)
                    }
                    "isBlockerServiceEnabled" -> result.success(isServiceEnabled())
                    // "Display over other apps": lets the blocker bring the reminder to the
                    // front on Android 12+. A new install (or new app id) starts without it.
                    "canDrawOverlays" -> result.success(Settings.canDrawOverlays(this@MainActivity))
                    "openOverlaySettings" -> {
                        startActivity(
                            Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName"))
                                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        )
                        result.success(null)
                    }
                    "openAccessibilitySettings" -> {
                        startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                        result.success(null)
                    }
                    "getBlockerConfig" -> result.success(BlockerStore.toMap(BlockerStore.load(this@MainActivity)))
                    "setBlockerConfig" -> {
                        @Suppress("UNCHECKED_CAST")
                        BlockerStore.save(this@MainActivity, call.arguments as Map<String, Any?>)
                        result.success(null)
                    }
                    "setLanguage" -> {
                        BlockerStore.setLanguage(this@MainActivity, call.arguments as String)
                        result.success(null)
                    }
                    "setDiscreet" -> {
                        applyDiscreet(call.arguments as Boolean)
                        result.success(null)
                    }
                    "getBlockLog" ->result.success(BlockerStore.readLog(this@MainActivity))
                    "clearBlockLog" -> {
                        BlockerStore.clearLog(this@MainActivity)
                        result.success(null)
                    }
                    "launchApp" -> {
                        // Opens a distraction app (game, video, music) picked in the urge flow.
                        val launch = packageManager.getLaunchIntentForPackage(call.arguments as String)
                        if (launch == null) {
                            result.success(false)
                        } else {
                            startActivity(launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                            result.success(true)
                        }
                    }
                    "getInstalledApps" -> io.execute {
                        // Rendering every icon is the slow part, so callers that only
                        // show a few apps can skip it and fetch icons with getAppIcons.
                        val apps = installedApps(withIcons = call.arguments as? Boolean ?: true)
                        main.post { result.success(apps) }
                    }
                    "getAppIcons" -> io.execute {
                        @Suppress("UNCHECKED_CAST")
                        val icons = (call.arguments as List<String>).mapNotNull { pkg ->
                            try {
                                pkg to iconBytes(packageManager.getApplicationIcon(pkg))
                            } catch (e: PackageManager.NameNotFoundException) {
                                null
                            }
                        }.toMap()
                        main.post { result.success(icons) }
                    }
                    "saveTextFile" -> {
                        pendingFileResult = result
                        pendingSaveContent = call.argument<String>("content")
                        startActivityForResult(
                            Intent(Intent.ACTION_CREATE_DOCUMENT)
                                .addCategory(Intent.CATEGORY_OPENABLE)
                                .setType("application/json")
                                .putExtra(Intent.EXTRA_TITLE, call.argument<String>("name")),
                            REQ_SAVE
                        )
                    }
                    "openTextFile" -> {
                        pendingFileResult = result
                        startActivityForResult(
                            Intent(Intent.ACTION_OPEN_DOCUMENT)
                                .addCategory(Intent.CATEGORY_OPENABLE)
                                .setType("*/*"),
                            REQ_OPEN
                        )
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        intent.getStringExtra(EXTRA_ROUTE)?.let { channel?.invokeMethod("navigate", it) }
    }

    override fun onResume() {
        super.onResume()
        // The blocker brings this activity to the front with REORDER_TO_FRONT, which
        // delivers no new intent, so pick up any pending route here. channel is null
        // on the first resume of a cold start; takeInitialRoute covers that case.
        channel?.let { ch ->
            BlockerStore.takePendingRoute(this)?.let { ch.invokeMethod("navigate", it) }
        }
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != REQ_SAVE && requestCode != REQ_OPEN) return
        val result = pendingFileResult ?: return
        pendingFileResult = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null)
            return
        }
        try {
            if (requestCode == REQ_SAVE) {
                contentResolver.openOutputStream(uri, "wt")!!.use {
                    it.write((pendingSaveContent ?: "").toByteArray(Charsets.UTF_8))
                }
                result.success(true)
            } else {
                val text = contentResolver.openInputStream(uri)!!.use { it.readBytes().toString(Charsets.UTF_8) }
                result.success(text)
            }
        } catch (e: Exception) {
            result.error("file_error", e.message, null)
        } finally {
            pendingSaveContent = null
        }
    }

    /// Swaps which launcher alias is enabled, so the icon/name becomes "Notes"
    /// (discreet) or "Chitah" (normal). DONT_KILL_APP keeps this process alive.
    private fun applyDiscreet(discreet: Boolean) {
        BlockerStore.setDiscreet(this, discreet)
        val pm = packageManager
        fun set(alias: String, enabled: Boolean) = pm.setComponentEnabledSetting(
            // Aliases are named after the code package (namespace), which differs
            // from the application id (com.chitah.app).
            ComponentName(this, "${MainActivity::class.java.`package`!!.name}$alias"),
            if (enabled) PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP,
        )
        // Exactly one alias is ever enabled, so there is always a way back in.
        set(".NotesAlias", discreet)
        set(".NormalAlias", !discreet)
    }

    private fun isServiceEnabled(): Boolean {
        val expected = ComponentName(this, BlockerService::class.java)
        val enabled = Settings.Secure.getString(contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES)
            ?: return false
        return enabled.split(':').any { ComponentName.unflattenFromString(it) == expected }
    }

    private fun installedApps(withIcons: Boolean): List<Map<String, Any?>> {
        val pm = packageManager
        val launcher = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        return pm.queryIntentActivities(launcher, PackageManager.MATCH_ALL)
            .map { it.activityInfo.applicationInfo }
            .distinctBy { it.packageName }
            .filter { it.packageName != packageName }
            .map { info ->
                mapOf(
                    "package" to info.packageName,
                    "label" to pm.getApplicationLabel(info).toString(),
                    "icon" to if (withIcons) iconBytes(pm.getApplicationIcon(info)) else null,
                    // Play Store category (game, audio, video...), or -1 if unknown.
                    "category" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) info.category else -1,
                )
            }
            .sortedBy { (it["label"] as String).lowercase() }
    }

    private fun iconBytes(drawable: android.graphics.drawable.Drawable): ByteArray {
        val size = 96
        val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, size, size)
        drawable.draw(canvas)
        return ByteArrayOutputStream().use {
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, it)
            it.toByteArray()
        }
    }
}
