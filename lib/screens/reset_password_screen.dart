// Hug - Reset password screen (step 3: set a new password)

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../widgets/collaboration_footer.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  // true = password is hidden, false = password is shown
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  // Red error message under each box (null = no error)
  String? passwordError;
  String? confirmPasswordError;

  // true = the Save button was pressed at least once (errors update live after)
  bool submitted = false;

  // true = we are waiting for the backend
  bool isSaving = false;

  // Same password rules as the Sign up screen
  final int minPasswordLength = 8;
  final int maxPasswordLength = 64;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  // Password check
  String? validatePassword() {
    final String password = passwordController.text;
    if (password.isEmpty) {
      return 'Password is required.';
    }
    if (password != password.trim()) {
      return 'Password cannot start or end with a space.';
    }
    if (password.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters.';
    }
    if (password.length > maxPasswordLength) {
      return 'Password must be $maxPasswordLength characters or less.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Add at least 1 uppercase letter (A to Z).';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Add at least 1 lowercase letter (a to z).';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Add at least 1 number (0 to 9).';
    }
    if (!RegExp(r'[^A-Za-z0-9\s]').hasMatch(password)) {
      return 'Add at least 1 special character (example: ! @ # \$ %).';
    }
    return null;
  }

  // Confirm password check
  String? validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      return 'Please confirm your password.';
    }
    if (passwordController.text != confirmPasswordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  // Runs while the user types (only after Save was pressed once)
  void refreshErrors() {
    if (!submitted) return;
    setState(() {
      passwordError = validatePassword();
      confirmPasswordError = validateConfirmPassword();
    });
  }

  // Runs when the Save button is pressed
  Future<void> handleSave() async {
    submitted = true;
    final String? createError = validatePassword();
    final String? confirmError = validateConfirmPassword();
    setState(() {
      passwordError = createError;
      confirmPasswordError = confirmError;
    });
    if (createError != null) {
      passwordFocus.requestFocus();
      return;
    }
    if (confirmError != null) {
      confirmPasswordFocus.requestFocus();
      return;
    }

    setState(() {
      isSaving = true;
    });

    // TODO: save the new password (Supabase: auth.updateUser)

    if (!mounted) return;
    setState(() {
      isSaving = false;
    });

    // TODO: show "Password updated" and go back to the Log in screen
  }

  // Small grey help text shown under a box
  Widget buildHelper(String message) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 6),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }

  // Small red text shown under a box when it has an error
  Widget buildError(String? message) {
    if (message == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 6),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12, color: Colors.red),
      ),
    );
  }

  // Builds the bold label above each text box
  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  // Builds one grey rounded password box with an eye button
  Widget buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required bool hidden,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: hidden,
      autocorrect: false,
      enableSuggestions: false,
      cursorColor: kCoral,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxPasswordLength),
      ],
      onChanged: (String value) {
        refreshErrors();
      },
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
        filled: true,
        fillColor: kButtonGrey,
        prefixIcon: const SizedBox(
          width: 60,
          child: Center(
            child: Icon(Icons.lock_outline, color: Colors.black54, size: 24),
          ),
        ),
        // Eye button: show or hide the password
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.black54,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
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
                      'Reset password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Create a new password for your account.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 28),

                    // New password
                    buildLabel('New Password'),
                    const SizedBox(height: 8),
                    buildPasswordField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      hint: 'New Password',
                      hidden: hidePassword,
                      onToggle: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    // Show the error if there is one, otherwise show the rules
                    if (passwordError != null)
                      buildError(passwordError)
                    else
                      buildHelper(
                        'At least $minPasswordLength characters with uppercase, '
                        'lowercase, a number and a special character.',
                      ),
                    const SizedBox(height: 18),

                    // Confirm password
                    buildLabel('Confirm Password'),
                    const SizedBox(height: 8),
                    buildPasswordField(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocus,
                      hint: 'Confirm Password',
                      hidden: hideConfirmPassword,
                      onToggle: () {
                        setState(() {
                          hideConfirmPassword = !hideConfirmPassword;
                        });
                      },
                    ),
                    buildError(confirmPasswordError),
                    const SizedBox(height: 28),

                    // Save button
                    Center(
                      child: SizedBox(
                        width: 290,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kCoral,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: kCoral,
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Save password',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
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
