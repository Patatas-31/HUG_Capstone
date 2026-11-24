// Hug - Forgot password screen (step 1: enter email)

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../widgets/collaboration_footer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocus = FocusNode();

  // Red error message under the box (null = no error)
  String? emailError;

  // true = we are waiting for the backend
  bool isSending = false;

  // true = the button was pressed at least once (errors update live after)
  bool submitted = false;

  final int maxEmailLength = 100;

  // Email format: name@domain.com
  final RegExp emailPattern =
      RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$');

  @override
  void dispose() {
    emailController.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  // Email check. Returns an error text, or null if it is OK.
  String? validateEmail() {
    final String value = emailController.text.trim();
    if (value.isEmpty) {
      return 'Email is required.';
    }
    if (value.length > maxEmailLength) {
      return 'Email must be $maxEmailLength characters or less.';
    }
    if (!emailPattern.hasMatch(value) || value.contains('..')) {
      return 'Enter a valid email. Example: name@gmail.com';
    }
    return null;
  }

  // Runs when the Send code button is pressed
  Future<void> handleSend() async {
    submitted = true;
    final String? error = validateEmail();
    setState(() {
      emailError = error;
    });
    if (error != null) {
      emailFocus.requestFocus();
      return;
    }

    setState(() {
      isSending = true;
    });

    // TODO: send the reset code to emailController.text.trim().toLowerCase()
    // (Supabase: auth.resetPasswordForEmail)

    if (!mounted) return;
    setState(() {
      isSending = false;
    });

    // TODO: go to the OTP screen, then to ResetPasswordScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Back arrow
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Title
                    const Text(
                      'Forgot password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Enter the email you used to sign up. '
                      "We'll send a code to reset your password.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 28),

                    // Email
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      focusNode: emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: kCoral,
                      inputFormatters: [
                        // No spaces in an email
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        LengthLimitingTextInputFormatter(maxEmailLength),
                      ],
                      onChanged: (String value) {
                        if (!submitted) return;
                        setState(() {
                          emailError = validateEmail();
                        });
                      },
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFBDBDBD),
                        ),
                        filled: true,
                        fillColor: kButtonGrey,
                        prefixIcon: const SizedBox(
                          width: 60,
                          child: Center(
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.black54,
                              size: 24,
                            ),
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 6),
                        child: Text(
                          emailError!,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 28),

                    // Send code button
                    Center(
                      child: SizedBox(
                        width: 290,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: isSending ? null : handleSend,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kCoral,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: kCoral,
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Send code',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Back to Log in
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Back to Log in',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: kCoral,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Footer
            const SizedBox(height: 12),
            const CollaborationFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
