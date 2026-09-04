import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/app_user.dart';
import 'auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Émet un événement à chaque changement d'état d'authentification
/// (connexion, déconnexion, refresh de session).
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Charge le profil (table `profiles`) de l'utilisateur courant.
/// Se recalcule automatiquement quand `authStateProvider` change.
final currentProfileProvider = FutureProvider<AppUser?>((ref) async {
  final authState = ref.watch(authStateProvider).valueOrNull;
  final repo = ref.watch(authRepositoryProvider);

  final user = authState?.session?.user ?? repo.currentUser;
  if (user == null) return null;

  return repo.fetchProfile(user.id);
});
