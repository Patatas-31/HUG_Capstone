
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );

    if (response.user == null || response.session == null) {
      return false;
    }

    // Only allow accounts with a linked HUG student profile.
    final profile = await _supabase
        .from('student_profiles')
        .select('id')
        .eq('id', response.user!.id)
        .maybeSingle();

    if (profile == null) {
      await _supabase.auth.signOut();
      return false;
    }

    return true;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  bool get isLoggedIn =>
      _supabase.auth.currentSession != null;
}
