
-- ROLES
CREATE TYPE public.app_role AS ENUM ('admin', 'editor', 'reader');

CREATE TABLE public.user_roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role app_role NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, role)
);
GRANT SELECT ON public.user_roles TO authenticated;
GRANT ALL ON public.user_roles TO service_role;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "users view own roles" ON public.user_roles FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role app_role)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role)
$$;

-- PROFILES
CREATE TABLE public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name text,
  bio text,
  avatar_url text,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.profiles TO anon, authenticated;
GRANT INSERT, UPDATE ON public.profiles TO authenticated;
GRANT ALL ON public.profiles TO service_role;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles public read" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "profiles self update" ON public.profiles FOR UPDATE TO authenticated USING (auth.uid() = id);
CREATE POLICY "profiles self insert" ON public.profiles FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name) VALUES (new.id, COALESCE(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1)));
  RETURN new;
END; $$;
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- CATEGORIES
CREATE TABLE public.categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text NOT NULL UNIQUE,
  name text NOT NULL,
  color text NOT NULL,
  description text
);
GRANT SELECT ON public.categories TO anon, authenticated;
GRANT ALL ON public.categories TO service_role;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "categories public read" ON public.categories FOR SELECT USING (true);
CREATE POLICY "admins manage categories" ON public.categories FOR ALL TO authenticated
  USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));

INSERT INTO public.categories (slug, name, color, description) VALUES
  ('politique', 'Politique', '#C62828', 'Gouvernance locale, décentralisation, élections'),
  ('developpement', 'Développement', '#1565C0', 'Infrastructures et projets locaux'),
  ('education', 'Éducation', '#6A1B9A', 'Scolarisation et formation'),
  ('sante', 'Santé', '#00695C', 'Santé publique et bien-être'),
  ('culture', 'Culture', '#E65100', 'Patrimoine et arts'),
  ('environnement', 'Environnement', '#2E7D32', 'Écologie et agriculture'),
  ('interview', 'Interview', '#4E342E', 'Entretiens avec personnalités'),
  ('portrait', 'Portrait', '#37474F', 'Figures locales remarquables');

-- COMMUNES
CREATE TABLE public.communes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text NOT NULL UNIQUE,
  name text NOT NULL,
  region text NOT NULL,
  prefecture text,
  chef_lieu text
);
GRANT SELECT ON public.communes TO anon, authenticated;
GRANT ALL ON public.communes TO service_role;
ALTER TABLE public.communes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "communes public read" ON public.communes FOR SELECT USING (true);
CREATE POLICY "admins manage communes" ON public.communes FOR ALL TO authenticated
  USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));

INSERT INTO public.communes (slug, name, region, prefecture) VALUES
  ('lome', 'Lomé', 'Maritime', 'Golfe'),
  ('agoe-nyive', 'Agoè-Nyivé', 'Maritime', 'Agoè-Nyivé'),
  ('tsevie', 'Tsévié', 'Maritime', 'Zio'),
  ('aneho', 'Aného', 'Maritime', 'Lacs'),
  ('tabligbo', 'Tabligbo', 'Maritime', 'Yoto'),
  ('atakpame', 'Atakpamé', 'Plateaux', 'Ogou'),
  ('kpalime', 'Kpalimé', 'Plateaux', 'Kloto'),
  ('notse', 'Notsé', 'Plateaux', 'Haho'),
  ('badou', 'Badou', 'Plateaux', 'Wawa'),
  ('sokode', 'Sokodé', 'Centrale', 'Tchaoudjo'),
  ('tchamba', 'Tchamba', 'Centrale', 'Tchamba'),
  ('blitta', 'Blitta', 'Centrale', 'Blitta'),
  ('kara', 'Kara', 'Kara', 'Kozah'),
  ('bassar', 'Bassar', 'Kara', 'Bassar'),
  ('niamtougou', 'Niamtougou', 'Kara', 'Doufelgou'),
  ('dapaong', 'Dapaong', 'Savanes', 'Tône'),
  ('mango', 'Mango', 'Savanes', 'Oti'),
  ('cinkasse', 'Cinkassé', 'Savanes', 'Cinkassé');

-- ARTICLES
CREATE TABLE public.articles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text NOT NULL UNIQUE,
  title text NOT NULL,
  excerpt text,
  content text NOT NULL,
  cover_image text,
  category_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
  commune_id uuid REFERENCES public.communes(id) ON DELETE SET NULL,
  author_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  tags text[] DEFAULT '{}',
  status text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published')),
  featured boolean NOT NULL DEFAULT false,
  views integer NOT NULL DEFAULT 0,
  published_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX articles_status_pub_idx ON public.articles (status, published_at DESC);
CREATE INDEX articles_category_idx ON public.articles (category_id);
CREATE INDEX articles_commune_idx ON public.articles (commune_id);
GRANT SELECT ON public.articles TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.articles TO authenticated;
GRANT ALL ON public.articles TO service_role;
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "published articles public" ON public.articles FOR SELECT
  USING (status = 'published' OR public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'editor'));
CREATE POLICY "editors insert articles" ON public.articles FOR INSERT TO authenticated
  WITH CHECK (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'editor'));
CREATE POLICY "editors update articles" ON public.articles FOR UPDATE TO authenticated
  USING (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'editor'));
CREATE POLICY "admins delete articles" ON public.articles FOR DELETE TO authenticated
  USING (public.has_role(auth.uid(),'admin'));

CREATE OR REPLACE FUNCTION public.touch_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;
CREATE TRIGGER articles_updated BEFORE UPDATE ON public.articles FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();

-- COMMENTS
CREATE TABLE public.comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  article_id uuid NOT NULL REFERENCES public.articles(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  author_name text NOT NULL,
  content text NOT NULL,
  approved boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.comments TO anon, authenticated;
GRANT INSERT ON public.comments TO authenticated;
GRANT UPDATE, DELETE ON public.comments TO authenticated;
GRANT ALL ON public.comments TO service_role;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "approved comments public" ON public.comments FOR SELECT
  USING (approved = true OR public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'editor'));
CREATE POLICY "auth users create comments" ON public.comments FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);
CREATE POLICY "admins moderate comments" ON public.comments FOR UPDATE TO authenticated
  USING (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'editor'));
CREATE POLICY "admins delete comments" ON public.comments FOR DELETE TO authenticated
  USING (public.has_role(auth.uid(),'admin') OR public.has_role(auth.uid(),'editor'));

-- NEWSLETTER
CREATE TABLE public.newsletter_subscribers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE,
  first_name text,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT INSERT ON public.newsletter_subscribers TO anon, authenticated;
GRANT SELECT, DELETE ON public.newsletter_subscribers TO authenticated;
GRANT ALL ON public.newsletter_subscribers TO service_role;
ALTER TABLE public.newsletter_subscribers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anyone can subscribe" ON public.newsletter_subscribers FOR INSERT WITH CHECK (true);
CREATE POLICY "admins read subscribers" ON public.newsletter_subscribers FOR SELECT TO authenticated
  USING (public.has_role(auth.uid(),'admin'));
CREATE POLICY "admins delete subscribers" ON public.newsletter_subscribers FOR DELETE TO authenticated
  USING (public.has_role(auth.uid(),'admin'));
