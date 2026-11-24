// Hug - OTP (verify email) screen

import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/colors.dart';
import '../widgets/collaboration_footer.dart';
import 'login_screen.dart';

class OtpScreen extends StatefulWidget {
  // The email where the code was sent (passed from the Sign up screen)
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController codeController = TextEditingController();
  final FocusNode codeFocus = FocusNode();

  // The code has 6 digits (Supabase default)
  final int codeLength = 6;

  // Seconds the user must wait before pressing "Resend code"
  final int resendSeconds = 60;

  String? codeError;
  bool isVerifying = false;
  bool isResending = false;

  Timer? timer;
  int secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    // The code was just sent, so start the countdown right away
    startCountdown();
  }

  @override
  void dispose() {
    timer?.cancel();
    codeController.dispose();
    codeFocus.dispose();
    super.dispose();
  }

  // Counts down from resendSeconds to 0
  void startCountdown() {
    timer?.cancel();
    setState(() {
      secondsLeft = resendSeconds;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) return;
      if (secondsLeft <= 1) {
        t.cancel();
      }
      setState(() {
        secondsLeft--;
      });
    });
  }

  // Runs when the Verify button is pressed
  Future<void> handleVerify() async {
    final String code = codeController.text.trim();
    if (code.length != codeLength) {
      setState(() {
        codeError = 'Enter the $codeLength-digit code.';
      });
      return;
    }

    setState(() {
      isVerifying = true;
      codeError = null;
    });

    try {
      await Supabase.instance.client.auth.verifyOTP(
        type: OtpType.signup,
        email: widget.email,
        token: code,
      );
      await Supabase.instance.client.auth.signOut();
    } on AuthException {
      if (!mounted) return;
      setState(() {
        isVerifying = false;
        codeError = 'Wrong or expired code. Please try again.';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      isVerifying = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Email verified!')));
    // TODO: change this to the next screen (home or log in)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // Runs when "Resend code" is pressed
  Future<void> handleResend() async {
    setState(() {
      isResending = true;
      codeError = null;
    });

    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        isResending = false;
        codeError = e.message;
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      isResending = false;
    });
    codeController.clear();
    startCountdown();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('A new code was sent.')));
  }

  @override
  Widget build(BuildContext context) {
    final bool canResend = secondsLeft <= 0 && !isResending;

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
                      'Verify your email',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Where the code was sent
                    Text(
                      'We sent a $codeLength-digit code to',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Code box
                    const Text(
                      'Verification Code',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: codeController,
                      focusNode: codeFocus,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      cursorColor: kCoral,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(codeLength),
                      ],
                      onChanged: (String value) {
                        if (codeError != null) {
                          setState(() {
                            codeError = null;
                          });
                        }
                      },
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 10,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: '------',
                        hintStyle: const TextStyle(
                          fontSize: 24,
                          letterSpacing: 10,
                          color: Color(0xFFBDBDBD),
                        ),
                        filled: true,
                        fillColor: kButtonGrey,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (codeError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 6),
                        child: Text(
                          codeError!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    const SizedBox(height: 28),

                    // Verify button
                    Center(
                      child: SizedBox(
                        width: 290,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: isVerifying ? null : handleVerify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kCoral,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: kCoral,
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: isVerifying
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Verify',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Resend link with countdown
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Didn't get the code? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: canResend ? handleResend : null,
                            child: Text(
                              canResend
                                  ? 'Resend'
                                  : isResending
                                  ? 'Sending...'
                                  : 'Resend in ${secondsLeft}s',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: canResend ? kCoral : Colors.black38,
                              ),
                            ),
                          ),
                        ],
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
