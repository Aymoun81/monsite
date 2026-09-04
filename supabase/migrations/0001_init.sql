-- ============================================================
-- Migration 0001 : socle générique v1 (auth + profils + rôles)
-- À adapter dès réception du cahier des charges :
--   - renommer/ajouter des rôles dans app_role
--   - ajouter les tables métier réelles
-- ============================================================

-- Extension nécessaire pour gen_random_uuid()
create extension if not exists "pgcrypto";

-- Rôles génériques v1
do $$
begin
  if not exists (select 1 from pg_type where typname = 'app_role') then
    create type app_role as enum ('admin', 'member');
  end if;
end$$;

-- Table de profils, 1-1 avec auth.users
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  full_name text,
  role app_role not null default 'member',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Trigger : maintenir updated_at à jour
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_profiles_updated_at on public.profiles;
create trigger trg_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- Trigger : créer automatiquement le profil à l'inscription
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name, role)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    'member'
  );
  return new;
end;
$$ language plpgsql security definer set search_path = public;

drop trigger if exists trg_on_auth_user_created on auth.users;
create trigger trg_on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============================================================
-- RLS (Row Level Security)
-- ============================================================
alter table public.profiles enable row level security;

-- Un utilisateur peut lire son propre profil
create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = id);

-- Un admin peut lire tous les profils
create policy "profiles_select_admin"
  on public.profiles for select
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );

-- Un utilisateur peut modifier certains champs de son propre profil
-- (le rôle n'est volontairement PAS modifiable par l'utilisateur lui-même)
create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Seul un admin peut changer le rôle d'un profil
create policy "profiles_update_admin"
  on public.profiles for update
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );
