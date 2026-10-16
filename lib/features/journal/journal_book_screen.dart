import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/profile.dart';
import '../../core/providers.dart';
import '../../l10n/l10n.dart';
import '../../shared/deer_icon.dart';
import '../../shared/widgets.dart';
import 'journal_widgets.dart';

/// One stretch of the journey. Chapter 1 starts on the quit date, and each slip
/// starts a new chapter, so the journal reads as the story of getting back up.
class JournalChapter {
  JournalChapter(this.number, this.start, this.endSlip, this.entries);
  final int number;
  final DateTime start;

  /// The slip that ended this chapter (and began the next), or null for the
  /// current chapter.
  final Relapse? endSlip;
  final List<JournalEntry> entries;

  DateTime? get end => endSlip?.at;
}

/// Splits journal entries into chapters by the slips between them.
List<JournalChapter> buildChapters(DateTime quitDate, List<Relapse> relapses, List<JournalEntry> entries) {
  final slips = relapses.where((r) => !r.at.isBefore(quitDate)).toList()..sort((a, b) => a.at.compareTo(b.at));
  final starts = [quitDate, ...slips.map((r) => r.at)];
  final sorted = [...entries]..sort((a, b) => a.at.compareTo(b.at));
  return [
    for (var i = 0; i < starts.length; i++)
      JournalChapter(
        i + 1,
        starts[i],
        i < slips.length ? slips[i] : null,
        sorted.where((e) {
          // Entries from before the quit date belong to chapter 1.
          final afterStart = i == 0 || !e.at.isBefore(starts[i]);
          final beforeEnd = i + 1 >= starts.length || e.at.isBefore(starts[i + 1]);
          return afterStart && beforeEnd;
        }).toList(),
      ),
  ];
}

// ---- Spreads: two facing pages each ----

sealed class _Spread {}

/// A chapter's opening. The title is on the right page, like a new chapter in
/// a book. The left page closes the previous chapter, or for chapter 1 is the
/// blank first page of the book.
class _TitleSpread extends _Spread {
  _TitleSpread(this.chapter, this.previous, this.showEmptyHint);
  final JournalChapter chapter;
  final JournalChapter? previous;
  final bool showEmptyHint;
}

/// One day: four quarters across the two pages, one entry in each.
class _DaySpread extends _Spread {
  _DaySpread(this.day, this.entries);
  final DateTime day;
  final List<JournalEntry> entries;
  bool get isToday => day == dayOnly(DateTime.now());
}

List<_Spread> _layoutSpreads(List<JournalChapter> chapters) {
  final today = dayOnly(DateTime.now());
  final empty = chapters.every((c) => c.entries.isEmpty);
  final spreads = <_Spread>[];
  for (var i = 0; i < chapters.length; i++) {
    final ch = chapters[i];
    spreads.add(_TitleSpread(ch, i > 0 ? chapters[i - 1] : null, empty));
    final byDay = <DateTime, List<JournalEntry>>{};
    for (final e in ch.entries) {
      byDay.putIfAbsent(dayOnly(e.at), () => []).add(e);
    }
    // The current chapter always ends on today's spread, ready to write in.
    if (ch.endSlip == null) byDay.putIfAbsent(today, () => []);
    for (final day in byDay.keys.toList()..sort()) {
      spreads.add(_DaySpread(day, byDay[day]!));
    }
  }
  return spreads;
}

/// The journal, which is also the full history: an open book, one day per
/// spread with up to four entries. Swipe to turn the page.
class JournalBookScreen extends ConsumerWidget {
  const JournalBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final entries = ref.watch(journalEntriesProvider).value;
    final relapses = ref.watch(relapsesProvider).value;
    final quit = ref.watch(profileProvider.select((p) => p.quitDate));

