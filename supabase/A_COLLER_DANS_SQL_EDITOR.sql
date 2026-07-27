-- ===== 20260619104430_2da3f4ba-c0ab-489d-883a-90851154d7b3.sql =====

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

-- ===== 20260619104448_98e47525-197b-4a4f-90a1-5ab395cad1e3.sql =====

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

-- ===== 20260619104500_3ceca0b4-4770-41ac-b3d0-c50a44d41aed.sql =====

REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.touch_updated_at() FROM PUBLIC, anon, authenticated;

DROP POLICY IF EXISTS "anyone can subscribe" ON public.newsletter_subscribers;
CREATE POLICY "anyone can subscribe" ON public.newsletter_subscribers FOR INSERT
  WITH CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' AND length(email) <= 254);

-- ===== 20260619104522_fec4832c-ed74-4b27-b2c7-313c7d9c5e9b.sql =====

CREATE OR REPLACE FUNCTION public.claim_first_admin()
RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE _uid uuid := auth.uid();
BEGIN
  IF _uid IS NULL THEN RETURN false; END IF;
  IF EXISTS (SELECT 1 FROM public.user_roles WHERE role = 'admin') THEN RETURN false; END IF;
  INSERT INTO public.user_roles (user_id, role) VALUES (_uid, 'admin') ON CONFLICT DO NOTHING;
  RETURN true;
END; $$;
REVOKE EXECUTE ON FUNCTION public.claim_first_admin() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.claim_first_admin() TO authenticated;

-- ===== 20260619200000_seed_test_articles.sql =====
-- Seed : 6 articles de test — 19 juin 2026

-- Article 1 : Vérification des diplômes (Nouvelledafrique.tg)
INSERT INTO public.articles (slug, title, excerpt, content, cover_image, category_id, commune_id, tags, status, featured, published_at)
VALUES (
  'togo-etat-intensifie-verification-diplomes-fonction-publique',
  'Togo : l''État intensifie la vérification des diplômes dans la fonction publique',
  'L''administration togolaise lance une vaste opération de vérification des diplômes visant les agents publics, notamment ceux formés à l''étranger, dans le cadre de la lutte contre les fraudes académiques.',
  $c1$Au Togo, l'administration franchit une nouvelle étape dans sa lutte contre les irrégularités académiques et administratives. Le ministère de l'Éducation nationale a lancé une vaste opération de vérification des diplômes visant plusieurs agents publics, notamment ceux ayant suivi leur formation à l'étranger.

Dans une note adressée aux services régionaux, les autorités exigent un examen minutieux des dossiers académiques et administratifs. Les diplômes légalisés, arrêtés de recrutement et preuves de service doivent désormais être authentifiés afin d'éviter les fraudes et les avancements indus.

Cette opération s'inscrit dans le contexte de la lutte contre les faux diplômes et les irrégularités qui fragilisent la crédibilité de la fonction publique. Les services concernés ont jusqu'au 10 juillet 2026 pour boucler ce processus de vérification.

La démarche traduit la volonté de l'État togolais de renforcer la transparence et la probité dans l'administration. Elle vise à restaurer la confiance des citoyens dans les institutions et à garantir que les postes publics soient occupés par des agents qualifiés et légitimes.

Ce contrôle des diplômes marque une étape importante dans la réforme administrative en cours, où le mérite et la responsabilité deviennent des critères incontournables.$c1$,
  NULL,
  (SELECT id FROM public.categories WHERE slug = 'education'),
  NULL,
  ARRAY['diplômes', 'fonction publique', 'réforme', 'administration', 'éducation'],
  'published',
  true,
  '2026-06-19 08:00:00+00'
) ON CONFLICT (slug) DO NOTHING;

