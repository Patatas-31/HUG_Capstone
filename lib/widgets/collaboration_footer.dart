// Hug - footer shown on the bottom of the screens

import 'package:material_ui/material_ui.dart';
import '../constants/colors.dart';

class CollaborationFooter extends StatelessWidget {
  const CollaborationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo placeholder (swap for Image.asset(...) if you add the real logo)
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kCoral,
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Collaboration with the OCPS of\nPolytechnic University of the Philippines',
          style: TextStyle(fontSize: 9, height: 1.3),
        ),
      ],
    );
  }
}
