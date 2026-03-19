-- Execute this entirely in your Supabase SQL Editor!

-- 1. Create the Galleries table
create table public.galleries (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null,
  title text not null,
  event_date date,
  client_pin text,
  cover_image_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Create the Photos table
create table public.photos (
  id uuid default gen_random_uuid() primary key,
  gallery_id uuid references public.galleries on delete cascade not null,
  storage_path text not null,
  filename text not null,
  size_bytes integer,
  thumbnail_url text,
  highres_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. Set up Row Level Security (RLS)
alter table public.galleries enable row level security;
alter table public.photos enable row level security;

-- Policies for Galleries: Photographers can view and edit their own.
create policy "Photographers can CRUD their own galleries."
  on public.galleries for all
  using ( auth.uid() = user_id );

-- Policies for Galleries: Anyone can view a gallery publicly (we handle PINs in the app layer)
create policy "Public can view galleries."
  on public.galleries for select
  using ( true );

-- Policies for Photos: Photographers can CRUD their own
create policy "Photographers can CRUD photos in their galleries."
  on public.photos for all
  using (
    exists (
      select 1 from public.galleries
      where galleries.id = photos.gallery_id
      and galleries.user_id = auth.uid()
    )
  );

-- Policies for Photos: Public can view photos attached to a gallery
create policy "Public can view photos."
  on public.photos for select
  using ( true );

-- 4. Create the Storage Bucket for high-res uploads
insert into storage.buckets (id, name, public) values ('portfolios', 'portfolios', true);

-- Storage Policies
create policy "Photographers can upload and manage images."
  on storage.objects for all
  using ( bucket_id = 'portfolios' and auth.role() = 'authenticated' );

create policy "Public can view images."
  on storage.objects for select
  using ( bucket_id = 'portfolios' );