-- Article 2 : D1 LONATO sanctions (Le Défenseur)
INSERT INTO public.articles (slug, title, excerpt, content, cover_image, category_id, commune_id, tags, status, featured, published_at)
VALUES (
  'd1-lonato-lourdes-sanctions-manipulation-presumee-matchs',
  'D1 LONATO : lourdes sanctions pour manipulation présumée de matchs',
  'La Commission de discipline de la Fédération Togolaise de Football a rendu son verdict dans l''affaire des présumées manipulations de matchs ayant marqué les deux dernières journées de la D1 LONATO 2025-2026.',
  $c2$La Commission de discipline de la Fédération Togolaise de Football (FTF) a rendu son verdict dans l'affaire des présumées manipulations de matchs ayant marqué les deux dernières journées de la D1 LONATO 2025-2026.

Le président du FC Espoir de Zio, Kokou Toulassi, est suspendu de toute activité liée au football pour six ans et condamné à une amende de 500 000 FCFA. L'entraîneur de l'AS Binah, Théophile Bola, écope quant à lui d'une suspension de cinq ans et six mois, d'une amende de 500 000 FCFA et devra présenter des excuses publiques à la FTF.

Malgré ces sanctions sévères, les résultats des rencontres des 24 et 31 mai sont maintenus, faute de preuves suffisantes d'une manipulation effectivement exécutée sur le terrain. Plusieurs dirigeants de clubs, initialement cités dans l'affaire, ont été blanchis par la commission.

Les parties disposent de dix jours pour faire appel de cette décision. Cette affaire a mis en lumière les défis auxquels fait face le football togolais dans sa lutte pour l'intégrité des compétitions sportives.$c2$,
  'https://ledefenseurinfo.tg/wp-content/uploads/2024/11/FTF-cmm2-1068x739-1.jpg',
  (SELECT id FROM public.categories WHERE slug = 'culture'),
  NULL,
  ARRAY['football', 'D1', 'LONATO', 'FTF', 'sanctions', 'sport'],
  'published',
  true,
  '2026-06-19 09:00:00+00'
) ON CONFLICT (slug) DO NOTHING;

-- Article 3 : Braquage Adoboukomé (Le Défenseur)
INSERT INTO public.articles (slug, title, excerpt, content, cover_image, category_id, commune_id, tags, status, featured, published_at)
VALUES (
  'lome-braquage-arme-deux-blesses-graves-adoboukome',
  'Lomé : un braquage armé fait deux blessés graves à Adoboukomé',
  'Un braquage à main armée a provoqué une vive panique jeudi 18 juin à Adoboukomé, près du Grand Marché de Lomé, faisant deux blessés graves.',
  $c3$Un braquage à main armée a provoqué une vive panique jeudi 18 juin à Adoboukomé, dans le quartier du Grand Marché de Lomé.

Vers 13 heures, au carrefour Orabank, un homme armé circulant à moto — immatriculée au Ghana selon des témoignages — a attaqué un véhicule transportant un ressortissant libanais et son chauffeur.

Après avoir ouvert le feu à travers les vitres du véhicule, le malfaiteur s'est emparé d'une mallette avant de prendre la fuite, abandonnant sa moto sur les lieux.

Les deux occupants du véhicule, grièvement blessés par balles, ont été rapidement évacués vers un centre de santé pour y recevoir des soins d'urgence. Les forces de sécurité sont intervenues promptement pour sécuriser la zone et ont ouvert une enquête afin d'identifier et d'interpeller l'auteur de cette attaque.

Cet incident soulève une nouvelle fois les préoccupations des habitants et des commerçants du secteur quant à la sécurité dans cette zone à forte densité commerciale.$c3$,
  'https://ledefenseurinfo.tg/wp-content/uploads/2026/06/IMG-20260619-WA0320.webp',
  (SELECT id FROM public.categories WHERE slug = 'politique'),
  (SELECT id FROM public.communes WHERE slug = 'lome'),
  ARRAY['braquage', 'Lomé', 'sécurité', 'Adoboukomé', 'violence'],
  'published',
  false,
  '2026-06-19 10:00:00+00'
) ON CONFLICT (slug) DO NOTHING;

