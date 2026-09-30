-- ============================================================================
-- Ours — Apartment Expenses :: Supabase setup
-- Run this ONCE in your project's SQL editor (Supabase dashboard → SQL editor).
-- Creates the tables, access policies, realtime, and the receipts storage bucket.
-- ============================================================================

-- ---- Tables -----------------------------------------------------------------
create table if not exists public.settings (
  household   text primary key,
  data        jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

create table if not exists public.expenses (
  id          text primary key,
  household   text not null,
  month       text,
  data        jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);
create index if not exists expenses_household_idx on public.expenses (household);
create index if not exists expenses_month_idx     on public.expenses (household, month);

create table if not exists public.settlements (
  household   text not null,
  key         text not null,
  data        jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now(),
  primary key (household, key)
);
create index if not exists settlements_household_idx on public.settlements (household);

-- ---- Row Level Security -----------------------------------------------------
-- This is a private, single-household project: the policies below allow the
-- app's anon key full access to these three tables. Data is partitioned by the
-- "household" code, so anyone with your link + code (and your anon key) can use
-- it. If you later want stronger control, replace these with Supabase Auth +
-- per-user policies (ask me and I'll wire it up).

alter table public.settings    enable row level security;
alter table public.expenses    enable row level security;
alter table public.settlements enable row level security;

drop policy if exists "settings all"    on public.settings;
drop policy if exists "expenses all"    on public.expenses;
drop policy if exists "settlements all" on public.settlements;

create policy "settings all"    on public.settings    for all to anon, authenticated using (true) with check (true);
create policy "expenses all"    on public.expenses    for all to anon, authenticated using (true) with check (true);
create policy "settlements all" on public.settlements for all to anon, authenticated using (true) with check (true);

-- ---- Realtime ---------------------------------------------------------------
-- Let both phones see each other's changes live.
alter publication supabase_realtime add table public.settings;
alter publication supabase_realtime add table public.expenses;
alter publication supabase_realtime add table public.settlements;

-- ---- Receipt storage --------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('receipts', 'receipts', true)
on conflict (id) do nothing;

drop policy if exists "receipts read"   on storage.objects;
drop policy if exists "receipts insert" on storage.objects;
drop policy if exists "receipts update" on storage.objects;

create policy "receipts read"   on storage.objects for select to anon, authenticated using (bucket_id = 'receipts');
create policy "receipts insert" on storage.objects for insert to anon, authenticated with check (bucket_id = 'receipts');
create policy "receipts update" on storage.objects for update to anon, authenticated using (bucket_id = 'receipts');

-- Done. Go back to the app, paste your Project URL + anon key, pick a household code, Connect.
