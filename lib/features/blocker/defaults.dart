/// Bundled, offline blocklists. Users can add their own entries in the Blocker tab.
const defaultBlockedDomains = <String>[
  // International sportsbooks & casinos
  'bet365.com', 'betway.com', 'williamhill.com', 'paddypower.com', 'betfair.com',
  'ladbrokes.com', 'coral.co.uk', 'skybet.com', 'unibet.com', 'bwin.com',
  'betsson.com', 'leovegas.com', 'casumo.com', 'mrgreen.com', '888.com',
  '888casino.com', '888poker.com', '888sport.com', 'pokerstars.com', 'ggpoker.com',
  'partypoker.com', 'draftkings.com', 'fanduel.com', 'betmgm.com', 'pointsbet.com',
  'betrivers.com', 'bovada.lv', 'betonline.ag', 'ignitioncasino.eu', 'betano.com',
  'sportingbet.com', 'betvictor.com', 'boylesports.com', 'betfred.com', 'tipico.com',
  'pinnacle.com', '1xbet.com', 'melbet.com', '22bet.com', 'parimatch.com',
  'mostbet.com', 'dafabet.com', 'fun88.com', 'w88.com', '188bet.com', 'm88.com',
  'sbobet.com', '12bet.com', 'betwinner.com', 'linebet.com',
  // Crypto & sweepstakes casinos
  'stake.com', 'stake.us', 'roobet.com', 'rollbit.com', 'bc.game', 'duelbits.com',
  'gamdom.com', 'bitstarz.com', 'chumbacasino.com', 'pulsz.com', 'wowvegas.com',
  'luckyland.com', 'mcluck.com', 'high5casino.com',
  // Philippines
  'okbet.com', 'bingoplus.com', 'arenaplus.net', 'casinoplus.com.ph', 'jilibet.com',
];

const defaultBlockedKeywords = <String>[
  'casino', 'sportsbook', 'sports betting', 'online betting', 'betting odds',
  'bet365', 'poker', 'roulette', 'blackjack', 'baccarat', 'online slots',
  'slot machine', 'free spins', 'jackpot', 'sabong', 'e-sabong', 'jili',
];

/// Used to suggest installed apps that look like gambling apps.
final gamblingAppPattern = RegExp(
  // "bet" only as its own word (so "Better Sleep" is not caught), plus known brands.
  // Keep in sync with BlockMatcher.kt.
  r'(casino|poker|slots?\b|\bbets?\b|betting|bet365|betway|betfair|betmgm|1xbet|okbet|'
  r'lott(o|ery)|jackpot|bingo|roulette|blackjack|'
  r'sportsbook|sabong|baccarat|pachinko|draftkings|fanduel|\bstake\b|panalo|jili)',
  caseSensitive: false,
);