-- Article 4 : FII Europe 2026 (Actu-Togo)
INSERT INTO public.articles (slug, title, excerpt, content, cover_image, category_id, commune_id, tags, status, featured, published_at)
VALUES (
  'fii-europe-2026-faure-gnassingbe-perspectives-fonds-souverain-saoudien',
  'FII Europe 2026 : Faure Gnassingbé ouvre de nouvelles perspectives avec le fonds souverain saoudien',
  'En marge du sommet Future Investment Initiative (FII) Europe 2026 à Rome, le Président du Conseil Faure Gnassingbé a eu une séance de travail avec le gouverneur du fonds souverain saoudien, explorant de nouvelles pistes d''investissement.',
  $c4$Les échanges autour des investissements stratégiques se poursuivent au sommet Future Investment Initiative (FII) Europe 2026, qui se tient à Rome. En marge de cette rencontre internationale réunissant décideurs économiques, investisseurs et dirigeants du monde entier, le Président du Conseil Faure Essozimna Gnassingbé a eu une séance de travail avec Yasir ben Othman Al-Rumayyan, gouverneur du Fonds Public d'Investissement (PIF) d'Arabie Saoudite.

Au cœur de cet entretien bilatéral, les deux parties ont exploré des pistes de coopération et d'investissement dans des secteurs clés pour le développement du Togo : l'agriculture et la transformation agricole — notamment la filière coton —, les infrastructures portuaires et logistiques, ainsi que l'industrie manufacturière.

Avec des actifs estimés à plusieurs centaines de milliards de dollars, le Fonds Public d'Investissement saoudien est l'un des plus importants fonds souverains au monde. Il joue un rôle croissant dans le financement de projets de développement en Afrique à travers des partenariats stratégiques ciblés.

Cette rencontre s'inscrit dans la diplomatie économique active menée par le Togo pour mobiliser des capitaux auprès des grands partenaires financiers internationaux, en vue de soutenir la modernisation économique, le développement des chaînes de valeur locales et la création d'emplois.

Le sommet FII Europe 2026 a réuni plus de mille investisseurs, chefs d'entreprise et représentants gouvernementaux à Rome, autour des thèmes de la souveraineté économique, de la mobilisation des capitaux, de l'innovation, de la compétitivité industrielle et de la coopération public-privé à travers plusieurs continents.$c4$,
  'https://actu-togo.tg/wp-content/uploads/2026/06/IMG_9414.jpeg',
  (SELECT id FROM public.categories WHERE slug = 'politique'),
  NULL,
  ARRAY['FII', 'investissement', 'Arabie Saoudite', 'Faure Gnassingbé', 'diplomatie', 'économie'],
  'published',
  true,
  '2026-06-19 11:00:00+00'
) ON CONFLICT (slug) DO NOTHING;

-- Article 5 : FMI Club diplomatique (Actu-Togo)
INSERT INTO public.articles (slug, title, excerpt, content, cover_image, category_id, commune_id, tags, status, featured, published_at)
VALUES (
  'togo-fmi-echange-diplomatique-club-diplomatique-lome',
  'Togo : le FMI au cœur d''un échange diplomatique au Club diplomatique de Lomé',
  'Des diplomates et acteurs de la coopération internationale se sont réunis au Club diplomatique de Lomé pour échanger sur l''évolution du FMI depuis les accords de Bretton Woods jusqu''au 21e siècle.',
  $c5$Des diplomates, représentants consulaires et acteurs de la coopération internationale se sont réunis au Club diplomatique de Lomé pour un échange centré sur l'évolution du Fonds Monétaire International (FMI) depuis sa création.

La représentante résidente du FMI au Togo, Mme Racheeda Boukezia, a animé la rencontre sur le thème « De Bretton Woods au 21e siècle, le FMI et son histoire ». Son intervention a retracé les grandes transformations institutionnelles depuis les accords de Bretton Woods de 1944, qui ont posé les bases du système monétaire international d'après-guerre.

Les échanges ont porté sur le rôle du FMI dans la stabilité financière mondiale, les réalités économiques africaines, les mécanismes d'appui aux États membres et les réformes en cours au sein des institutions financières internationales. Les défis de la croissance, de la résilience économique et de la mobilisation des ressources ont également été au cœur des débats.

Le dialogue a mis en lumière l'importance de la concertation entre partenaires afin d'accompagner les transformations économiques observées à l'échelle du continent africain.

Le ministre togolais des Affaires étrangères, Robert Dussey, a exprimé sa gratitude pour la qualité des échanges et la participation des acteurs diplomatiques, soulignant l'intérêt du Togo pour la gouvernance financière, la coopération multilatérale et le développement durable dans un contexte mondial en mutation.$c5$,
  'https://actu-togo.tg/wp-content/uploads/2026/06/IMG_9421.jpeg',
  (SELECT id FROM public.categories WHERE slug = 'politique'),
  (SELECT id FROM public.communes WHERE slug = 'lome'),
  ARRAY['FMI', 'diplomatie', 'Lomé', 'économie', 'coopération', 'Bretton Woods'],
  'published',
  false,
  '2026-06-19 12:00:00+00'
) ON CONFLICT (slug) DO NOTHING;

