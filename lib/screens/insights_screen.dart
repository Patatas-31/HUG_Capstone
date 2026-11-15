// Hug - Insights screen (mood tracker, summary and mood calendar)

import 'dart:math';
import 'package:material_ui/material_ui.dart';
import '../constants/colors.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  // ---------------------------------------------------
  // SAMPLE DATA (TODO: replace with backend data)
  // ---------------------------------------------------
  // Text shown under "Mood Tracker"
  static const String weekRange = 'Oct 25 - 31, 2026';

  // Day labels under the bars
  static const List<String> weekLabels = [
    '25', '26', '27', '28', '29', '30', '31',
  ];

  // Bar heights from 0.0 (short) to 1.0 (tallest)
  static const List<double> weekValues = [
    0.28, 0.12, 0.45, 1.0, 0.5, 0.75, 0.12,
  ];

  // Which bar is highlighted and the label above it
  static const int highlightedBar = 2;
  static const String highlightedLabel = 'Okay';

  // Summary card
  static const int checkIns = 10;
  static const String averageMood = 'Calm (Average Mood)';

  // Calendar month to show
  static const int calendarYear = 2026;
  static const int calendarMonth = 10;
  static const String calendarTitle = 'October 2026';

  // Mood per day: 1 = very bad ... 5 = very good (days with no data stay gray)
  static const Map<int, int> calendarMoods = {
    25: 3,
    26: 4,
    27: 3,
    28: 5,
    29: 4,
    30: 5,
    31: 4,
  };

  // Colors only used in this screen
  static const Color kBackground = Color(0xFFF4F4F4);
  static const Color kBarLight = Color(0xFFF6B5B8);
  static const Color kBarDark = Color(0xFFE8707A);
  static const Color kEmptyDay = Color(0xFFD9D9D9);

  // Height of the tallest bar
  static const double maxBarHeight = 140;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackground,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // Extra space at the bottom so the bottom bar does not cover content
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
          child: Column(
            children: [
              const Text(
                'Insights',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              buildCard(title: 'Mood Tracker', child: buildMoodTracker()),
              const SizedBox(height: 16),
              buildSummaryCard(),
              const SizedBox(height: 16),
              buildCard(title: 'Mood Calendar', child: buildCalendar()),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // White card with a title and a thin line under it
  // ---------------------------------------------------
  Widget buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // ---------------------------------------------------
  // MOOD TRACKER: date range, color legend and weekly bars
  // ---------------------------------------------------
  Widget buildMoodTracker() {
    return Column(
      children: [
        const Text(
          weekRange,
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Color legend (green = good mood, red = bad mood)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 14,
                  height: maxBarHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF2EAA4A),
                        Color(0xFFE0B341),
                        Color(0xFFF0443C),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22), // lines up with the day labels
              ],
            ),
            const SizedBox(width: 14),

            // The 7 bars
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (int i = 0; i < weekValues.length; i++) buildBar(i),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // One bar with its day label (and a small note above if highlighted)
  Widget buildBar(int index) {
    final bool highlighted = index == highlightedBar;

    return SizedBox(
      width: 24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Small label above the highlighted bar
          if (highlighted)
            const Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Text(
                highlightedLabel,
                style: TextStyle(fontSize: 8, color: Colors.black54),
              ),
            ),
          Container(
            width: 24,
            height: maxBarHeight * weekValues[index],
            decoration: BoxDecoration(
              color: highlighted ? kBarDark : kBarLight,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            weekLabels[index],
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------
  // SUMMARY CARD: number of check-ins and average mood
  // ---------------------------------------------------
  Widget buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCoral,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kStarYellow,
                  ),
                ),
                const Text(
                  '$checkIns Check-ins',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  averageMood,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
          // Smiley face
          const SizedBox(
            width: 56,
            height: 56,
            child: CustomPaint(painter: MoodSmilePainter()),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------
  // MOOD CALENDAR: month title, weekday names and day cells
  // ---------------------------------------------------
  Widget buildCalendar() {
    const List<String> weekdays = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
    ];

    // weekday: Monday = 1 ... Sunday = 7, so Monday needs 0 blank cells
    final int blanks = DateTime(calendarYear, calendarMonth, 1).weekday - 1;
    final int daysInMonth = DateTime(calendarYear, calendarMonth + 1, 0).day;

    // Total cells rounded up to full weeks (7 per row)
    final int totalCells = ((blanks + daysInMonth + 6) ~/ 7) * 7;

    // Build the rows week by week
    final List<Widget> rows = [];
    for (int start = 0; start < totalCells; start += 7) {
      final List<Widget> cells = [];
      for (int c = start; c < start + 7; c++) {
        final int day = c - blanks + 1;
        final bool isDay = day >= 1 && day <= daysInMonth;
        cells.add(Expanded(child: isDay ? buildDayCell(day) : const SizedBox()));
      }
      rows.add(Row(children: cells));
    }

    return Column(
      children: [
        const Text(
          calendarTitle,
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        // Weekday names
        Row(
          children: [
            for (final String d in weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        ...rows,
      ],
    );
  }

  // One day: number on top and a colored square below
  Widget buildDayCell(int day) {
    final int? mood = calendarMoods[day];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: Column(
        children: [
          Text(
            '$day',
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Container(
            height: 26,
            decoration: BoxDecoration(
              color: moodColor(mood),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  // Color for a mood score (gray when there is no check-in that day)
  Color moodColor(int? mood) {
    switch (mood) {
      case 5:
        return const Color(0xFF2EAA4A);
      case 4:
        return const Color(0xFF9CCC65);
      case 3:
        return const Color(0xFFE0B341);
      case 2:
        return const Color(0xFFFF8A3D);
      case 1:
        return const Color(0xFFF0443C);
      default:
        return kEmptyDay;
    }
  }
}

// =====================================================
// SMILEY FACE (white circle with coral eyes and smile)
// =====================================================
class MoodSmilePainter extends CustomPainter {
  const MoodSmilePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // White circle
    final Paint face = Paint();
    face.color = Colors.white;
    face.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w / 2, h / 2), w / 2, face);

    // Eyes
    final Paint eye = Paint();
    eye.color = kCoral;
    eye.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.35, h * 0.38), w * 0.06, eye);
    canvas.drawCircle(Offset(w * 0.65, h * 0.38), w * 0.06, eye);

    // Smile (bottom half of an oval)
    final Paint pen = Paint();
    pen.color = kCoral;
    pen.style = PaintingStyle.stroke;
    pen.strokeWidth = 3.5;
    pen.strokeCap = StrokeCap.round;

    final Rect mouth = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.55),
      width: w * 0.5,
      height: h * 0.34,
    );
    canvas.drawArc(mouth, 0, pi, false, pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
