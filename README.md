# App Flutter + Supabase — v1 générique

⚠️ **Statut** : socle générique v1, généré en attendant le cahier des charges
complet. Auth + profils + rôles fonctionnels ; écrans métier réels à ajouter.

## Ce qui est inclus

- Authentification Supabase (email/mot de passe) : inscription, connexion, déconnexion
- Table `profiles` avec rôles (`admin`, `member`) + création automatique via trigger
- Row Level Security (RLS) : chacun lit/modifie son profil, un admin voit tout
- Routing avec redirection selon l'état d'authentification (go_router)
- Gestion d'état avec Riverpod
- Thème Material 3 clair/sombre générique
- Tests unitaires de base
- CI/CD GitHub Actions : build APK + Web automatique à chaque push

## Ce qu'il reste à faire une fois le cahier des charges fourni

- Remplacer les rôles génériques (`admin`/`member`) par les rôles réels
- Ajouter les tables métier et leurs politiques RLS
- Construire les écrans réels (remplacer `HomeScreen`)
- Adapter la charte graphique dans `lib/core/app_theme.dart`

---

## 1. Configuration Supabase

1. Créer un projet sur [supabase.com](https://supabase.com)
2. Dans **SQL Editor**, exécuter dans l'ordre :
   - `supabase/migrations/0001_init.sql`
   - (optionnel, dev uniquement) `supabase/seed.sql`
3. Récupérer `Project URL` et `anon public key` dans **Project Settings > API**
4. Copier `.env.example` vers `.env` et renseigner ces deux valeurs :
   ```
   cp .env.example .env
   ```

## 2. Lancer l'app en local

Prérequis : [Flutter SDK](https://docs.flutter.dev/get-started/install) installé.

```bash
flutter pub get
flutter run              # sur un émulateur/appareil connecté
flutter run -d chrome    # pour tester en web
```

## 3. Obtenir un vrai fichier APK

```bash
flutter build apk --release
```

Le fichier sera dans :
```
build/app/outputs/flutter-apk/app-release.apk
```
Transférez-le sur un téléphone Android (activer "Sources inconnues" pour l'installer).

## 4. Obtenir une vraie version Web déployée

```bash
flutter build web --release
```

Le site statique est généré dans `build/web`. Déployez-le sur l'une de ces plateformes :

- **Firebase Hosting** (config déjà présente dans `firebase.json`) :
  ```bash
  npm install -g firebase-tools
  firebase login
  firebase init hosting   # sélectionner le projet, garder build/web comme dossier public
  firebase deploy
  ```
- **Netlify** : glisser-déposer le dossier `build/web` sur [app.netlify.com/drop](https://app.netlify.com/drop)
- **Vercel** : `vercel --prod` depuis le dossier `build/web`

## 5. Build automatique via GitHub Actions (recommandé)

Le fichier `.github/workflows/build.yml` est déjà configuré pour :
- installer Flutter
- lancer les tests et l'analyse statique
- builder l'APK et le Web
- publier les deux comme *artifacts* téléchargeables depuis l'onglet **Actions** du repo

Étapes :
1. Créer un repo GitHub et y pousser ce projet
2. Dans **Settings > Secrets and variables > Actions**, ajouter :
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
3. Pousser sur `main` (ou lancer manuellement via l'onglet Actions)
4. Télécharger `app-release-apk` et `app-web-build` depuis le résumé du run

Pour un déploiement Web automatique avec une vraie URL publique à chaque push,
décommenter la section Firebase Hosting dans `build.yml` et ajouter les secrets
`FIREBASE_TOKEN` et `FIREBASE_PROJECT_ID`.

## 6. Structure du projet

```
lib/
  core/            # client Supabase, thème
  data/models/     # modèles de données partagés
  features/
    auth/          # login, signup, repository, providers
    home/          # écran d'accueil (placeholder)
  routing/         # go_router + redirections auth
supabase/
  migrations/      # schéma SQL versionné
  seed.sql         # données de démo (dev uniquement)
test/              # tests unitaires
.github/workflows/ # CI/CD
```