-- Article 6 : Militaires à la retraite (Togo Breaking News)
INSERT INTO public.articles (slug, title, excerpt, content, cover_image, category_id, commune_id, tags, status, featured, published_at)
VALUES (
  'militaires-retraite-gouvernement-togolais-brisera-silence',
  'Militaires à la retraite : le gouvernement togolais brisera-t-il le silence ?',
  'La diffusion sur les réseaux sociaux d''une déclaration de militaires à la retraite en uniforme a déclenché une vague d''indignation. La députée Brigitte Adjamagbo-Johnson saisit l''Assemblée nationale pour exiger des comptes.',
  $c6$Au Togo, la diffusion sur les réseaux sociaux d'une déclaration de militaires à la retraite arborant leurs grades a déclenché une vague d'indignation chez les citoyens et la société civile. La députée Brigitte Adjamagbo-Johnson saisit l'Assemblée nationale pour exiger des comptes.

C'est une séquence numérique qui ne passe pas auprès d'une partie de l'opinion publique togolaise. Depuis quelques jours, les réseaux sociaux s'enflamment après la publication d'une déclaration officielle émanant d'un groupe d'individus se présentant comme des « corps habillés à la retraite ». Ce qui choque la toile ? Ces militaires à la retraite ont choisi de s'afficher publiquement en uniforme, arborant fièrement leurs insignes et leurs grades pour porter un message dans l'arène publique.

Pour de nombreux internautes, activistes et acteurs politiques, cette mise en scène franchit une ligne rouge républicaine. Face à la montée de la colère et des inquiétudes en ligne, la députée Brigitte Kafui Adjamagbo-Johnson, figure de proue de la Dynamique pour la Majorité du Peuple (DMP), a décidé de porter le fer sur le terrain institutionnel. Elle a adressé, le 16 juin 2026, une question orale au gouvernement par l'intermédiaire du président de l'Assemblée nationale.

Sur X (ex-Twitter), Facebook et dans les boucles de messagerie WhatsApp, les réactions de citoyens et de figures de la société civile oscillent entre stupéfaction et colère. Les critiques se cristallisent sur l'usage des attributs de l'armée à des fins de communication politique par des civils — le statut de retraité conférant constitutionnellement le retour à la vie civile.

Les arguments avancés par les internautes indignés se résument en trois points cardinaux. D'abord, l'uniforme militaire appartient à l'État et symbolise la protection de tous ; il ne peut servir de costume de scène pour des déclarations partisanes ou corporatistes. Ensuite, l'affichage de grades militaires dans l'espace public est perçu comme une tentative d'infuser une autorité indue dans le débat social. Enfin, des citoyens s'interrogent sur le deux poids, deux mesures, rappelant les restrictions sévères qui pèsent habituellement sur les manifestations de la société civile indépendante.

Dans un communiqué officiel publié à Lomé le jeudi 18 juin 2026, Brigitte Adjamagbo-Johnson recadre le débat autour des principes fondamentaux de l'État de droit. Sa démarche parlementaire s'inscrit dans la mission de contrôle de l'action gouvernementale dévolue aux élus du peuple. L'élue de l'opposition exige que l'exécutif se prononce clairement sur la légalité et l'opportunité d'une telle sortie publique.

Avant Brigitte Adjamagbo-Johnson, Nathaniel Olympio avait dénoncé le 15 juin dernier les menaces proférées par ces militaires à la retraite qui évoquaient l'idée de combattre les « ennemis de Faure Gnassingbé jusqu'au dernier souffle ».

Au-delà du cas spécifique, cette affaire met en lumière une crise plus profonde : le mutisme chronique du gouvernement face aux interpellations des députés de l'opposition. L'opposition togolaise cherche à savoir si le gouvernement osera, cette fois-ci, rompre le silence sur un sujet qui touche au cœur même de la sécurité et de la neutralité de l'État.$c6$,
  'https://togobreakingnews.info/wp-content/uploads/2026/06/Militaires_Retraite.webp',
  (SELECT id FROM public.categories WHERE slug = 'politique'),
  NULL,
  ARRAY['militaires', 'retraite', 'politique', 'Assemblée nationale', 'gouvernement', 'société civile'],
  'published',
  true,
  '2026-06-19 13:00:00+00'
) ON CONFLICT (slug) DO NOTHING;

