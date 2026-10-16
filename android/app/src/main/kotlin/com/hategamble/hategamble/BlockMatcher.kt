package com.hategamble.hategamble

/**
 * Pure matching rules for the blocker, kept free of Android types so they can be
 * unit tested on the JVM (see src/test/.../BlockMatcherTest.kt).
 */
object BlockMatcher {

    /**
     * Apps that look like gambling by name or package, blocked even if the user
     * never picked them (so a newly installed casino app is caught too).
     * Mirrors gamblingAppPattern in lib/features/blocker/defaults.dart.
     */
    private val gamblingApp = Regex(
        // "bet" only as its own word (so "Better Sleep" is not caught), plus known brands.
        "(casino|poker|slots?\\b|\\bbets?\\b|betting|bet365|betway|betfair|betmgm|1xbet|okbet|" +
            "lott(o|ery)|jackpot|bingo|roulette|blackjack|" +
            "sportsbook|sabong|baccarat|pachinko|draftkings|fanduel|\\bstake\\b|panalo|jili)",
        RegexOption.IGNORE_CASE,
    )

    fun looksLikeGamblingApp(label: String, packageName: String): Boolean =
        gamblingApp.containsMatchIn(label) || gamblingApp.containsMatchIn(packageName)

    /** The host part of a URL or address-bar text, lowercased, without "www.". */
    fun hostOf(raw: String): String = raw.trim().lowercase()
        .substringAfter("://")
        .substringBefore('/')
        .substringBefore('?')
        .substringBefore('#')
        .substringBefore(':')
        .removePrefix("www.")
        .trimEnd('.')

    /** The blocked domain [raw] points at (the domain itself or any subdomain), or null. */
    fun matchDomain(raw: String, domains: Set<String>): String? {
        val host = hostOf(raw)
        if (!host.contains('.') || host.contains(' ')) return null
        return domains.firstOrNull { host == it || host.endsWith(".$it") }
    }

    /**
     * The blocked keyword found in [raw] (a URL or a search), or null. Separators
     * like "+", "-", "_", "." and "%20" count as spaces, and multi-word keywords
     * also match without spaces ("onlinecasino").
     */
    fun matchKeyword(raw: String, keywords: Set<String>): String? {
        val text = raw.trim().lowercase()
        val normalized = text.replace("%20", " ").replace(Regex("[+_\\-./?=&#]+"), " ")
        return keywords.firstOrNull { kw ->
            val k = kw.trim().lowercase()
            k.isNotEmpty() && (normalized.contains(k) || text.contains(k.replace(" ", "")))
        }
    }

    /** What [raw] (address-bar or search text) is blocked for, or null if it's allowed. */
    fun matchUrl(raw: String, domains: Set<String>, keywords: Set<String>): String? =
        matchDomain(raw, domains) ?: matchKeyword(raw, keywords)

    /**
     * Whether a view id looks like an address bar or a search box. Used to read
     * browsers that aren't in the known list, and search fields in other apps
     * (the Google app, Play Store), without reading chat messages or posts.
     */
    fun isUrlOrSearchField(viewId: String?): Boolean {
        val id = viewId?.substringAfter(":id/")?.lowercase() ?: return false
        return listOf("url", "address", "omnibox", "location_bar", "search", "query").any { id.contains(it) }
    }
}
