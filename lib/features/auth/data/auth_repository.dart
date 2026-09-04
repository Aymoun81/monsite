import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase_client.dart';
import '../../../data/models/app_user.dart';

/// Encapsule tous les appels Supabase liés à l'authentification
/// et à la table `profiles`. Aucune règle métier ici — juste des accès data.
class AuthRepository {
  final SupabaseClient _client = AppSupabase.client;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Crée le compte Auth ET la ligne `profiles` associée.
  /// Le trigger SQL `handle_new_user` (voir migrations) crée déjà
  /// une ligne par défaut ; ce repository peut la compléter ensuite.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> signOut() => _client.auth.signOut();

  Future<AppUser> fetchProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return AppUser.fromMap(data);
  }
}