-- ===== 20260714120000_video_url_and_storage_bucket.sql =====
-- Add video_url column used by ArticleForm/article detail, and create the
-- article-images storage bucket referenced by existing storage policies.

ALTER TABLE public.articles ADD COLUMN IF NOT EXISTS video_url text;

INSERT INTO storage.buckets (id, name, public)
VALUES ('article-images', 'article-images', true)
ON CONFLICT (id) DO NOTHING;

-- ===== 20260715120000_seed_articles_juillet2026.sql =====
-- Ajout de la commune Tandjouaré 1 (absente du seed initial des communes)
INSERT INTO public.communes (slug, name, region, prefecture) VALUES
  ('tandjouare-1', 'Tandjouaré 1', 'Savanes', 'Tandjouaré')
ON CONFLICT (slug) DO NOTHING;

-- Article 1 : Distribution gratuite de moustiquaires imprégnées à Tandjouaré
INSERT INTO public.articles (slug, title, excerpt, content, cover_image, category_id, commune_id, tags, status, featured, published_at)
VALUES (
  'tandjouare-lancement-distribution-gratuite-moustiquaires-mii',
  'Préfecture de Tandjouaré : lancement officiel de la distribution gratuite des Moustiquaires Imprégnées d''insecticides (MII)',
  'Ce mardi 14 juillet 2026 a eu lieu à l''École Primaire Publique de Moumouane le lancement officiel de la campagne de distribution gratuite des Moustiquaires Imprégnées d''Insecticides dans la Commune de Tandjouaré 1.',
  $a1$Ce mardi 14 juillet 2026, a eu lieu le lancement officiel de la campagne de distribution gratuite des Moustiquaires Imprégnées d'Insecticides (MII) à l'École Primaire Publique de Moumouane, dans le canton de Nandoga, dans la Commune de Tandjouaré 1.

La cérémonie a été présidée par le Préfet de Tandjouaré, M. Oukoura AGBANTE, en présence des autorités administratives et locales, notamment les maires des Communes de Tandjouaré 1 et 2, les responsables sanitaires, le chef de canton, les leaders communautaires ainsi qu'une forte mobilisation des populations.

Dans son intervention, le Préfet a rappelé que le paludisme demeure un important problème de santé publique et a invité les populations à retirer leurs moustiquaires sur présentation de leur coupon d'enrôlement, puis à les utiliser correctement chaque nuit afin de protéger toute la famille contre cette maladie.

Le responsable du CHP de Tandjouaré, M. AFANGBEDJI Koami, a également sensibilisé l'assistance sur les bonnes pratiques d'utilisation et d'entretien des moustiquaires, soulignant qu'une moustiquaire imprégnée est efficace lorsqu'elle est correctement installée et utilisée chaque nuit.

Le lancement officiel a été marqué par la remise symbolique des premières moustiquaires à des bénéficiaires, donnant ainsi le coup d'envoi de la distribution gratuite qui se poursuivra du 14 au 18 juillet 2026 dans les différents sites de la préfecture.

Les autorités ont exhorté les populations à se rendre dans les centres de distribution munies de leur coupon d'enrôlement et ont salué l'engagement des chefs de cantons, des relais communautaires et de tous les acteurs mobilisés pour assurer le succès de cette campagne.

Dormir sous une moustiquaire imprégnée chaque nuit, c'est se protéger efficacement contre le paludisme. Ensemble, faisons de cette campagne une réussite pour une préfecture de Tandjouaré en meilleure santé.$a1$,
  'https://z-p3-scontent.flfw5-1.fna.fbcdn.net/v/t39.30808-6/747832593_122224493750287726_5138477229591088771_n.jpg?stp=dst-jpg_tt6&cstp=mx1536x2048&ctp=p600x600&_nc_cat=109&ccb=1-7&_nc_sid=b96d88&_nc_ohc=1JEIT-nOWjgQ7kNvwFqsgQL&_nc_oc=AdrZmWWnWgo0-dLCHOXcDdtt5i1zpXM6lbuSdQkiMsCmvVBirlxoe6iYb0rMQorL9cc&_nc_zt=23&_nc_ht=z-p3-scontent.flfw5-1.fna&_nc_gid=prb63EZEJrrOC3LnHjIJhg&_nc_ss=7820f&oh=00_AQBw_B0Zi_fxHDQ1kDGiXm1dcgdALM-AeDf8o7BZm2NfJw&oe=6A5D59FE',
  (SELECT id FROM public.categories WHERE slug = 'sante'),
  (SELECT id FROM public.communes WHERE slug = 'tandjouare-1'),
  ARRAY['paludisme', 'santé publique', 'moustiquaires', 'Tandjouaré', 'MII'],
  'published',
  true,
  '2026-07-14 09:00:00+00'
) ON CONFLICT (slug) DO NOTHING;

