-- Joueurs de Typoposite : une ligne par compte. Tout le monde lit (classement), chacun ne modifie que la sienne.
-- À coller dans Supabase › SQL Editor (même projet que Zoubiders), puis « Run ».
create table if not exists public.joueurs (
  user_id uuid primary key references auth.users(id) on delete cascade,
  pseudo text not null check (char_length(pseudo) between 1 and 20),
  avatar jsonb not null default '{}'::jsonb check (pg_column_size(avatar) < 500),
  best int not null default 0 check (best between 0 and 2500),
  total int not null default 0 check (total >= 0),
  games int not null default 0 check (games >= 0),
  updated_at timestamptz not null default now()
);
alter table public.joueurs enable row level security;
create policy "lire le classement" on public.joueurs for select to anon, authenticated using (true);
create policy "creer ma ligne" on public.joueurs for insert to authenticated with check (auth.uid() = user_id);
create policy "modifier ma ligne" on public.joueurs for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
