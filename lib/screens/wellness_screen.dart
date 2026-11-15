// Hug - Wellness screen (smartwatch status, vitals and PUP OCPS support)

import 'package:material_ui/material_ui.dart';

import '../constants/colors.dart';

class WellnessScreen extends StatelessWidget {
  // Name shown in the smartwatch card (later this can come from the login)
  final String userName;

  const WellnessScreen({super.key, this.userName = 'Juan'});

  // ---------------------------------------------------
  // SAMPLE DATA (TODO: replace with smartwatch / backend data)
  // ---------------------------------------------------
  // Smartwatch card
  static const String lastSynced = 'Just now';
  static const int batteryPercent = 85;
  static const bool isConnected = true;

  // Heart rate card
  static const String heartRateStatus = 'Elevated';
  static const String heartRateValue = '118 bpm';

  // Stress response (EDA) card
  static const String edaStatus = 'High';
  static const String edaValue = '6.5 µS';

  // Sleep duration card
  static const String sleepStatus = 'Short';
  static const String sleepValue = '6h 30min';

  // Colors only used in this screen
  static const Color kBackground = Color(0xFFF4F4F4);
  static const Color kChip = Color(0xFFFBEDEE);
  static const Color kHeartIcon = Color(0xFFB5566B);
  static const Color kEdaIcon = Color(0xFF6B5B95);
  static const Color kSleepIcon = Color(0xFFB59B5E);
  static const Color kConnectedDot = Color(0xFF7ED04B);
  static const Color kWatchBody = Color(0xFF2D3748);
  static const Color kWatchStrap = Color(0xFF8E9099);

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
                'Wellness',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              buildWatchCard(),
              const SizedBox(height: 12),
              buildMetricCard(
                label: 'Heart Rate',
                status: heartRateStatus,
                value: heartRateValue,
                icon: Icons.favorite,
                iconColor: kHeartIcon,
                onTap: () {
                  // TODO: open the Heart Rate details screen here
                },
              ),
              const SizedBox(height: 10),
              buildMetricCard(
                label: 'Stress Response (EDA)',
                status: edaStatus,
                value: edaValue,
                icon: Icons.show_chart,
                iconColor: kEdaIcon,
                onTap: () {
                  // TODO: open the EDA details screen here
                },
              ),
              const SizedBox(height: 10),
              buildMetricCard(
                label: 'Sleep Duration',
                status: sleepStatus,
                value: sleepValue,
                icon: Icons.nightlight_round,
                iconColor: kSleepIcon,
                onTap: () {
                  // TODO: open the Sleep details screen here
                },
              ),
              const SizedBox(height: 10),
              buildOcpsCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // SMARTWATCH CARD: watch picture, name, sync, battery, status
  // ---------------------------------------------------
  Widget buildWatchCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: kCoral,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          buildWatchPicture(),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Smartwatch name
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "$userName's Smartwatch",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Last sync and battery
                Text(
                  'Last synced: $lastSynced  ·  Battery $batteryPercent%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
                const SizedBox(height: 12),
                buildConnectedPill(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // White pill with a green dot (changes to Disconnected when not connected)
  Widget buildConnectedPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected ? kConnectedDot : Colors.grey,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isConnected ? 'Connected' : 'Disconnected',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // The watch drawn with simple shapes (TODO: replace with your image if you have one)
  Widget buildWatchPicture() {
    return SizedBox(
      width: 78,
      height: 112,
      child: Stack(
        children: [
          // Top strap
          Positioned(
            top: 0,
            left: 16,
            child: Container(
              width: 42,
              height: 34,
              decoration: BoxDecoration(
                color: kWatchStrap,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Bottom strap
          Positioned(
            bottom: 0,
            left: 16,
            child: Container(
              width: 42,
              height: 34,
              decoration: BoxDecoration(
                color: kWatchStrap,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Watch body with a heart and a pulse line
          Positioned(
            top: 18,
            left: 0,
            child: Container(
              width: 74,
              height: 76,
              decoration: BoxDecoration(
                color: kWatchBody,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, color: kCoral, size: 26),
                  SizedBox(height: 2),
                  Icon(Icons.show_chart, color: kStarYellow, size: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------
  // METRIC CARD: icon, label, big status, value chip, caption
  // ---------------------------------------------------
  Widget buildMetricCard({
    required String label,
    required String status,
    required String value,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              // Icon on the left
              SizedBox(
                width: 76,
                child: Center(child: Icon(icon, size: 46, color: iconColor)),
              ),
              const SizedBox(width: 6),

              // Texts on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label and value chip on the same row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: kChip,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 11, color: kCoral),
                          ),
                        ),
                      ],
                    ),
                    // Big status word
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Text(
                      'Captured by your smartwatch',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // PUP OCPS CARD: support message and contact button
  // ---------------------------------------------------
  Widget buildOcpsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo placeholder
              // TODO: replace with Image.asset('assets/images/ocps_logo.png')
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: const Icon(
                  Icons.volunteer_activism_outlined,
                  color: kCoral,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Talk to PUP OCPS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Your recent patterns suggest extra support could help. '
                      'The Office of Counseling and Psychological Services '
                      'is here to listen.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Contact button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                // TODO: open the OCPS contact details screen here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kCoral,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'View OCPS contact details',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