-- Article 2 : Togo parmi les pays ayant le plus renforcé la lutte contre la corruption
INSERT INTO public.articles (slug, title, excerpt, content, cover_image, category_id, commune_id, tags, status, featured, published_at)
VALUES (
  'afrique-bonne-gouvernance-togo-lutte-corruption-dix-ans',
  'Afrique/Bonne Gouvernance : le Togo parmi les pays qui ont le plus renforcé la lutte contre la corruption en dix ans',
  'Selon les résultats préliminaires de l''Indice Ibrahim de la gouvernance africaine (IIAG) 2026, le Togo figure parmi les cinq États africains ayant le plus amélioré leurs performances en matière de lutte contre la corruption entre 2016 et 2025.',
  $a2$Le Togo confirme la progression de ses mécanismes de gouvernance. Selon les résultats préliminaires de l'Indice Ibrahim de la gouvernance africaine (IIAG) 2026, publiés le 8 juillet par la Fondation Mo Ibrahim, le pays figure parmi les cinq États africains ayant le plus amélioré leurs performances en matière de lutte contre la corruption entre 2016 et 2025.

Cette évaluation place le Togo au 17ᵉ rang sur le continent pour cet indicateur. Surtout, il apparaît parmi les pays ayant enregistré les avancées les plus marquées au cours de la dernière décennie. Seuls les Seychelles, l'Angola, le Tchad et la Somalie affichent une progression comparable selon les données de la Fondation Mo Ibrahim.

Ce résultat traduit l'évolution des dispositifs mis en place au fil des dernières années afin de consolider la transparence dans la gestion publique. Le pays a engagé plusieurs réformes destinées à moderniser l'administration, renforcer les procédures de contrôle, accélérer la dématérialisation des services publics et améliorer le cadre réglementaire. Parallèlement, les autorités ont poursuivi leurs actions en faveur de la prévention des infractions économiques et financières.

Cette évolution intervient alors que le Togo multiplie les mesures destinées à consolider son climat des affaires. Les réformes engagées dans les domaines de la gouvernance économique, des finances publiques, des marchés publics et de la digitalisation ont contribué à améliorer la confiance des opérateurs économiques.

L'Indice Ibrahim de la gouvernance africaine (IIAG), considéré comme l'un des principaux outils d'évaluation de la gouvernance sur le continent, analyse les performances des 54 pays africains à partir de plusieurs dizaines d'indicateurs. Il prend en compte, entre autres, la sécurité, l'État de droit, la transparence, la participation citoyenne, le développement économique ainsi que la qualité des services publics.

La publication intégrale de l'édition 2026 est attendue le 31 octobre prochain. Les résultats préliminaires consacrés à la lutte contre la corruption placent toutefois le Togo parmi les pays ayant enregistré les progrès les plus nets sur ce volet au cours des dix dernières années.

Source : actu-togo.tg$a2$,
  'https://actu-togo.tg/wp-content/uploads/2026/07/IMG_1460.jpeg',
  (SELECT id FROM public.categories WHERE slug = 'politique'),
  NULL,
  ARRAY['gouvernance', 'corruption', 'IIAG', 'Mo Ibrahim', 'Togo', 'Afrique'],
  'published',
  false,
  '2026-07-14 10:00:00+00'
) ON CONFLICT (slug) DO NOTHING;

