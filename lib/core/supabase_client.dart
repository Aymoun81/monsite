import 'package:supabase_flutter/supabase_flutter.dart';

/// Point d'accès unique au client Supabase.
///
/// Les identifiants sont injectés à la compilation via --dart-define
/// (voir .github/workflows/build.yml et le README), plutôt que via un
/// fichier .env — plus fiable pour le déploiement Web (certains hébergeurs
/// comme Netlify n'envoient jamais les fichiers commençant par un point).
class AppSupabase {
  AppSupabase._();

  static const String _url = String.fromEnvironment('SUPABASE_URL');
  static const String _anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static Future<void> init() async {
    assert(
      _url.isNotEmpty && _anonKey.isNotEmpty,
      'SUPABASE_URL et SUPABASE_ANON_KEY doivent être fournis via '
      '--dart-define au moment du build (voir README).',
    );

    await Supabase.initialize(
      url: _url,
      anonKey: _anonKey,
      debug: false,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static User? get currentUser => client.auth.currentUser;

  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}
