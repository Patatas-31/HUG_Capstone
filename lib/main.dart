
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hug/screens/get_started_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fyauekwhdylocfzzknjt.supabase.co',
    publishableKey: 'sb_publishable_zcF8B2eQ0F_tHrW_mkKwaw_Vn9fzenf',
  );

  runApp(const HugApp());
}

class HugApp extends StatelessWidget {
  const HugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hug',
      home: GetStartedScreen(),
    );
  }
}
