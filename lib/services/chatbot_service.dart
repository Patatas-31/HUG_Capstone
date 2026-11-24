
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatbotService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> getReply(String message) async {
    if (_supabase.auth.currentSession == null) {
      throw Exception(
        'Please sign in to your HUG account before chatting with Pat.',
      );
    }

    final response = await _supabase.functions.invoke(
      'hug-chatbot',
      body: {'message': message},
    );

    final data = response.data;

    if (data is! Map || data['reply'] is! String) {
      throw Exception('Pat returned an unexpected response.');
    }

    return data['reply'] as String;
  }
}
