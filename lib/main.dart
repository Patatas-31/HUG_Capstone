// Hug - app entry point
// This file only starts the app and picks the first screen.

import 'package:material_ui/material_ui.dart';
import 'package:hug/screens/get_started_screen.dart';

// Starts the app
void main() {
  runApp(const HugApp());
}

class HugApp extends StatelessWidget {
  const HugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hug',
      // The app starts on the Get Started screen
      home: GetStartedScreen(),
    );
  }
}