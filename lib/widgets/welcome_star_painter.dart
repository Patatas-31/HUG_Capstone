// Hug - star mascot for the Welcome screen (tilted star + motion lines)

import 'dart:math';
import 'package:material_ui/material_ui.dart';
import '../constants/colors.dart';

class WelcomeStarPainter extends CustomPainter {
  const WelcomeStarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Black pen used for the motion lines and the glasses
    final Paint line = Paint();
    line.color = Colors.black;
    line.style = PaintingStyle.stroke;
    line.strokeWidth = 2.2;
    line.strokeCap = StrokeCap.round;

    // Two small motion lines at the top-left of the star
    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.10),
      Offset(size.width * 0.11, size.height * 0.20),
      line,
    );
    canvas.drawLine(
      Offset(size.width * 0.17, size.height * 0.07),
      Offset(size.width * 0.20, size.height * 0.17),
      line,
    );

    // Center point and the two radii of the star
    final Offset center = Offset(size.width * 0.58, size.height * 0.58);
    final double outer = size.width * 0.42;
    final double inner = outer * 0.48;

    // Tilt the whole star a little to the left, like in the design
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.2);
    canvas.translate(-center.dx, -center.dy);

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
    fill.color = kStarYellow;
    fill.style = PaintingStyle.fill;
    canvas.drawPath(path, fill);

    // Rounded corners (thick stroke of the same color)
    final Paint edge = Paint();
    edge.color = kStarYellow;
    edge.style = PaintingStyle.stroke;
    edge.strokeWidth = size.width * 0.06;
    edge.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, edge);

    // Glasses and happy eyes
    final double eyeR = size.width * 0.06;
    final double gap = size.width * 0.07;
    final double eyeY = center.dy - size.height * 0.13;
    final Offset left = Offset(center.dx - gap, eyeY);
    final Offset right = Offset(center.dx + gap, eyeY);

    final Paint white = Paint();
    white.color = Colors.white;
    white.style = PaintingStyle.fill;

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

    // Go back to the normal (not tilted) canvas
    canvas.restore();
  }

  // The star never changes, so it does not need to repaint
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
