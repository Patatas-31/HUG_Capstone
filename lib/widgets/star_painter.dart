// Hug - star mascot for the Get Started screen (straight star)

import 'dart:math';
import 'package:material_ui/material_ui.dart';
import '../constants/colors.dart';

class StarPainter extends CustomPainter {
  // Color of the star (yellow by default)
  final Color color;

  const StarPainter({this.color = kStarYellow});

  @override
  void paint(Canvas canvas, Size size) {
    // Center point and the two radii of the star
    final Offset center = Offset(size.width / 2, size.height * 0.54);
    final double outer = size.width * 0.46;
    final double inner = outer * 0.5;

    // Five-point star shape
    final Path path = Path();
    for (int i = 0; i < 10; i++) {
      final double r = (i % 2 == 0) ? outer : inner;
      final double a = -pi / 2 + i * pi / 5;
      final double x = center.dx + r * cos(a);
      final double y = center.dy + r * sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Fill the star
    final Paint fill = Paint();
    fill.color = color;
    fill.style = PaintingStyle.fill;
    canvas.drawPath(path, fill);

    // Rounded corners (thick stroke of the same color)
    final Paint edge = Paint();
    edge.color = color;
    edge.style = PaintingStyle.stroke;
    edge.strokeWidth = size.width * 0.12;
    edge.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, edge);

    // Glasses and happy eyes
    final double eyeR = size.width * 0.075;
    final double gap = size.width * 0.085;
    final double eyeY = center.dy - size.height * 0.03;
    final Offset left = Offset(center.dx - gap, eyeY);
    final Offset right = Offset(center.dx + gap, eyeY);

    final Paint white = Paint();
    white.color = Colors.white;
    white.style = PaintingStyle.fill;

    final Paint line = Paint();
    line.color = Colors.black;
    line.style = PaintingStyle.stroke;
    line.strokeWidth = 1.8;
    line.strokeCap = StrokeCap.round;

    // Draw both lenses and the happy eye arc inside each one
    final List<Offset> eyes = [left, right];
    for (final Offset o in eyes) {
      canvas.drawCircle(o, eyeR, white);
      canvas.drawCircle(o, eyeR, line);

      final Offset eyeCenter = Offset(o.dx, o.dy + eyeR * 0.25);
      final Rect happy = Rect.fromCenter(
        center: eyeCenter,
        width: eyeR * 1.1,
        height: eyeR * 1.0,
      );
      canvas.drawArc(happy, pi, pi, false, line);
    }

    // Bridge between the glasses
    final Offset bridgeStart = Offset(left.dx + eyeR, left.dy);
    final Offset bridgeEnd = Offset(right.dx - eyeR, right.dy);
    canvas.drawLine(bridgeStart, bridgeEnd, line);
  }

  // Only repaint when the color changes
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! StarPainter || oldDelegate.color != color;
  }
}