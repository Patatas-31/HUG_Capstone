// Hug - Sign up screen

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../constants/colors.dart';
import '../widgets/collaboration_footer.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_screen.dart';
import 'otp_screen.dart';

// Turns everything the user types into CAPITAL letters.
// We use this on the student number so "mn" becomes "MN".
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // ---------------------------------------------------
  // TEXT BOXES AND FOCUS
  // ---------------------------------------------------
  // Text boxes: these hold what the user types
  final TextEditingController studentNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController otherSuffixController = TextEditingController();

  // Focus nodes: we use these to jump to the first box that has an error
  final FocusNode studentNumberFocus = FocusNode();
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode middleNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode otherSuffixFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  // true = password is hidden, false = password is shown
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  // Suffix (Jr., Sr., III ...). null = nothing chosen yet.
  String? selectedSuffix;

  // The choices shown in the Suffix dropdown
  final List<String> suffixOptions = [
    'None',
    'Jr.',
    'Sr.',
    'II',
    'III',
    'IV',
    'V',
    'Other',
  ];

  // true = the user has no middle name ("not applicable")
  bool noMiddleName = false;

  // true = the Next button was pressed at least once.
  // After that, the errors update live while the user types.
  bool submitted = false;

  // true = we are waiting for the "is this student number taken?" check
  bool isChecking = false;

  // ---------------------------------------------------
  // VALIDATION SETTINGS
  // ---------------------------------------------------
  // Red error message under each box (null = no error)
  String? studentNumberError;
  String? firstNameError;
  String? middleNameError;
  String? lastNameError;
  String? otherSuffixError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  // Student number format: 2024-13242-MN-0
  // (4 numbers - 5 numbers - 2 letters - 1 number)
  final RegExp studentNumberPattern = RegExp(r'^\d{4}-\d{5}-[A-Za-z]{2}-\d$');

  // Campus codes that are allowed (the 2 letters in the student number).
  // Add more codes here if your school has other campuses.
  final List<String> validCampusCodes = ['MN'];

  // The earliest school year we accept in the student number
  final int earliestStudentYear = 2000;

  // Names: letters A to Z (including Ñ/ñ).
  // Words can be joined by a space, a hyphen (-), an apostrophe (') or
  // a period followed by a space (Ma. Cristina). A last period is allowed.
  // Examples that pass: Niño, Peña, Mary-Ann, Ma. Cristina, D'Souza
  final RegExp namePattern = RegExp(
    r"^[A-Za-zÑñ]+(?:(?:\.? |[-'’])[A-Za-zÑñ]+)*\.?$",
  );

  // Email format: name@domain.com (used to send the OTP)
  final RegExp emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$',
  );

  // "Other" suffix: letters and periods only (Esq., Ph.D.)
  final RegExp suffixPattern = RegExp(r'^[A-Za-z][A-Za-z.]*$');

  // Maximum lengths
  final int maxStudentNumberLength = 15;
  final int maxNameLength = 50;
  final int maxSuffixLength = 10;
  final int maxEmailLength = 100;
  final int minPasswordLength = 8;
  final int maxPasswordLength = 64;

  // ---------------------------------------------------
  // SMALL HELPERS
  // ---------------------------------------------------

  // Removes spaces at the start and end, and turns many spaces into one
  String cleanSpaces(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // ---------------------------------------------------
  // "IS THIS RANDOM TYPING?" CHECK
  // ---------------------------------------------------
  // This cannot know if a name is real. It only catches names that
  // look like keyboard mashing. Real verification must be done with the
  // school records (student number / COR) on the backend.

  // Pairs of letters that almost never appear together in real names
  final List<String> rareLetterPairs = [
    'bq',
    'bx',
    'cj',
    'cv',
    'cx',
    'dx',
    'fq',
    'fx',
    'fz',
    'fw',
    'fh',
    'hf',
    'gj',
    'gq',
    'gx',
    'gf',
    'hg',
    'hj',
    'hx',
    'jd',
    'jf',
    'jg',
    'jh',
    'jk',
    'jq',
    'jx',
    'jz',
    'kg',
    'kj',
    'kq',
    'kx',
    'kz',
    'lq',
    'lx',
    'mq',
    'mx',
    'pq',
    'px',
    'qq',
    'sx',
    'tq',
    'vb',
    'vf',
    'vh',
    'vj',
    'vk',
    'vm',
    'vp',
    'vq',
    'vw',
    'vx',
    'vz',
    'wq',
    'wx',
    'wz',
    'xj',
    'xx',
    'zx',
  ];

  // Letters that are next to each other on the keyboard
  final List<String> keyboardMash = [
    'asdf',
    'sdfg',
    'dfgh',
    'fghj',
    'ghjk',
    'hjkl',
    'zxcv',
    'xcvb',
    'cvbn',
    'vbnm',
    'qwer',
    'poiu',
    'lkjh',
    'mnbv',
  ];

  // Returns true if the name looks like random typing.
  // Each word is checked by itself (so "Ma. Cristina" is 2 words).
  bool looksLikeRandomText(String name) {
    final String lower = name.toLowerCase().replaceAll('ñ', 'n');
    final List<String> words = lower
        .split(RegExp(r'[^a-z]+'))
        .where((String w) => w.isNotEmpty)
        .toList();
    for (final String word in words) {
      if (isRandomWord(word)) return true;
    }
    return false;
  }

  // Checks one word. Words with 1 or 2 letters always pass,
  // because real names like "Al", "Jo", "Li" and "Ng" exist.
  bool isRandomWord(String word) {
    if (word.length <= 2) return false;

    // A word with no vowel (a, e, i, o, u, y) is not a name
    if (!RegExp(r'[aeiouy]').hasMatch(word)) return true;

    // The same letter 3 times in a row ("aaa")
    if (RegExp(r'(.)\1\1').hasMatch(word)) return true;

    // 5 or more consonants in a row ("bfgjk")
    if (RegExp(r'[^aeiouy]{5,}').hasMatch(word)) return true;

    // Letter pairs that almost never appear in real names
    for (final String pair in rareLetterPairs) {
      if (word.contains(pair)) return true;
    }

    // Letters that are next to each other on the keyboard
    for (final String row in keyboardMash) {
      if (word.contains(row)) return true;
    }
    return false;
  }

  // Checks one name box. Returns an error text, or null if it is OK.
  String? checkName(String text, String label, {int minLength = 2}) {
    final String value = cleanSpaces(text);
    if (value.isEmpty) {
      return '$label is required.';
    }
    if (value.length < minLength) {
      return '$label must be at least $minLength letters.';
    }
    if (value.length > maxNameLength) {
      return '$label must be $maxNameLength characters or less.';
    }
    if (!namePattern.hasMatch(value)) {
      return 'Letters only (A to Z, Ñ). You may also use a space, hyphen (-), '
          "apostrophe (') or period (.).";
    }
    // The letters are allowed, but it may be random typing like "hgafhagjakg"
    if (looksLikeRandomText(value)) {
      return '$label does not look like a real name. Please check the spelling.';
    }
    return null;
  }

  // ---------------------------------------------------
  // ONE CHECK PER BOX
  // ---------------------------------------------------

  // Student number check
  String? validateStudentNumber() {
    final String value = studentNumberController.text.trim();
    if (value.isEmpty) {
      return 'Student number is required.';
    }
    if (value.length > maxStudentNumberLength) {
      return 'Student number is too long.';
    }
    if (!studentNumberPattern.hasMatch(value)) {
      return 'Wrong format. Example: 2024-13242-MN-0';
    }

    // The pattern passed, so we can safely split the parts
    final List<String> parts = value.split('-');

    // Year check: must be from earliestStudentYear up to this year
    final int year = int.parse(parts[0]);
    final int currentYear = DateTime.now().year;
    if (year < earliestStudentYear || year > currentYear) {
      return 'Year must be from $earliestStudentYear to $currentYear.';
    }

    // Campus code check (not case sensitive)
    final String campus = parts[2].toUpperCase();
    if (!validCampusCodes.contains(campus)) {
      return 'Unknown campus code "$campus". '
          'Allowed: ${validCampusCodes.join(', ')}';
    }
    return null;
  }

  // First name check
  String? validateFirstName() {
    return checkName(firstNameController.text, 'First name');
  }

  // Middle name check (skipped when "I have no middle name" is checked).
  // A middle name can be just 1 letter, like an initial.
  String? validateMiddleName() {
    if (noMiddleName) return null;
    return checkName(middleNameController.text, 'Middle name', minLength: 1);
  }

  // Last name check
  String? validateLastName() {
    return checkName(lastNameController.text, 'Last name');
  }

  // "Other" suffix check (only when Other is chosen)
  String? validateOtherSuffix() {
    if (selectedSuffix != 'Other') return null;
    final String value = cleanSpaces(otherSuffixController.text);
    if (value.isEmpty) {
      return 'Suffix is required.';
    }
    if (value.length > maxSuffixLength) {
      return 'Suffix must be $maxSuffixLength characters or less.';
    }
    if (!suffixPattern.hasMatch(value)) {
      return 'Letters and periods only. Example: Esq.';
    }
    return null;
  }

  // Email check (the OTP will be sent here)
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

    // The password must not contain the student number or the name
    final String lowerPassword = password.toLowerCase();
    final String studentNumber = studentNumberController.text
        .trim()
        .toLowerCase();
    if (studentNumber.isNotEmpty && lowerPassword.contains(studentNumber)) {
      return 'Password must not contain your student number.';
    }
    final String firstName = cleanSpaces(firstNameController.text)
        .toLowerCase();
    final String lastName = cleanSpaces(lastNameController.text).toLowerCase();
    // Only compare names with 3 or more letters, so short names do not
    // block normal passwords by accident
    if (firstName.length >= 3 && lowerPassword.contains(firstName)) {
      return 'Password must not contain your first name.';
    }
    if (lastName.length >= 3 && lowerPassword.contains(lastName)) {
      return 'Password must not contain your last name.';
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

  // ---------------------------------------------------
  // CHECK THE WHOLE FORM
  // ---------------------------------------------------

  // Checks every box. Returns true only if everything is correct.
  bool validateForm() {
    final String? studentError = validateStudentNumber();
    final String? firstError = validateFirstName();
    final String? middleError = validateMiddleName();
    final String? lastError = validateLastName();
    final String? suffixError = validateOtherSuffix();
    final String? emailErr = validateEmail();
    final String? createError = validatePassword();
    final String? confirmError = validateConfirmPassword();

    // Show all the errors at once
    setState(() {
      studentNumberError = studentError;
      firstNameError = firstError;
      middleNameError = middleError;
      lastNameError = lastError;
      otherSuffixError = suffixError;
      emailError = emailErr;
      passwordError = createError;
      confirmPasswordError = confirmError;
    });

    // Go to the first box (from top to bottom) that has an error
    if (studentError != null) {
      focusOn(studentNumberFocus);
    } else if (firstError != null) {
      focusOn(firstNameFocus);
    } else if (middleError != null) {
      focusOn(middleNameFocus);
    } else if (lastError != null) {
      focusOn(lastNameFocus);
    } else if (suffixError != null) {
      focusOn(otherSuffixFocus);
    } else if (emailErr != null) {
      focusOn(emailFocus);
    } else if (createError != null) {
      focusOn(passwordFocus);
    } else if (confirmError != null) {
      focusOn(confirmPasswordFocus);
    }

    return studentError == null &&
        firstError == null &&
        middleError == null &&
        lastError == null &&
        suffixError == null &&
        emailErr == null &&
        createError == null &&
        confirmError == null;
  }

  // Runs while the user types. It only works after Next was pressed once,
  // so the user does not see errors before they finish typing.
  void refreshErrors() {
    if (!submitted) return;
    setState(() {
      studentNumberError = validateStudentNumber();
      firstNameError = validateFirstName();
      middleNameError = validateMiddleName();
      lastNameError = validateLastName();
      otherSuffixError = validateOtherSuffix();
      emailError = validateEmail();
      passwordError = validatePassword();
      confirmPasswordError = validateConfirmPassword();
    });
  }

  // Moves the cursor to a box and scrolls the screen so it is visible
  void focusOn(FocusNode node) {
    // Wait one frame so the new error texts are already drawn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      node.requestFocus();
      final BuildContext? boxContext = node.context;
      if (boxContext != null) {
        Scrollable.ensureVisible(
          boxContext,
          duration: const Duration(milliseconds: 300),
          alignment: 0.2,
        );
      }
    });
  }

  // ---------------------------------------------------
  // DUPLICATE CHECK (BACKEND)
  // ---------------------------------------------------
  // Asks Supabase if this student number is already registered
  // (uses the student_number_taken function from supabase_setup.sql).
  Future<bool> isStudentNumberTaken(String studentNumber) async {
    try {
      final dynamic result = await Supabase.instance.client.rpc(
        'student_number_taken',
        params: {'sn': studentNumber},
      );
      return result == true;
    } catch (error) {
      debugPrint('Student number check failed: $error');
      return false;
    }
  }

  // ---------------------------------------------------
  // CLEAN UP BEFORE SAVING
  // ---------------------------------------------------
  // Trims extra spaces and makes the student number uppercase.
  void cleanUpInputs() {
    studentNumberController.text = studentNumberController.text
        .trim()
        .toUpperCase();
    firstNameController.text = cleanSpaces(firstNameController.text);
    middleNameController.text = cleanSpaces(middleNameController.text);
    lastNameController.text = cleanSpaces(lastNameController.text);
    otherSuffixController.text = cleanSpaces(otherSuffixController.text);
    emailController.text = emailController.text.trim().toLowerCase();
  }

  // Runs when the Next button is pressed
  Future<void> handleNext() async {
    // From now on, errors update live while typing
    submitted = true;

    // Check all the boxes first.
    // If something is wrong, stop here and show errors.
    if (!validateForm()) return;

    // Tidy up the typed text
    cleanUpInputs();

    // Ask the backend if the student number is already used
    setState(() {
      isChecking = true;
    });
    final bool taken = await isStudentNumberTaken(studentNumberController.text);

    // The screen may be closed while we waited
    if (!mounted) return;

    setState(() {
      isChecking = false;
      if (taken) {
        studentNumberError = 'This student number is already registered.';
      }
    });

    if (taken) {
      focusOn(studentNumberFocus);
      return;
    }

    // Create the account. Supabase sends the OTP code to the email.
    setState(() {
      isChecking = true;
    });
    try {
      await Supabase.instance.client.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
        data: {
          'student_number': studentNumberController.text,
          'first_name': firstNameController.text,
          'middle_name': middleNameController.text,
          'last_name': lastNameController.text,
          // "None" or nothing chosen = no suffix
          'suffix': selectedSuffix == 'Other'
              ? otherSuffixController.text
              : (selectedSuffix == null || selectedSuffix == 'None'
                    ? ''
                    : selectedSuffix),
        },
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        isChecking = false;
        emailError = e.message;
      });
      focusOn(emailFocus);
      return;
    }

    if (!mounted) return;
    setState(() {
      isChecking = false;
    });

    // Go to the OTP screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(email: emailController.text),
      ),
    );
  }

  // ---------------------------------------------------
  // WIDGET HELPERS
  // ---------------------------------------------------

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

  @override
  void dispose() {
    // Free the memory used by the text boxes and focus nodes
    studentNumberController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otherSuffixController.dispose();
    studentNumberFocus.dispose();
    firstNameFocus.dispose();
    middleNameFocus.dispose();
    lastNameFocus.dispose();
    otherSuffixFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
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

  // Builds one grey rounded text box.
  // "prefix" is the small icon or letters (FN, MN, LN) on the left side.
  Widget buildField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required Widget prefix,
    bool obscure = false,
    bool enabled = true,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
    List<TextInputFormatter>? formatters,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      obscureText: obscure,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      inputFormatters: formatters,
      // Passwords should not be auto-corrected or suggested
      autocorrect: !obscure,
      enableSuggestions: !obscure,
      // Check this box again every time the user types
      onChanged: (String value) {
        refreshErrors();
      },
      cursorColor: kCoral,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
        filled: true,
        fillColor: kButtonGrey,
        prefixIcon: SizedBox(width: 60, child: Center(child: prefix)),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Grey letters used as the left icon (FN, MN, LN)
  Widget letters(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
    );
  }

  // The rules for a name box: allow letters, Ñ, space, - ' . and limit length
  List<TextInputFormatter> nameFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zÑñ .'’-]")),
      LengthLimitingTextInputFormatter(maxNameLength),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // The form can scroll when the keyboard is open
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
                      'Sign up',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Student number
                    buildLabel('Student Number'),
                    const SizedBox(height: 8),
                    buildField(
                      controller: studentNumberController,
                      focusNode: studentNumberFocus,
                      hint: 'Student Number',
                      prefix: const Icon(
                        Icons.numbers,
                        color: Colors.black54,
                        size: 24,
                      ),
                      // Show capital letters on the keyboard
                      capitalization: TextCapitalization.characters,
                      formatters: [
                        // Only numbers, letters and hyphen
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9A-Za-z-]'),
                        ),
                        // Make letters uppercase while typing
                        UpperCaseTextFormatter(),
                        LengthLimitingTextInputFormatter(
                          maxStudentNumberLength,
                        ),
                      ],
                    ),
                    buildError(studentNumberError),
                    const SizedBox(height: 18),

                    // First name
                    buildLabel('First Name'),
                    const SizedBox(height: 8),
                    buildField(
                      controller: firstNameController,
                      focusNode: firstNameFocus,
                      hint: 'First Name',
                      prefix: letters('FN'),
                      capitalization: TextCapitalization.words,
                      formatters: nameFormatters(),
                    ),
                    buildError(firstNameError),
                    const SizedBox(height: 18),

                    // Middle name
                    buildLabel('Middle Name'),
                    const SizedBox(height: 8),
                    buildField(
                      controller: middleNameController,
                      focusNode: middleNameFocus,
                      hint: noMiddleName ? 'Not applicable' : 'Middle Name',
                      prefix: letters('MN'),
                      enabled: !noMiddleName,
                      capitalization: TextCapitalization.words,
                      formatters: nameFormatters(),
                    ),
                    buildError(middleNameError),
                    const SizedBox(height: 8),

                    // "No middle name" checkbox (coral rounded square)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              noMiddleName = !noMiddleName;
                              // Clear the box when it is not applicable
                              if (noMiddleName) {
                                middleNameController.clear();
                                middleNameError = null;
                              }
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: noMiddleName ? kCoral : Colors.white,
                              border: Border.all(color: kCoral, width: 2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: noMiddleName
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'I have no middle name (not applicable)',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Last name
                    buildLabel('Last Name'),
                    const SizedBox(height: 8),
                    buildField(
                      controller: lastNameController,
                      focusNode: lastNameFocus,
                      hint: 'Last Name',
                      prefix: letters('LN'),
                      capitalization: TextCapitalization.words,
                      formatters: nameFormatters(),
                    ),
                    buildError(lastNameError),
                    const SizedBox(height: 18),

                    // Suffix (optional)
                    buildLabel('Suffix (optional)'),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: kButtonGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSuffix,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                          ),
                          hint: const Text(
                            'Select Suffix',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFBDBDBD),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          items: suffixOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedSuffix = value;
                              // Clear the "Other" box if it is not needed
                              if (value != 'Other') {
                                otherSuffixController.clear();
                                otherSuffixError = null;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // "Other" text box (only shows when Other is chosen)
                    if (selectedSuffix == 'Other') ...[
                      buildLabel('Other Suffix'),
                      const SizedBox(height: 8),
                      buildField(
                        controller: otherSuffixController,
                        focusNode: otherSuffixFocus,
                        hint: 'Type your suffix',
                        prefix: letters('SF'),
                        capitalization: TextCapitalization.words,
                        formatters: [
                          // Letters and periods only, short length
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[A-Za-z.]'),
                          ),
                          LengthLimitingTextInputFormatter(maxSuffixLength),
                        ],
                      ),
                      buildError(otherSuffixError),
                      const SizedBox(height: 18),
                    ],

                    // Email (OTP will be sent here)
                    buildLabel('Email'),
                    const SizedBox(height: 8),
                    buildField(
                      controller: emailController,
                      focusNode: emailFocus,
                      hint: 'Email',
                      prefix: const Icon(
                        Icons.email_outlined,
                        color: Colors.black54,
                        size: 24,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      formatters: [
                        // No spaces in an email
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        LengthLimitingTextInputFormatter(maxEmailLength),
                      ],
                    ),
                    if (emailError != null)
                      buildError(emailError)
                    else
                      buildHelper(
                        'We will send a one-time password (OTP) here.',
                      ),
                    const SizedBox(height: 18),

                    // Create password
                    buildLabel('Create Password'),
                    const SizedBox(height: 8),
                    buildField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      hint: 'Create Password',
                      prefix: const Icon(
                        Icons.lock_outline,
                        color: Colors.black54,
                        size: 24,
                      ),
                      obscure: hidePassword,
                      formatters: [
                        LengthLimitingTextInputFormatter(maxPasswordLength),
                      ],
                      // Eye button: show or hide the password
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.black54,
                        ),
                      ),
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
                    buildField(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocus,
                      hint: 'Confirm Password',
                      prefix: const Icon(
                        Icons.lock_outline,
                        color: Colors.black54,
                        size: 24,
                      ),
                      obscure: hideConfirmPassword,
                      formatters: [
                        LengthLimitingTextInputFormatter(maxPasswordLength),
                      ],
                      // Eye button: show or hide the password
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            hideConfirmPassword = !hideConfirmPassword;
                          });
                        },
                        icon: Icon(
                          hideConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    buildError(confirmPasswordError),
                    const SizedBox(height: 28),

                    // Next button
                    Center(
                      child: SizedBox(
                        width: 290,
                        height: 42,
                        child: ElevatedButton(
                          // Disabled while we wait for the duplicate check
                          onPressed: isChecking ? null : handleNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kCoral,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: kCoral,
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: isChecking
                              // Small spinner while checking
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Link to Log in
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Swap this screen for the Log in screen
                              // (replace, so the screens do not pile up)
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kCoral,
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
