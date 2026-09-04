import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/app_user.dart';
import '../../auth/data/auth_providers.dart';

/// Écran d'accueil générique v1.
/// À remplacer par les écrans réels une fois le cahier des charges connu
/// (dashboard, listes métier, navigation par rôle, etc.).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur de chargement du profil : $err')),
        data: (profile) => _HomeBody(profile: profile),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final AppUser? profile;
  const _HomeBody({required this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Center(child: Text('Aucun utilisateur connecté.'));
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Bienvenue, ${profile!.fullName ?? profile!.email}',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Chip(label: Text('Rôle : ${profile!.role.name}')),
        const SizedBox(height: 24),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Cet écran est un placeholder v1 générique.\n'
              'Il sera remplacé par les écrans métier réels dès que le '
              'cahier des charges sera fourni (fonctionnalités par rôle, '
              'listes, formulaires, tableaux de bord, etc.).',
            ),
          ),
        ),
      ],
    );
  }
}
