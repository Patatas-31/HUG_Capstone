// Hug - Profile screen (photo, name, menu, OCPS contact details, log out)

import 'package:material_ui/material_ui.dart';

import '../constants/colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ---------------------------------------------------
  // SAMPLE DATA (TODO: replace with backend data)
  // ---------------------------------------------------
  // The student's info
  static const String fullName = 'Juan Dela A. Cruz';
  static const String studentNumber = '2021-06662-MN-0';

  // OCPS contact details
  static const String ocpsEmail = 'guidance@pup.edu.ph';
  static const String ocpsPhone =
      '(63 2) 335-1PUP (335-1787) or\n335-1777 local 6321';
  static const String ocpsAddress =
      '2/F Charlie del Rosario Student\nDevelopment Center\n'
      'PUP A. Mabini Campus, Anonas St., Sta.\nMesa Manila, Philippines 1016';

  // Colors only used in this screen
  static const Color kBackground = Color(0xFFF4F4F4);

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
                'Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              buildPhoto(),
              const SizedBox(height: 10),
              const Text(
                fullName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                studentNumber,
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 18),
              buildMenuCard(context),
              const SizedBox(height: 12),
              buildContactCard(),
              const SizedBox(height: 12),
              buildLogoutRow(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // PHOTO: round picture with a camera button
  // ---------------------------------------------------
  Widget buildPhoto() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          // Picture placeholder
          // TODO: replace with the user's photo, for example
          // ClipOval(child: Image.network(photoUrl, fit: BoxFit.cover))
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD9D9D9),
            ),
            child: const Icon(Icons.person, size: 60, color: Colors.white),
          ),

          // Camera button at the bottom right
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                // TODO: let the user take or choose a new photo here
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------
  // MENU CARD: list of settings rows
  // ---------------------------------------------------
  Widget buildMenuCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          buildMenuItem(
            icon: Icons.manage_accounts_outlined,
            label: 'Personal Information',
            onTap: () {
              // TODO: open the Personal Information screen here
            },
          ),
          buildMenuItem(
            icon: Icons.notifications_none,
            label: 'Notifications',
            onTap: () {
              // TODO: open the Notifications screen here
            },
          ),
          buildMenuItem(
            icon: Icons.settings_outlined,
            label: 'Account and Security',
            onTap: () {
              // TODO: open the Account and Security screen here
            },
          ),
          buildMenuItem(
            icon: Icons.fact_check_outlined,
            label: 'Terms and Conditions',
            onTap: () {
              // TODO: open the Terms and Conditions screen here
            },
          ),
          buildMenuItem(
            icon: Icons.verified_user_outlined,
            label: 'Privacy Policy',
            onTap: () {
              // TODO: open the Privacy Policy screen here
            },
          ),
        ],
      ),
    );
  }

  // One row of the menu: icon, label and arrow
  Widget buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            const Icon(Icons.chevron_right, size: 24, color: Colors.black),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // OCPS CONTACT CARD: email, phone and address
  // ---------------------------------------------------
  Widget buildContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OCPS Contact Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // TODO: make these tappable (email, call, map) with url_launcher
          buildContactRow(Icons.mail_outline, ocpsEmail),
          const SizedBox(height: 16),
          buildContactRow(Icons.phone_outlined, ocpsPhone),
          const SizedBox(height: 16),
          buildContactRow(Icons.location_on_outlined, ocpsAddress),
        ],
      ),
    );
  }

  // One contact line: icon and text
  Widget buildContactRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.black87),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------
  // LOG OUT ROW
  // ---------------------------------------------------
  Widget buildLogoutRow(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          confirmLogout(context);
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.logout, size: 24, color: kCoral),
              SizedBox(width: 18),
              Text('Log out', style: TextStyle(fontSize: 15, color: kCoral)),
            ],
          ),
        ),
      ),
    );
  }

  // Asks "are you sure?" first, so Log out is not pressed by accident
  Future<void> confirmLogout(BuildContext context) async {
    final bool? sure = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Log out?'),
          content: const Text('You will need to log in again to use Hug.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Log out', style: TextStyle(color: kCoral)),
            ),
          ],
        );
      },
    );

    // The screen may be closed while the dialog was open
    if (sure != true || !context.mounted) return;

    // TODO: clear the saved login (remember me, token) here.
    // pushAndRemoveUntil clears the old screens,
    // so back does not return to the app after logging out.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}