    return Scaffold(
      appBar: AppBar(title: Text(l.journalBookTitle)),
      body: entries == null || relapses == null
          ? const Center(child: CircularProgressIndicator())
          : Builder(
              builder: (context) {
                final spreads = _layoutSpreads(buildChapters(quit, relapses, entries));
                Widget page(int s, {required bool left}) => Parchment(
                  seed: s * 2 + (left ? 3 : 4),
                  child: switch (spreads[s]) {
                    _TitleSpread(:final chapter, :final previous, :final showEmptyHint) =>
                      left
                          ? _ChapterOpening(previous: previous, showEmptyHint: showEmptyHint)
                          : _ChapterTitle(chapter: chapter),
                    _DaySpread() && final d => _DayPage(spread: d, left: left),
                  },
                );
                // Keep the page controls clear of the phone's navigation bar.
                return SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 12),
                    child: _OpenBook(
                      spreadCount: spreads.length,
                      // Open on the latest spread (today), ready to write.
                      initialSpread: spreads.length - 1,
                      leftPage: (s) => page(s, left: true),
                      rightPage: (s) => page(s, left: false),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/// An open book with facing pages. Turning the page lifts the right page and
/// swings it over the spine, showing the next left page on its back.
class _OpenBook extends StatefulWidget {
  const _OpenBook({
    required this.spreadCount,
    required this.initialSpread,
    required this.leftPage,
    required this.rightPage,
  });
  final int spreadCount;
  final int initialSpread;
  final Widget Function(int spread) leftPage;
  final Widget Function(int spread) rightPage;

  @override
  State<_OpenBook> createState() => _OpenBookState();
}

class _OpenBookState extends State<_OpenBook> with SingleTickerProviderStateMixin {
  // Fractional spread position: 2.3 means spread 2 is 30% turned towards 3.
  late final AnimationController _pos = AnimationController.unbounded(
    vsync: this,
    value: widget.initialSpread.toDouble(),
  );
  double _width = 1;

  int get _last => widget.spreadCount - 1;

  static const _pageRadius = Radius.circular(10);

  @override
  void didUpdateWidget(covariant _OpenBook old) {
    super.didUpdateWidget(old);
    if (_pos.value > _last) _pos.value = _last.toDouble();
  }

  @override
  void dispose() {
    _pos.dispose();
    super.dispose();
  }

  void _goTo(int spread) => _pos.animateTo(
    spread.clamp(0, _last).toDouble(),
    duration: const Duration(milliseconds: 650),
    curve: Curves.easeInOutCubic,
  );

  void _onDragEnd(DragEndDetails d) {
    final v = d.primaryVelocity ?? 0;
    final p = _pos.value;
    if (v < -300) return _goTo(p.floor() + 1);
    if (v > 300) return _goTo(p.ceil() - 1);
    _goTo(p.round());
  }

  Widget _shade(double alpha) => IgnorePointer(
    child: ColoredBox(color: Colors.black.withValues(alpha: alpha.clamp(0, 1))),
  );

  /// A page with rounded outer corners and the curve of the paper into the spine.
  Widget _leaf(Widget content, {required bool left}) {
    return ClipRRect(
      borderRadius: left
          ? const BorderRadius.only(topLeft: _pageRadius, bottomLeft: _pageRadius)
          : const BorderRadius.only(topRight: _pageRadius, bottomRight: _pageRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          content,
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: left ? Alignment.centerRight : Alignment.centerLeft,
                  end: left ? Alignment.centerLeft : Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.28),
                    Colors.black.withValues(alpha: 0.06),
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.05),
                  ],
                  stops: const [0, 0.08, 0.22, 1],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = context.l10n;
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, outer) {
              // Keep book proportions instead of stretching to a tall strip.
              final height = math.min(outer.maxHeight, outer.maxWidth * 1.3);
              return Center(
                child: SizedBox(
                  height: height,
                  child: JournalCover(
                    child: ColoredBox(
                      color: const Color(0xFF3A2314),
                      child: LayoutBuilder(builder: (context, box) => _book(box.maxWidth, box.maxHeight)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _pos,
          builder: (context, _) {
            final current = _pos.value.round();
            return Row(
              children: [
                IconButton(
                  tooltip: l.previousPage,
                  onPressed: current > 0 ? () => _goTo(current - 1) : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    l.journalPageOf(current + 1, widget.spreadCount),
                    textAlign: TextAlign.center,
                    style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                  ),
                ),
                IconButton(
                  tooltip: l.nextPage,
                  onPressed: current < _last ? () => _goTo(current + 1) : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _book(double w, double h) {
    _width = w;
    const side = 7.0, top = 4.0, bottomGap = 24.0;
    final half = w / 2;
    final pageBottom = h - bottomGap;
    final leftRect = Rect.fromLTRB(side, top, half, pageBottom);
    final rightRect = Rect.fromLTRB(half, top, w - side, pageBottom);
    Widget at(Rect r, Widget child) => Positioned.fromRect(rect: r, child: child);

    // The edges of the pages underneath, showing the book's thickness.
    final thickness = <Widget>[
      for (var k = 3; k >= 1; k--) ...[
        at(
          Rect.fromLTRB(leftRect.left - k * 1.6, top + k, half, pageBottom + k * 2.2),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color.lerp(const Color(0xFFD9C29A), const Color(0xFF9C7E52), k / 4),
              borderRadius: const BorderRadius.only(topLeft: _pageRadius, bottomLeft: _pageRadius),
            ),
          ),
        ),
        at(
          Rect.fromLTRB(half, top + k, rightRect.right + k * 1.6, pageBottom + k * 2.2),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color.lerp(const Color(0xFFD9C29A), const Color(0xFF9C7E52), k / 4),
              borderRadius: const BorderRadius.only(topRight: _pageRadius, bottomRight: _pageRadius),
            ),
          ),
        ),
      ],
    ];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // Dragging across the whole book turns one page.
      onHorizontalDragUpdate: (d) => _pos.value = (_pos.value - d.delta.dx / _width).clamp(0, _last).toDouble(),
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _pos,
        builder: (context, _) {
          final s = _pos.value.floor().clamp(0, _last);
          final turn = (_pos.value - s).clamp(0.0, 1.0);
          final turning = turn > 0 && s < _last;
          return Stack(
            children: [
              ...thickness,
              // Facing pages underneath: this spread's left, and the next
              // spread's right once the page starts to turn.
              at(leftRect, _leaf(widget.leftPage(s), left: true)),
              at(rightRect, _leaf(widget.rightPage(turning ? s + 1 : s), left: false)),
              if (turning && turn < 0.5) at(rightRect, _shade(0.3 * (1 - turn * 2))),
              if (turning && turn >= 0.5) at(leftRect, _shade(0.3 * (turn - 0.5) * 2)),

              // A red ribbon bookmark hanging out of the bottom.
              Positioned(
                left: half + rightRect.width * 0.18,
                top: pageBottom - 10,
                width: 14,
                height: bottomGap + 6,
                child: IgnorePointer(child: CustomPaint(painter: _RibbonPainter())),
              ),

              // The turning leaf. First half: this spread's right page lifts off
              // the spine. Second half: its back (the next left page) settles
              // down on the left.
              if (turning && turn < 0.5)
                at(
                  rightRect,
                  Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0012)
                      ..rotateY(turn * math.pi),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [_leaf(widget.rightPage(s), left: false), _shade(0.35 * turn * 2)],
                    ),
                  ),
                ),
              if (turning && turn >= 0.5)
                at(
                  leftRect,
                  Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0012)
                      ..rotateY(-(1 - turn) * math.pi),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [_leaf(widget.leftPage(s + 1), left: true), _shade(0.35 * (1 - turn) * 2)],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// A cloth ribbon with a V-cut end.
class _RibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height - 6)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF7E1F1C));
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height - 5),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Right page of a chapter's opening spread: an inked deer (peace) above the
/// chapter number and its dates.
class _ChapterTitle extends StatelessWidget {
  const _ChapterTitle({required this.chapter});
  final JournalChapter chapter;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fmt = DateFormat.yMMMd();
    final range = '${fmt.format(chapter.start)} –\n${chapter.end == null ? l.today : fmt.format(chapter.end!)}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 14, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DeerIcon(size: 72, color: JournalInk.color.withValues(alpha: 0.6)),
          const SizedBox(height: 14),
          Text(l.chapterN(chapter.number), textAlign: TextAlign.center, style: JournalInk.style(30, height: 1.2)),
          const SizedBox(height: 6),
          const _Ornament(),
          const SizedBox(height: 14),
          Text(range, textAlign: TextAlign.center, style: JournalInk.style(15, alpha: 0.8, height: 1.35)),
        ],
      ),
    );
  }
}

/// Left page of a chapter's opening spread. For chapter 1 it's the book's blank
/// first page; after a slip it closes the previous chapter.
class _ChapterOpening extends ConsumerWidget {
  const _ChapterOpening({required this.previous, required this.showEmptyHint});
  final JournalChapter? previous;
  final bool showEmptyHint;

  Future<void> _deleteSlip(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    if (await confirmDialog(
      context,
      title: l.historyDeleteTitle,
      body: l.historyDeleteBody,
      confirm: l.delete,
      destructive: true,
    )) {
      await ref.read(databaseProvider).deleteRelapse(previous!.endSlip!.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final prev = previous;
    if (prev == null) {
      // The first page of the book: blank, with a hint while nothing is written.
      if (!showEmptyHint) return const SizedBox.expand();
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            l.journalEmpty,
            textAlign: TextAlign.center,
            style: JournalInk.style(14, alpha: 0.55, height: 1.4),
          ),
        ),
      );
    }
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 20, 16, 20),
        child: Column(
          children: [
            Text(
              l.chapterEndedWithSlip,
              textAlign: TextAlign.center,
              style: JournalInk.style(16, alpha: 0.75, height: 1.4),
            ),
            const SizedBox(height: 8),
            // The only place a mistaken slip can be removed; the chapters then merge.
            TextButton(
              onPressed: () => _deleteSlip(context, ref),
              style: TextButton.styleFrom(
                foregroundColor: JournalInk.color.withValues(alpha: 0.55),
                textStyle: JournalInk.style(13),
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(l.historyDeleteTooltip, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

/// One page of a day: two of its four quarters. The left page carries the
/// date, the right page the weekday.
class _DayPage extends StatelessWidget {
  const _DayPage({required this.spread, required this.left});
  final _DaySpread spread;
  final bool left;

  @override
  Widget build(BuildContext context) {
    final first = left ? 0 : 2;
    Widget slot(int i) {
      if (i < spread.entries.length) return _EntrySlot(entry: spread.entries[i]);
      // Today, the next free quarter invites writing.
      if (spread.isToday && i == spread.entries.length) return const _WriteHereSlot();
      return const SizedBox.expand();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(left ? 14 : 16, 12, left ? 16 : 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // One line each, shrinking to fit: long dates like "Setyembre 30, 2026"
          // would otherwise wrap and be cut off.
          SizedBox(
            height: 30,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: left ? Alignment.centerLeft : Alignment.centerRight,
              child: left
                  ? Text(DateFormat.yMMMMd().format(spread.day), maxLines: 1, style: JournalInk.style(18, height: 1.3))
                  : Text(
                      DateFormat.EEEE().format(spread.day),
                      maxLines: 1,
                      style: JournalInk.style(16, alpha: 0.7, height: 1.4),
                    ),
            ),
          ),
          Expanded(child: slot(first)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Center(child: _Ornament(width: 30)),
          ),
          Expanded(child: slot(first + 1)),
        ],
      ),
    );
  }
}

/// One entry in a quarter: its time, a small taped photo and the start of the
/// note. Tap to read it in full, edit or delete it.
class _EntrySlot extends ConsumerWidget {
  const _EntrySlot({required this.entry});
  final JournalEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = ref.watch(journalPhotosProvider).file(entry.photo);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/journal/write?id=${entry.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(DateFormat.jm().format(entry.at), style: JournalInk.style(13, alpha: 0.6, height: 1.2)),
          const SizedBox(height: 4),
          Expanded(
            // Long notes fade out at the bottom; the full text opens on tap.
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (r) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.black, Colors.transparent],
                stops: [0, 0.78, 1],
              ).createShader(r),
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topCenter,
                  maxHeight: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (photo != null) ...[
                        const SizedBox(height: 8),
                        Polaroid(file: photo, maxHeight: 64, compact: true, tilt: entry.id.isEven ? -0.05 : 0.04),
                        const SizedBox(height: 6),
                      ],
                      if (entry.note.isNotEmpty) Text(entry.note, style: JournalInk.style(15, height: 1.35)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The next free quarter on today's spread.
class _WriteHereSlot extends StatelessWidget {
  const _WriteHereSlot();

  @override
  Widget build(BuildContext context) {
    final ink = JournalInk.color.withValues(alpha: 0.4);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/journal/write'),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_edu, color: ink, size: 28),
            const SizedBox(height: 4),
            Text(context.l10n.writeHere, textAlign: TextAlign.center, style: JournalInk.style(16, alpha: 0.45)),
          ],
        ),
      ),
    );
  }
}

/// A small inked divider: a line with a diamond in the middle.
class _Ornament extends StatelessWidget {
  const _Ornament({this.width = 50});
  final double width;

  @override
  Widget build(BuildContext context) {
    final ink = JournalInk.color.withValues(alpha: 0.6);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: width, height: 1.2, color: ink),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(width: 6, height: 6, color: ink),
          ),
        ),
        Container(width: width, height: 1.2, color: ink),
      ],
    );
  }
}
