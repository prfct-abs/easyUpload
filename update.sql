-- Please run this exact command in your Supabase SQL Editor to support Studio Names!

ALTER TABLE public.galleries 
ADD COLUMN IF NOT EXISTS studio_name text;
