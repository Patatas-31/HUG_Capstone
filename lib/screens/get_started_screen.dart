// Hug - Get Started screen (first screen of the app)

import 'package:material_ui/material_ui.dart';
import '../constants/colors.dart';
import '../widgets/collaboration_footer.dart';
import '../widgets/star_painter.dart';
import 'welcome_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Title
              const Text(
                'Your mental\nhealth matters!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  color: Colors.black,
                ),
              ),
              const Spacer(flex: 2),

              // Star mascot (straight, no motion lines)
              const SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(painter: StarPainter()),
              ),
              const Spacer(flex: 2),

              // Description
              const Text(
                "Let's get you set up to monitor your wellness\ntrends and find the support you deserve.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.7,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 22),

              // Get Started button
              SizedBox(
                width: 140,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    // Go to the Welcome screen.
                    // "push" keeps this screen behind, so back returns here.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kCoral,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text('→', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 4),

              // Footer
              const CollaborationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
