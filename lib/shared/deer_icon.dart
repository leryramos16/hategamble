import 'package:flutter/material.dart';

/// A deer head with antlers, a symbol of peace. Material has no deer icon, so
/// it's drawn here on a 24x24 grid like the built-in icons. Follows the
/// surrounding [IconTheme] (color and size), so it works in navigation bars.
class DeerIcon extends StatelessWidget {
  const DeerIcon({super.key, this.filled = false, this.size, this.color});

  /// Solid head (for selected states) instead of an outline.
  final bool filled;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final s = size ?? theme.size ?? 24;
    // Centered so a parent that stretches its children (like a dialog's icon
    // slot) can't widen it; the painter also scales evenly.
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: SizedBox.square(
        dimension: s,
        child: CustomPaint(painter: _DeerPainter(color ?? theme.color ?? Colors.black, filled)),
      ),
    );
  }
}

class _DeerPainter extends CustomPainter {
  _DeerPainter(this.color, this.filled);
  final Color color;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    // Even scaling, centered, so the deer never stretches.
    final scale = (size.width < size.height ? size.width : size.height) / 24;
    canvas.translate((size.width - 24 * scale) / 2, (size.height - 24 * scale) / 2);
    canvas.scale(scale);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = color;

    // Antlers: a main beam on each side with two tines.
    final antlers = Path()
      ..moveTo(10.2, 10.4)
      ..quadraticBezierTo(8.6, 7.4, 7.2, 3.6)
      ..moveTo(8.7, 7.4)
      ..lineTo(5.3, 6.6)
      ..moveTo(7.8, 5.4)
      ..lineTo(9.1, 2.9)
      ..moveTo(13.8, 10.4)
      ..quadraticBezierTo(15.4, 7.4, 16.8, 3.6)
      ..moveTo(15.3, 7.4)
      ..lineTo(18.7, 6.6)
      ..moveTo(16.2, 5.4)
      ..lineTo(14.9, 2.9);
    canvas.drawPath(antlers, stroke);

    // Ears, angled out from the head.
    final ears = Path()
      ..moveTo(9.4, 11.6)
      ..quadraticBezierTo(5.6, 10.4, 4.6, 11.6)
      ..quadraticBezierTo(6.2, 13.6, 9.0, 13.4)
      ..close()
      ..moveTo(14.6, 11.6)
      ..quadraticBezierTo(18.4, 10.4, 19.4, 11.6)
      ..quadraticBezierTo(17.8, 13.6, 15.0, 13.4)
      ..close();
    canvas.drawPath(ears, filled ? fill : stroke);

    // Head: wide at the brow, narrowing to the muzzle.
    final head = Path()
      ..moveTo(12, 10.2)
      ..cubicTo(14.4, 10.2, 15.6, 11.6, 15.2, 13.8)
      ..cubicTo(14.8, 16.4, 13.4, 19.8, 12, 20.8)
      ..cubicTo(10.6, 19.8, 9.2, 16.4, 8.8, 13.8)
      ..cubicTo(8.4, 11.6, 9.6, 10.2, 12, 10.2)
      ..close();
    canvas.drawPath(head, filled ? fill : stroke);

    // Nose: a dot of the background color when filled, solid when outlined.
    if (!filled) canvas.drawCircle(const Offset(12, 19.4), 0.9, fill);
  }

  @override
  bool shouldRepaint(covariant _DeerPainter old) => old.color != color || old.filled != filled;
}
