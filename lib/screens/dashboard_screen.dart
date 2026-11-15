// Hug - Dashboard (home) screen

import 'dart:math';
import 'package:material_ui/material_ui.dart';
import '../constants/colors.dart';
import '../widgets/star_painter.dart';

class DashboardScreen extends StatefulWidget {
  // Name shown in the greeting (later this can come from the login)
  final String userName;

  const DashboardScreen({super.key, this.userName = 'Juan'});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Which tab of the bottom bar is selected (0 = Home)
  int selectedTab = 0;

  // Sample data (later this can come from the sensors or database)
  final int wellnessScore = 70;
  final String mood = 'STRESSED';
  final String moodNote = 'Feeling Pressured';
  final String heartRate = '118';
  final String eda = '6.5';
  final String sleep = '6h 30m';

  // Colors only used in this screen
  static const Color kBackground = Color(0xFFF4F4F4);
  static const Color kHeartCard = Color(0xFFFDDDE0);
  static const Color kEdaCard = Color(0xFFD9D2EC);
  static const Color kSleepCard = Color(0xFFF8EFD8);

  // Today's date as text, like "November 2, 2026"
  String todayText() {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final DateTime now = DateTime.now();
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Scrollable content
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    const SizedBox(height: 18),
                    buildCheckInCard(),
                    const SizedBox(height: 14),
                    buildMoodCard(),
                    const SizedBox(height: 22),
                    const Text(
                      'Vitals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildVitalsRow(),
                  ],
                ),
              ),
            ),

            // Bottom bar with the big star button
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: buildBottomBar(context),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // HEADER: greeting, date and bell button
  // ---------------------------------------------------
  Widget buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${widget.userName}!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                todayText(),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        // Notification bell button
        IconButton(
          onPressed: () {
            // TODO: open the Notifications screen here
          },
          icon: const Icon(
            Icons.notifications_none,
            size: 28,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------
  // BIG CORAL CARD: Daily Check In + wellness ring
  // ---------------------------------------------------
  Widget buildCheckInCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCoral,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Daily Check In" button (white pill)
                GestureDetector(
                  onTap: () {
                    // TODO: open the Daily Check In screen here
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Daily Check In',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Wellness\nLooks Off Balance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Wellness ring with the score inside
          SizedBox(
            width: 92,
            height: 92,
            child: CustomPaint(
              painter: WellnessRingPainter(progress: wellnessScore / 100),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$wellnessScore',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: kStarYellow,
                      ),
                    ),
                    const Text(
                      'Wellness',
                      style: TextStyle(fontSize: 11, color: kStarYellow),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------
  // MOOD CARD: face, mood text and mini bars
  // ---------------------------------------------------
  Widget buildMoodCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // TODO: open the Mood details screen here
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Angry face
              const SizedBox(
                width: 58,
                height: 58,
                child: CustomPaint(painter: MoodFacePainter()),
              ),
              const SizedBox(width: 14),

              // Mood texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Mood Today',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mood,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      moodNote,
                      style:
                      const TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              // Mini bars (first one is red)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildMoodBar(34, const Color(0xFFF0443C)),
                  buildMoodBar(16, const Color(0xFFDADADA)),
                  buildMoodBar(16, const Color(0xFFDADADA)),
                  buildMoodBar(16, const Color(0xFFDADADA)),
                  buildMoodBar(16, const Color(0xFFDADADA)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // One small bar of the mood chart
  Widget buildMoodBar(double height, Color color) {
    return Container(
      width: 14,
      height: height,
      margin: const EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // ---------------------------------------------------
  // VITALS: heart rate, EDA, sleep
  // ---------------------------------------------------
  Widget buildVitalsRow() {
    return Row(
      children: [
        Expanded(
          child: buildVitalCard(
            title: 'Heart Rate',
            icon: Icons.favorite_border,
            iconColor: const Color(0xFFD9606A),
            value: heartRate,
            unit: 'bpm',
            color: kHeartCard,
            onTap: () {
              // TODO: open the Heart Rate details screen here
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildVitalCard(
            title: 'EDA',
            icon: Icons.monitor_heart_outlined,
            iconColor: const Color(0xFF6B5B95),
            value: eda,
            unit: 'µS',
            color: kEdaCard,
            onTap: () {
              // TODO: open the EDA details screen here
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildVitalCard(
            title: 'Sleep',
            icon: Icons.nightlight_outlined,
            iconColor: const Color(0xFFB59B5E),
            value: sleep,
            unit: 'Last night',
            color: kSleepCard,
            onTap: () {
              // TODO: open the Sleep details screen here
            },
          ),
        ),
      ],
    );
  }

  // One vital card (pink, purple or cream)
  Widget buildVitalCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              Center(child: Icon(icon, size: 36, color: iconColor)),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                unit,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // BOTTOM BAR: Home, Insights, big star, Wellness, Profile
  // ---------------------------------------------------
  Widget buildBottomBar(BuildContext context) {
    // Space for the phone's bottom gesture area
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: 100 + bottomInset,
      child: Stack(
        children: [
          // White bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 68 + bottomInset,
            child: Container(
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildNavItem(0, Icons.home_outlined, 'Home'),
                  buildNavItem(1, Icons.bar_chart, 'Insights'),
                  const SizedBox(width: 80), // empty space for the star
                  buildNavItem(2, Icons.monitor_heart_outlined, 'Wellness'),
                  buildNavItem(3, Icons.account_circle_outlined, 'Profile'),
                ],
              ),
            ),
          ),

          // Big star button in the middle
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                // TODO: open the Hug companion / chat screen here
              },
              child: Container(
                width: 74,
                height: 74,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kCoral,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: CustomPaint(
                    painter: StarPainter(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // One tab of the bottom bar
  Widget buildNavItem(int index, IconData icon, String label) {
    final bool selected = selectedTab == index;
    final Color color = selected ? kCoral : const Color(0xFF8E8E8E);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          selectedTab = index;
        });
        // TODO: show the screen for the selected tab here
        // (0 = Home, 1 = Insights, 2 = Wellness, 3 = Profile)
      },
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// WELLNESS RING (circle that fills up to the score)
// =====================================================
class WellnessRingPainter extends CustomPainter {
  // 0.0 = empty, 1.0 = full circle
  final double progress;

  const WellnessRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const double stroke = 10;
    final Rect rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );

    // Light pink circle behind
    final Paint track = Paint();
    track.color = const Color(0xFFF2A3A6);
    track.style = PaintingStyle.stroke;
    track.strokeWidth = stroke;
    canvas.drawArc(rect, 0, 2 * pi, false, track);

    // Yellow part that shows the score (starts at the top)
    final Paint bar = Paint();
    bar.color = kStarYellow;
    bar.style = PaintingStyle.stroke;
    bar.strokeWidth = stroke;
    bar.strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, bar);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! WellnessRingPainter ||
        oldDelegate.progress != progress;
  }
}

// =====================================================
// MOOD FACE (angry face drawn with code)
// =====================================================
class MoodFacePainter extends CustomPainter {
  const MoodFacePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Red circle
    final Paint face = Paint();
    face.color = const Color(0xFFF0443C);
    face.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w / 2, h / 2), w / 2, face);

    // Black pen for eyebrows and mouth
    final Paint pen = Paint();
    pen.color = Colors.black;
    pen.style = PaintingStyle.stroke;
    pen.strokeWidth = 3.5;
    pen.strokeCap = StrokeCap.round;

    // Angry eyebrows (slanted down toward the middle)
    canvas.drawLine(Offset(w * 0.20, h * 0.28), Offset(w * 0.44, h * 0.42), pen);
    canvas.drawLine(Offset(w * 0.80, h * 0.28), Offset(w * 0.56, h * 0.42), pen);

    // Eyes: white circle with a black dot
    final Paint white = Paint();
    white.color = Colors.white;
    white.style = PaintingStyle.fill;

    final Paint black = Paint();
    black.color = Colors.black;
    black.style = PaintingStyle.fill;

    final List<Offset> eyes = [Offset(w * 0.33, h * 0.53), Offset(w * 0.67, h * 0.53)];
    for (final Offset e in eyes) {
      canvas.drawCircle(e, w * 0.09, white);
      canvas.drawCircle(e, w * 0.045, black);
    }

    // Frown (curve that goes up in the middle)
    final Rect mouth = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.82),
      width: w * 0.36,
      height: h * 0.20,
    );
    canvas.drawArc(mouth, pi, pi, false, pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
