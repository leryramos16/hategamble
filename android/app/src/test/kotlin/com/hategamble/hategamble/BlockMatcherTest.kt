package com.hategamble.hategamble

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/** Tries the ways someone might slip past the blocker's matching rules. */
class BlockMatcherTest {

    private val domains = setOf("bet365.com", "okbet.com", "casinoplus.com.ph", "stake.com")
    private val keywords = setOf("casino", "online betting", "sabong", "jili", "free spins")

    private fun blocked(text: String) = BlockMatcher.matchUrl(text, domains, keywords)

    @Test
    fun blocksDomainsHoweverTheyAreWritten() {
        listOf(
            "bet365.com",
            "BET365.COM",
            "www.bet365.com",
            "https://www.bet365.com/#/AC/B1/",
            "http://bet365.com:443/en",
            "m.bet365.com",                   // mobile site
            "sports.mobile.bet365.com",       // deeper subdomain
            "bet365.com.",                    // trailing dot
            "okbet.com?ref=fb",
            "https://casinoplus.com.ph/games",
            "  stake.com  ",
        ).forEach { assertEquals("should block: $it", true, blocked(it) != null) }
    }

    @Test
    fun doesNotBlockLookalikeButUnrelatedDomains() {
        // "notbet365.com" is a different site; only the domain and its subdomains match.
        assertNull(BlockMatcher.matchDomain("notbet365.com", domains))
        assertNull(BlockMatcher.matchDomain("mistake.com", domains))
        assertNull(blocked("google.com"))
        assertNull(blocked("youtube.com/watch?v=abc"))
        assertNull(blocked("facebook.com"))
    }

    @Test
    fun blocksSearchesAndUrlsWithKeywords() {
        listOf(
            "online casino philippines",
            "CASINO",
            "best+online+betting+sites",
            "online-betting",
            "onlinebetting",                  // words run together
            "online%20betting",               // URL-encoded space
            "e-sabong live",
            "https://example.com/jili-slots",
            "free_spins no deposit",
            "google.com/search?q=casino",
        ).forEach { assertEquals("should block: $it", true, blocked(it) != null) }
    }

    @Test
    fun allowsOrdinarySearches() {
        listOf("weather manila", "how to save money", "netflix", "recipes adobo")
            .forEach { assertNull("should allow: $it", blocked(it)) }
    }

    @Test
    fun spotsAppsThatLookLikeGambling() {
        assertTrue(BlockMatcher.looksLikeGamblingApp("Lucky Casino Slots", "com.example.luckyslots"))
        assertTrue(BlockMatcher.looksLikeGamblingApp("Sabong Live", "ph.sabong.live"))
        assertTrue(BlockMatcher.looksLikeGamblingApp("Game", "com.bet365.sportsbook"))
        assertTrue(BlockMatcher.looksLikeGamblingApp("JILI Games", "com.jili.games"))
        assertTrue(BlockMatcher.looksLikeGamblingApp("PCSO Lotto Results", "ph.lotto"))
        assertFalse(BlockMatcher.looksLikeGamblingApp("YouTube", "com.google.android.youtube"))
        assertFalse(BlockMatcher.looksLikeGamblingApp("Messenger", "com.facebook.orca"))
        assertFalse(BlockMatcher.looksLikeGamblingApp("Alphabet Learning", "com.kids.alphabet"))
        assertFalse(BlockMatcher.looksLikeGamblingApp("Better Sleep", "com.better.sleep"))
        assertFalse(BlockMatcher.looksLikeGamblingApp("Mistake Fixer", "com.mistake.fixer"))
        assertTrue(BlockMatcher.looksLikeGamblingApp("Betway", "com.betway.sports"))
        assertTrue(BlockMatcher.looksLikeGamblingApp("1xBet", "org.xbet.client1"))
        assertTrue(BlockMatcher.looksLikeGamblingApp("Sports", "com.example.bet.app"))
    }

    @Test
    fun readsAddressAndSearchFieldsButNotChats() {
        assertTrue(BlockMatcher.isUrlOrSearchField("com.android.chrome:id/url_bar"))
        assertTrue(BlockMatcher.isUrlOrSearchField("com.google.android.googlequicksearchbox:id/search_box"))
        assertTrue(BlockMatcher.isUrlOrSearchField("com.android.vending:id/search_bar_text_input"))
        assertFalse(BlockMatcher.isUrlOrSearchField("com.facebook.orca:id/composer_edit_text"))
        assertFalse(BlockMatcher.isUrlOrSearchField(null))
    }
}
