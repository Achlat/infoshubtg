
-- Fix function search path
CREATE OR REPLACE FUNCTION public.touch_updated_at()
RETURNS trigger LANGUAGE plpgsql SET search_path = public AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

-- Restrict has_role function execution
REVOKE EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) TO authenticated, service_role;

-- Storage policies for article-images bucket
CREATE POLICY "article images public read" ON storage.objects FOR SELECT
  USING (bucket_id = 'article-images');
CREATE POLICY "editors upload article images" ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'article-images' AND (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'editor')));
CREATE POLICY "editors update article images" ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id = 'article-images' AND (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'editor')));
CREATE POLICY "admins delete article images" ON storage.objects FOR DELETE TO authenticated
  USING (bucket_id = 'article-images' AND public.has_role(auth.uid(),'admin'));
