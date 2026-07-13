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
