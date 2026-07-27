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
