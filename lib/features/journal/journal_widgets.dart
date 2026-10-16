import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Pieces of the old leather-bound journal, in the spirit of a frontier diary:
/// stitched leather cover, aged parchment with worn edges and stains, pen-and-ink
/// cursive, and photos taped in like polaroids. Everything is painted in code,
/// so no image assets are needed.
class JournalInk {
  static const color = Color(0xFF2A1A0E);
  static const fontFamily = 'CedarvilleCursive';

  static TextStyle style(double size, {double alpha = 1, double height = 1.45}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        height: height,
        color: color.withValues(alpha: alpha),
      );
}

/// Stitched leather cover around [child].
class JournalCover extends StatelessWidget {
  const JournalCover({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5A3822), Color(0xFF3A2314), Color(0xFF2B190E)],
        ),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: CustomPaint(
        foregroundPainter: _StitchPainter(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ClipRRect(borderRadius: BorderRadius.circular(8), child: child),
        ),
      ),
    );
  }
}

/// A sheet of aged parchment behind [child]. [seed] varies the stains per page.
class Parchment extends StatelessWidget {
  const Parchment({super.key, required this.child, this.seed = 7});
  final Widget child;
  final int seed;

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _ParchmentPainter(seed), child: child);
}

/// The date written at the top right of a page, with an ink flourish under it.
class PageDate extends StatelessWidget {
  const PageDate(this.date, {super.key});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(DateFormat.yMMMMd().format(date), textAlign: TextAlign.right, style: JournalInk.style(20, height: 1.2)),
        const SizedBox(height: 2),
        CustomPaint(size: const Size(140, 10), painter: _FlourishPainter()),
      ],
    );
  }
}

/// A photo taped onto the page like a polaroid, slightly tilted.
class Polaroid extends StatelessWidget {
  const Polaroid({super.key, required this.file, this.tilt = -0.035, this.maxHeight = 220, this.compact = false});
  final File file;
  final double tilt;
  final double maxHeight;

  /// Smaller border and tape, for thumbnails on a half page.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: tilt,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: compact ? const EdgeInsets.fromLTRB(4, 4, 4, 11) : const EdgeInsets.fromLTRB(8, 8, 8, 22),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF7EE),
                boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(1, 3))],
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: Image.file(file, fit: BoxFit.contain, gaplessPlayback: true),
              ),
            ),
            // A strip of old tape holding it to the page.
            Positioned(
              top: compact ? -6 : -10,
              left: 0,
              right: 0,
              child: Center(
                child: Transform.rotate(
                  angle: 0.06,
                  child: Container(
                    width: compact ? 36 : 70,
                    height: compact ? 11 : 20,
                    color: const Color(0xFFE8D9AE).withValues(alpha: 0.85),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Today's journal entry: an editable page with the date, an optional taped
/// photo, and the entry written in ink.
class JournalPage extends StatelessWidget {
  const JournalPage({super.key, required this.controller, required this.date, this.hint, this.photo});
  final TextEditingController controller;
  final DateTime date;
  final String? hint;
  final File? photo;

  @override
  Widget build(BuildContext context) {
    return JournalCover(
      child: Parchment(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageDate(date),
              if (photo != null) ...[
                const SizedBox(height: 22),
                Polaroid(file: photo!),
              ],
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                minLines: photo == null ? 7 : 4,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: JournalInk.color,
                cursorWidth: 1.5,
                style: JournalInk.style(22, height: 1.55),
                // Plain ink on paper: override the app's filled, bordered fields.
                decoration: InputDecoration(
                  isCollapsed: true,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: hint,
                  hintStyle: JournalInk.style(22, alpha: 0.35, height: 1.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dashed thread stitched around the leather cover.
class _StitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC9A26B).withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-4, -4, size.width + 8, size.height + 8),
      const Radius.circular(13),
    );
    for (final metric in (Path()..addRRect(rect)).computeMetrics()) {
      for (double d = 0; d < metric.length; d += 10) {
        canvas.drawPath(metric.extractPath(d, math.min(d + 6, metric.length)), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Aged parchment: warm base, darkened worn edges, faint stains, a coffee ring
/// and specks. Seeded, so each page always looks the same.
class _ParchmentPainter extends CustomPainter {
  _ParchmentPainter(this.seed);
  final int seed;

  static const _edge = Color(0xFF7A5730);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base paper, lighter towards the upper middle.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.2, -0.4),
          radius: 1.3,
          colors: [Color(0xFFF3E7CB), Color(0xFFE6D2A8), Color(0xFFCDAF79)],
          stops: [0, 0.6, 1],
        ).createShader(rect),
    );

    // Worn, darker edges.
    const band = 22.0;
    void edge(Rect r, Alignment begin, Alignment end) => canvas.drawRect(
          r,
          Paint()
            ..shader = LinearGradient(
              begin: begin,
              end: end,
              colors: [_edge.withValues(alpha: 0.38), _edge.withValues(alpha: 0)],
            ).createShader(r),
        );
    edge(Rect.fromLTWH(0, 0, size.width, band), Alignment.topCenter, Alignment.bottomCenter);
    edge(Rect.fromLTWH(0, size.height - band, size.width, band), Alignment.bottomCenter, Alignment.topCenter);
    edge(Rect.fromLTWH(0, 0, band, size.height), Alignment.centerLeft, Alignment.centerRight);
    edge(Rect.fromLTWH(size.width - band, 0, band, size.height), Alignment.centerRight, Alignment.centerLeft);

    final rnd = math.Random(seed);

    // Soft blotches and water stains.
    for (var i = 0; i < 16; i++) {
      final r = 10 + rnd.nextDouble() * 38;
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        r,
        Paint()
          ..color = _edge.withValues(alpha: 0.03 + rnd.nextDouble() * 0.05)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r / 2),
      );
    }

    // A faint coffee ring on some pages.
    if (seed % 3 != 1) {
      canvas.drawCircle(
        Offset(size.width * (0.7 + rnd.nextDouble() * 0.15), size.height * (0.75 + rnd.nextDouble() * 0.1)),
        30,
        Paint()
          ..color = const Color(0xFF6E4A27).withValues(alpha: 0.13)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }

    // Tiny specks in the paper.
    final speck = Paint()..color = const Color(0xFF5A3E22).withValues(alpha: 0.18);
    for (var i = 0; i < 70; i++) {
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        0.4 + rnd.nextDouble() * 0.8,
        speck,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParchmentPainter oldDelegate) => oldDelegate.seed != seed;
}

/// A hand-drawn ink flourish under the date.
class _FlourishPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height / 2;
    final path = Path()
      ..moveTo(0, h + 1)
      ..quadraticBezierTo(size.width * 0.25, h - 4, size.width * 0.5, h)
      ..quadraticBezierTo(size.width * 0.75, h + 4, size.width, h - 2);
    canvas.drawPath(
      path,
      Paint()
        ..color = JournalInk.color.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