-- Article 3 : Evala 2026, sécurité de proximité
INSERT INTO public.articles (slug, title, excerpt, content, cover_image, category_id, commune_id, tags, status, featured, published_at)
VALUES (
  'togo-evala-2026-securite-proximite-deploiement',
  'Togo/Evala 2026 : la sécurité de proximité se déploie au plus près des populations',
  'À l''occasion des luttes traditionnelles Evala 2026, le ministère de la Sécurité renforce sa présence sur les différents sites de la manifestation à travers une opération intégrée de proximité.',
  $a3$À l'occasion des luttes traditionnelles Evala 2026, le ministère de la Sécurité renforce sa présence sur les différents sites de la manifestation. Au-delà du dispositif de maintien de l'ordre, l'action publique met l'accent sur la prévention, la sensibilisation et l'accès direct à plusieurs services destinés aux citoyens.

Cette mobilisation repose sur une opération intégrée de proximité qui réunit plusieurs structures du ministère. Les équipes de l'Agence nationale de la protection civile (ANPC), de la Direction de la sécurité routière (DSR), de l'Agence nationale de cybersécurité (ANCy), du Centre national d'alerte et de coordination (CNAD), du Comité interministériel de prévention et de lutte contre l'extrémisme violent (CIPLEV), du Corps des sapeurs-pompiers ainsi que de la Police nationale interviennent sur les différents espaces qui accueillent les festivités.

Au fil des rencontres, les visiteurs reçoivent des conseils sur les gestes de prévention, la sécurité routière, la protection civile et les risques liés au numérique. Les équipes échangent également avec les populations sur les comportements à adopter afin de préserver un climat serein tout au long des célébrations.

Parallèlement, des prestations de police de proximité sont proposées afin de rapprocher l'administration des citoyens, parmi lesquelles l'établissement des cartes nationales d'identité, un service qui facilite les démarches administratives des personnes présentes sur les sites des Evala.

Les Evala, qui réunissent chaque année des milliers de participants venus de différentes régions du pays ainsi que de la diaspora, mobilisent ainsi un important dispositif humain et logistique associant les forces de sécurité, les services de secours ainsi que les structures spécialisées dans la prévention des risques et la protection des personnes.

Le ministère de la Sécurité résume cette mobilisation par un message clair : « Prévenir, protéger et servir », réaffirmant son engagement « pour faire des Evala 2026 une fête placée sous le signe de la paix, de la sécurité et de la cohésion sociale ».

Source : actu-togo.tg$a3$,
  'https://actu-togo.tg/wp-content/uploads/2026/07/IMG_1440.jpeg',
  (SELECT id FROM public.categories WHERE slug = 'politique'),
  (SELECT id FROM public.communes WHERE slug = 'kara'),
  ARRAY['Evala', 'sécurité', 'Togo', 'Kara', 'ministère de la Sécurité'],
  'published',
  false,
  '2026-07-14 11:00:00+00'
) ON CONFLICT (slug) DO NOTHING;

-- Article 4 : Croix-Rouge Togolaise, stratégie nationale RRC-ACC
INSERT INTO public.articles (slug, title, excerpt, content, cover_image, category_id, commune_id, tags, status, featured, published_at)
VALUES (
  'croix-rouge-togolaise-strategie-nationale-rrc-acc',
  'La Croix-Rouge Togolaise finalise son document de stratégie nationale en RRC-ACC',
  'La Croix-Rouge Togolaise travaille à l''adoption d''une stratégie nationale en Réduction de Risques de Catastrophes et Adaptation au Changement Climatique (RRC-ACC).',
  $a4$La Croix-Rouge Togolaise travaille à l'adoption d'une stratégie nationale en Réduction de Risques de Catastrophes et Adaptation au Changement Climatique (RRC-ACC), un cadre destiné à mieux structurer les actions de prévention et de réponse face aux catastrophes naturelles et aux effets du changement climatique sur le territoire togolais.

Cette démarche vise à consolider les capacités d'anticipation et d'intervention de l'organisation humanitaire auprès des communautés les plus vulnérables, en cohérence avec les priorités nationales de résilience climatique.

Pour lire l'article complet, consultez la source : togoenlive.tg$a4$,
  'https://cms.togoenlive.tg/wp-content/uploads/2026/07/IMG-20260714-WA0022-1024x768.jpg',
  (SELECT id FROM public.categories WHERE slug = 'environnement'),
  NULL,
  ARRAY['Croix-Rouge', 'RRC-ACC', 'changement climatique', 'Togo', 'humanitaire'],
  'published',
  false,
  '2026-07-14 12:00:00+00'
) ON CONFLICT (slug) DO NOTHING;
