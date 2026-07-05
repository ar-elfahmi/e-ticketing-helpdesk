import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String _supabaseUrl =
      'https://wtwpbecqrniszlggtxqg.supabase.co';
  static const String _supabaseAnonKey =
      'sb_publishable_RIW53vaF0ibFVVdr9BMhaA_XaFzTbmA';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      publishableKey: _supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
