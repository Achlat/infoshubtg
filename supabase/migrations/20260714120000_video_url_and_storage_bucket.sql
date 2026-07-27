-- Add video_url column used by ArticleForm/article detail, and create the
-- article-images storage bucket referenced by existing storage policies.

ALTER TABLE public.articles ADD COLUMN IF NOT EXISTS video_url text;

INSERT INTO storage.buckets (id, name, public)
VALUES ('article-images', 'article-images', true)
ON CONFLICT (id) DO NOTHING;
