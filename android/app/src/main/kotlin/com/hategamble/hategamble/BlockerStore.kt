package com.hategamble.hategamble

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject

/**
 * Blocker configuration and block log, shared between the Flutter UI (via MainActivity's
 * method channel) and [BlockerService]. Stored in a private SharedPreferences file on-device.
 */
object BlockerStore {
    const val PREFS = "hategamble_blocker"
    private const val KEY_ENABLED = "enabled"
    private const val KEY_PACKAGES = "packages"
    private const val KEY_DOMAINS = "domains"
    private const val KEY_KEYWORDS = "keywords"
    private const val KEY_LOG = "log"
    private const val KEY_LANGUAGE = "language"
    private const val KEY_DISCREET = "discreet"
    private const val KEY_PENDING_ROUTE = "pending_route"
    private const val MAX_LOG = 500

    data class Config(
        val enabled: Boolean,
        val packages: Set<String>,
        val domains: Set<String>,
        val keywords: Set<String>,
    )

    fun prefs(context: Context): SharedPreferences =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun load(context: Context): Config {
        val p = prefs(context)
        return Config(
            enabled = p.getBoolean(KEY_ENABLED, false),
            packages = p.getStringSet(KEY_PACKAGES, emptySet())!!.toSet(),
            domains = p.getStringSet(KEY_DOMAINS, emptySet())!!.map { it.lowercase() }.toSet(),
            keywords = p.getStringSet(KEY_KEYWORDS, emptySet())!!.map { it.lowercase() }.toSet(),
        )
    }

    fun save(context: Context, map: Map<String, Any?>) {
        @Suppress("UNCHECKED_CAST")
        prefs(context).edit()
            .putBoolean(KEY_ENABLED, map["enabled"] as? Boolean ?: false)
            .putStringSet(KEY_PACKAGES, ((map["packages"] as? List<String>) ?: emptyList()).toSet())
            .putStringSet(KEY_DOMAINS, ((map["domains"] as? List<String>) ?: emptyList()).toSet())
            .putStringSet(KEY_KEYWORDS, ((map["keywords"] as? List<String>) ?: emptyList()).toSet())
            .apply()
    }

    fun toMap(config: Config): Map<String, Any> = mapOf(
        "enabled" to config.enabled,
        "packages" to config.packages.toList(),
        "domains" to config.domains.toList(),
        "keywords" to config.keywords.toList(),
    )

    @Synchronized
    fun appendLog(context: Context, type: String, target: String) {
        val p = prefs(context)
        val log = JSONArray(p.getString(KEY_LOG, "[]"))
        log.put(JSONObject().put("ts", System.currentTimeMillis()).put("type", type).put("target", target))
        val trimmed = JSONArray()
        val start = maxOf(0, log.length() - MAX_LOG)
        for (i in start until log.length()) trimmed.put(log.get(i))
        p.edit().putString(KEY_LOG, trimmed.toString()).apply()
    }

    fun readLog(context: Context): List<Map<String, Any>> {
        val log = JSONArray(prefs(context).getString(KEY_LOG, "[]"))
        return (0 until log.length()).map {
            val o = log.getJSONObject(it)
            mapOf("ts" to o.getLong("ts"), "type" to o.getString("type"), "target" to o.getString("target"))
        }
    }

    fun setLanguage(context: Context, code: String) {
        prefs(context).edit().putString(KEY_LANGUAGE, code).apply()
    }

    fun language(context: Context): String = prefs(context).getString(KEY_LANGUAGE, "en") ?: "en"

    fun setDiscreet(context: Context, discreet: Boolean) {
        prefs(context).edit().putBoolean(KEY_DISCREET, discreet).apply()
    }

    fun isDiscreet(context: Context): Boolean = prefs(context).getBoolean(KEY_DISCREET, false)

    /// A route the app should open the next time it resumes (used by the blocker to
    /// reach the urge flow even when the launch intent can't be delivered directly).
    fun setPendingRoute(context: Context, route: String) {
        prefs(context).edit().putString(KEY_PENDING_ROUTE, route).apply()
    }

    fun takePendingRoute(context: Context): String? {
        val p = prefs(context)
        val route = p.getString(KEY_PENDING_ROUTE, null)
        if (route != null) p.edit().remove(KEY_PENDING_ROUTE).apply()
        return route
    }

    fun clearLog(context: Context) {
        prefs(context).edit().remove(KEY_LOG).apply()
    }
}
