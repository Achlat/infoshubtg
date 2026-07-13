-- ============================================================
--  TOGO INFO HUB — Schéma MySQL / phpMyAdmin
--  Compatible MySQL 5.7+ / MariaDB 10.2+
--  Import : phpMyAdmin > Importer > choisir ce fichier
-- ============================================================

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET time_zone = '+00:00';
SET FOREIGN_KEY_CHECKS = 0;

-- Base de données
CREATE DATABASE IF NOT EXISTS `communestg`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `communestg`;

-- ============================================================
-- TABLE : users  (remplace Supabase Auth)
-- ============================================================
CREATE TABLE IF NOT EXISTS `users` (
  `id`            VARCHAR(36)  NOT NULL,
  `email`         VARCHAR(254) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `created_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$
DROP TRIGGER IF EXISTS `users_before_insert`$$
CREATE TRIGGER `users_before_insert`
BEFORE INSERT ON `users` FOR EACH ROW
BEGIN
  IF NEW.id = '' OR NEW.id IS NULL THEN
    SET NEW.id = UUID();
  END IF;
END$$
DELIMITER ;

-- ============================================================
-- TABLE : auth_tokens (jetons de session pour l'API PHP)
-- ============================================================
CREATE TABLE IF NOT EXISTS `auth_tokens` (
  `token`      VARCHAR(64) NOT NULL,
  `user_id`    VARCHAR(36) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`token`),
  KEY `auth_tokens_user_idx` (`user_id`),
  CONSTRAINT `fk_auth_tokens_user` FOREIGN KEY (`user_id`)
    REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : user_roles
-- ============================================================
CREATE TABLE IF NOT EXISTS `user_roles` (
  `id`         VARCHAR(36) NOT NULL,
  `user_id`    VARCHAR(36) NOT NULL,
  `role`       ENUM('admin','editor','reader') NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_roles_unique` (`user_id`, `role`),
  CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`)
    REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$
DROP TRIGGER IF EXISTS `user_roles_before_insert`$$
CREATE TRIGGER `user_roles_before_insert`
BEFORE INSERT ON `user_roles` FOR EACH ROW
BEGIN
  IF NEW.id = '' OR NEW.id IS NULL THEN
    SET NEW.id = UUID();
  END IF;
END$$
DELIMITER ;

-- ============================================================
-- TABLE : profiles
-- ============================================================
CREATE TABLE IF NOT EXISTS `profiles` (
  `id`           VARCHAR(36)  NOT NULL,
  `display_name` VARCHAR(255),
  `bio`          TEXT,
  `avatar_url`   TEXT,
  `created_at`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_profiles_user` FOREIGN KEY (`id`)
    REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : categories
-- ============================================================
CREATE TABLE IF NOT EXISTS `categories` (
  `id`          VARCHAR(36)  NOT NULL,
  `slug`        VARCHAR(100) NOT NULL,
  `name`        VARCHAR(100) NOT NULL,
  `color`       VARCHAR(20)  NOT NULL,
  `description` TEXT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `categories_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$
DROP TRIGGER IF EXISTS `categories_before_insert`$$
CREATE TRIGGER `categories_before_insert`
BEFORE INSERT ON `categories` FOR EACH ROW
BEGIN
  IF NEW.id = '' OR NEW.id IS NULL THEN
    SET NEW.id = UUID();
  END IF;
END$$
DELIMITER ;

-- Seed : catégories
INSERT IGNORE INTO `categories` (`id`, `slug`, `name`, `color`, `description`) VALUES
  ('11111111-1111-1111-1111-111111111101', 'politique',     'Politique',     '#C62828', 'Gouvernance locale, décentralisation, élections'),
  ('11111111-1111-1111-1111-111111111102', 'developpement', 'Développement', '#1565C0', 'Infrastructures et projets locaux'),
  ('11111111-1111-1111-1111-111111111103', 'education',     'Éducation',     '#6A1B9A', 'Scolarisation et formation'),
  ('11111111-1111-1111-1111-111111111104', 'sante',         'Santé',         '#00695C', 'Santé publique et bien-être'),
  ('11111111-1111-1111-1111-111111111105', 'culture',       'Culture',       '#E65100', 'Patrimoine et arts'),
  ('11111111-1111-1111-1111-111111111106', 'environnement', 'Environnement', '#2E7D32', 'Écologie et agriculture'),
  ('11111111-1111-1111-1111-111111111107', 'interview',     'Interview',     '#4E342E', 'Entretiens avec personnalités'),
  ('11111111-1111-1111-1111-111111111108', 'portrait',      'Portrait',      '#37474F', 'Figures locales remarquables');

-- ============================================================
-- TABLE : communes
-- ============================================================
CREATE TABLE IF NOT EXISTS `communes` (
  `id`         VARCHAR(36)  NOT NULL,
  `slug`       VARCHAR(100) NOT NULL,
  `name`       VARCHAR(100) NOT NULL,
  `region`     VARCHAR(100) NOT NULL,
  `prefecture` VARCHAR(100),
  `chef_lieu`  VARCHAR(100),
  PRIMARY KEY (`id`),
  UNIQUE KEY `communes_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$
DROP TRIGGER IF EXISTS `communes_before_insert`$$
CREATE TRIGGER `communes_before_insert`
BEFORE INSERT ON `communes` FOR EACH ROW
BEGIN
  IF NEW.id = '' OR NEW.id IS NULL THEN
    SET NEW.id = UUID();
  END IF;
END$$
DELIMITER ;

-- Seed : communes
INSERT IGNORE INTO `communes` (`id`, `slug`, `name`, `region`, `prefecture`) VALUES
  ('22222222-2222-2222-2222-222222222201', 'lome',        'Lomé',       'Maritime', 'Golfe'),
  ('22222222-2222-2222-2222-222222222202', 'agoe-nyive',  'Agoè-Nyivé', 'Maritime', 'Agoè-Nyivé'),
  ('22222222-2222-2222-2222-222222222203', 'tsevie',      'Tsévié',     'Maritime', 'Zio'),
  ('22222222-2222-2222-2222-222222222204', 'aneho',       'Aného',      'Maritime', 'Lacs'),
  ('22222222-2222-2222-2222-222222222205', 'tabligbo',    'Tabligbo',   'Maritime', 'Yoto'),
  ('22222222-2222-2222-2222-222222222206', 'atakpame',    'Atakpamé',   'Plateaux', 'Ogou'),
  ('22222222-2222-2222-2222-222222222207', 'kpalime',     'Kpalimé',    'Plateaux', 'Kloto'),
  ('22222222-2222-2222-2222-222222222208', 'notse',       'Notsé',      'Plateaux', 'Haho'),
  ('22222222-2222-2222-2222-222222222209', 'badou',       'Badou',      'Plateaux', 'Wawa'),
  ('22222222-2222-2222-2222-222222222210', 'sokode',      'Sokodé',     'Centrale', 'Tchaoudjo'),
  ('22222222-2222-2222-2222-222222222211', 'tchamba',     'Tchamba',    'Centrale', 'Tchamba'),
  ('22222222-2222-2222-2222-222222222212', 'blitta',      'Blitta',     'Centrale', 'Blitta'),
  ('22222222-2222-2222-2222-222222222213', 'kara',        'Kara',       'Kara',     'Kozah'),
  ('22222222-2222-2222-2222-222222222214', 'bassar',      'Bassar',     'Kara',     'Bassar'),
  ('22222222-2222-2222-2222-222222222215', 'niamtougou',  'Niamtougou', 'Kara',     'Doufelgou'),
  ('22222222-2222-2222-2222-222222222216', 'dapaong',     'Dapaong',    'Savanes',  'Tône'),
  ('22222222-2222-2222-2222-222222222217', 'mango',       'Mango',      'Savanes',  'Oti'),
  ('22222222-2222-2222-2222-222222222218', 'cinkasse',    'Cinkassé',   'Savanes',  'Cinkassé');

-- ============================================================
-- TABLE : articles
-- ============================================================
CREATE TABLE IF NOT EXISTS `articles` (
  `id`           VARCHAR(36)  NOT NULL,
  `slug`         VARCHAR(255) NOT NULL,
  `title`        TEXT         NOT NULL,
  `excerpt`      TEXT,
  `content`      LONGTEXT     NOT NULL,
  `cover_image`  TEXT,
  `video_url`    TEXT,
  `category_id`  VARCHAR(36)  DEFAULT NULL,
  `commune_id`   VARCHAR(36)  DEFAULT NULL,
  `author_id`    VARCHAR(36)  DEFAULT NULL,
  `tags`         JSON,
  `status`       ENUM('draft','published') NOT NULL DEFAULT 'draft',
  `featured`     TINYINT(1)   NOT NULL DEFAULT 0,
  `views`        INT UNSIGNED NOT NULL DEFAULT 0,
  `source_name`  VARCHAR(255) DEFAULT NULL,
  `source_url`   TEXT         DEFAULT NULL,
  `published_at` DATETIME     DEFAULT NULL,
  `created_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `articles_slug_unique` (`slug`),
  KEY `articles_status_pub_idx` (`status`, `published_at`),
  KEY `articles_category_idx`   (`category_id`),
  KEY `articles_commune_idx`    (`commune_id`),
  CONSTRAINT `fk_articles_category` FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_articles_commune`  FOREIGN KEY (`commune_id`)  REFERENCES `communes`(`id`)   ON DELETE SET NULL,
  CONSTRAINT `fk_articles_author`   FOREIGN KEY (`author_id`)   REFERENCES `users`(`id`)      ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$
DROP TRIGGER IF EXISTS `articles_before_insert`$$
CREATE TRIGGER `articles_before_insert`
BEFORE INSERT ON `articles` FOR EACH ROW
BEGIN
  IF NEW.id = '' OR NEW.id IS NULL THEN
    SET NEW.id = UUID();
  END IF;
END$$
DELIMITER ;

-- ============================================================
-- Seed : 6 articles
-- ============================================================

-- Article 1 : Vérification des diplômes (Nouvelledafrique.tg)
INSERT IGNORE INTO `articles`
  (`id`, `slug`, `title`, `excerpt`, `content`, `cover_image`, `category_id`, `commune_id`, `tags`, `status`, `featured`, `source_name`, `source_url`, `published_at`)
VALUES (
  'a0000000-0000-0000-0000-000000000001',
  'togo-etat-intensifie-verification-diplomes-fonction-publique',
  'Togo : l\'État intensifie la vérification des diplômes dans la fonction publique',
  'L\'administration togolaise lance une vaste opération de vérification des diplômes visant les agents publics, notamment ceux formés à l\'étranger, dans le cadre de la lutte contre les fraudes académiques.',
  'Au Togo, l\'administration franchit une nouvelle étape dans sa lutte contre les irrégularités académiques et administratives. Le ministère de l\'Éducation nationale a lancé une vaste opération de vérification des diplômes visant plusieurs agents publics, notamment ceux ayant suivi leur formation à l\'étranger.\n\nDans une note adressée aux services régionaux, les autorités exigent un examen minutieux des dossiers académiques et administratifs. Les diplômes légalisés, arrêtés de recrutement et preuves de service doivent désormais être authentifiés afin d\'éviter les fraudes et les avancements indus.\n\nCette opération s\'inscrit dans le contexte de la lutte contre les faux diplômes et les irrégularités qui fragilisent la crédibilité de la fonction publique. Les services concernés ont jusqu\'au 10 juillet 2026 pour boucler ce processus de vérification.\n\nLa démarche traduit la volonté de l\'État togolais de renforcer la transparence et la probité dans l\'administration. Elle vise à restaurer la confiance des citoyens dans les institutions et à garantir que les postes publics soient occupés par des agents qualifiés et légitimes.',
  NULL,
  '11111111-1111-1111-1111-111111111103',
  NULL,
  '["diplômes","fonction publique","réforme","administration","éducation"]',
  'published', 1,
  'Nouvelledafrique.tg',
  'https://nouvelledafrique.tg/togo-letat-intensifie-la-verification-des-diplomes-dans-la-fonction-publique/',
  '2026-06-19 08:00:00'
);

-- Article 2 : D1 LONATO — sanctions (Le Défenseur)
INSERT IGNORE INTO `articles`
  (`id`, `slug`, `title`, `excerpt`, `content`, `cover_image`, `category_id`, `commune_id`, `tags`, `status`, `featured`, `source_name`, `source_url`, `published_at`)
VALUES (
  'a0000000-0000-0000-0000-000000000002',
  'd1-lonato-lourdes-sanctions-manipulation-presumee-matchs',
  'D1 LONATO : lourdes sanctions pour manipulation présumée de matchs',
  'La Commission de discipline de la Fédération Togolaise de Football a rendu son verdict dans l\'affaire des présumées manipulations de matchs ayant marqué les deux dernières journées de la D1 LONATO 2025-2026.',
  'La Commission de discipline de la Fédération Togolaise de Football (FTF) a rendu son verdict dans l\'affaire des présumées manipulations de matchs ayant marqué les deux dernières journées de la D1 LONATO 2025-2026.\n\nLe président du FC Espoir de Zio, Kokou Toulassi, est suspendu de toute activité liée au football pour six ans et condamné à une amende de 500 000 FCFA. L\'entraîneur de l\'AS Binah, Théophile Bola, écope quant à lui d\'une suspension de cinq ans et six mois, d\'une amende de 500 000 FCFA et devra présenter des excuses publiques à la FTF.\n\nMalgré ces sanctions sévères, les résultats des rencontres des 24 et 31 mai sont maintenus, faute de preuves suffisantes d\'une manipulation effectivement exécutée sur le terrain. Plusieurs dirigeants de clubs, initialement cités dans l\'affaire, ont été blanchis par la commission.\n\nLes parties disposent de dix jours pour faire appel de cette décision. Cette affaire a mis en lumière les défis auxquels fait face le football togolais dans sa lutte pour l\'intégrité des compétitions sportives.',
  'https://ledefenseurinfo.tg/wp-content/uploads/2024/11/FTF-cmm2-1068x739-1.jpg',
  '11111111-1111-1111-1111-111111111105',
  NULL,
  '["football","D1","LONATO","FTF","sanctions","sport"]',
  'published', 1,
  'Le Défenseur',
  'https://ledefenseurinfo.tg/d1-lonato-lourdes-sanctions-pour-manipulation-presumee-de-matchs/',
  '2026-06-19 09:00:00'
);

-- Article 3 : Braquage Adoboukomé (Le Défenseur)
INSERT IGNORE INTO `articles`
  (`id`, `slug`, `title`, `excerpt`, `content`, `cover_image`, `category_id`, `commune_id`, `tags`, `status`, `featured`, `source_name`, `source_url`, `published_at`)
VALUES (
  'a0000000-0000-0000-0000-000000000003',
  'lome-braquage-arme-deux-blesses-graves-adoboukome',
  'Lomé : un braquage armé fait deux blessés graves à Adoboukomé',
  'Un braquage à main armée a provoqué une vive panique jeudi 18 juin à Adoboukomé, près du Grand Marché de Lomé, faisant deux blessés graves.',
  'Un braquage à main armée a provoqué une vive panique jeudi 18 juin à Adoboukomé, dans le quartier du Grand Marché de Lomé.\n\nVers 13 heures, au carrefour Orabank, un homme armé circulant à moto — immatriculée au Ghana selon des témoignages — a attaqué un véhicule transportant un ressortissant libanais et son chauffeur.\n\nAprès avoir ouvert le feu à travers les vitres du véhicule, le malfaiteur s\'est emparé d\'une mallette avant de prendre la fuite, abandonnant sa moto sur les lieux.\n\nLes deux occupants du véhicule, grièvement blessés par balles, ont été rapidement évacués vers un centre de santé pour y recevoir des soins d\'urgence. Les forces de sécurité sont intervenues promptement pour sécuriser la zone et ont ouvert une enquête afin d\'identifier et d\'interpeller l\'auteur de cette attaque.\n\nCet incident soulève une nouvelle fois les préoccupations des habitants et des commerçants du secteur quant à la sécurité dans cette zone à forte densité commerciale.',
  'https://ledefenseurinfo.tg/wp-content/uploads/2026/06/IMG-20260619-WA0320.webp',
  '11111111-1111-1111-1111-111111111101',
  '22222222-2222-2222-2222-222222222201',
  '["braquage","Lomé","sécurité","Adoboukomé","violence"]',
  'published', 0,
  'Le Défenseur',
  'https://ledefenseurinfo.tg/lome-un-braquage-arme-fait-deux-blesses-graves-a-adoboukome/',
  '2026-06-19 10:00:00'
);

-- Article 4 : FII Europe 2026 (Actu-Togo)
INSERT IGNORE INTO `articles`
  (`id`, `slug`, `title`, `excerpt`, `content`, `cover_image`, `category_id`, `commune_id`, `tags`, `status`, `featured`, `source_name`, `source_url`, `published_at`)
VALUES (
  'a0000000-0000-0000-0000-000000000004',
  'fii-europe-2026-faure-gnassingbe-perspectives-fonds-souverain-saoudien',
  'FII Europe 2026 : Faure Gnassingbé ouvre de nouvelles perspectives avec le fonds souverain saoudien',
  'En marge du sommet Future Investment Initiative (FII) Europe 2026 à Rome, le Président du Conseil Faure Gnassingbé a eu une séance de travail avec le gouverneur du fonds souverain saoudien, explorant de nouvelles pistes d\'investissement.',
  'Les échanges autour des investissements stratégiques se poursuivent au sommet Future Investment Initiative (FII) Europe 2026, qui se tient à Rome. En marge de cette rencontre internationale réunissant décideurs économiques, investisseurs et dirigeants du monde entier, le Président du Conseil Faure Essozimna Gnassingbé a eu une séance de travail avec Yasir ben Othman Al-Rumayyan, gouverneur du Fonds Public d\'Investissement (PIF) d\'Arabie Saoudite.\n\nAu cœur de cet entretien bilatéral, les deux parties ont exploré des pistes de coopération et d\'investissement dans des secteurs clés pour le développement du Togo : l\'agriculture et la transformation agricole — notamment la filière coton —, les infrastructures portuaires et logistiques, ainsi que l\'industrie manufacturière.\n\nAvec des actifs estimés à plusieurs centaines de milliards de dollars, le Fonds Public d\'Investissement saoudien est l\'un des plus importants fonds souverains au monde. Il joue un rôle croissant dans le financement de projets de développement en Afrique à travers des partenariats stratégiques ciblés.\n\nCette rencontre s\'inscrit dans la diplomatie économique active menée par le Togo pour mobiliser des capitaux auprès des grands partenaires financiers internationaux.',
  'https://actu-togo.tg/wp-content/uploads/2026/06/IMG_9414.jpeg',
  '11111111-1111-1111-1111-111111111101',
  NULL,
  '["FII","investissement","Arabie Saoudite","Faure Gnassingbé","diplomatie","économie"]',
  'published', 1,
  'Actu-Togo',
  'https://actu-togo.tg/2026/06/19/fii-europe-2026-faure-gnassingbe-ouvre-de-nouvelles-perspectives-avec-le-fonds-souverain-saoudien/',
  '2026-06-19 11:00:00'
);

-- Article 5 : FMI Club diplomatique de Lomé
INSERT IGNORE INTO `articles`
  (`id`, `slug`, `title`, `excerpt`, `content`, `cover_image`, `category_id`, `commune_id`, `tags`, `status`, `featured`, `source_name`, `source_url`, `published_at`)
VALUES (
  'a0000000-0000-0000-0000-000000000005',
  'togo-fmi-echange-diplomatique-club-diplomatique-lome',
  'Togo : le FMI au cœur d\'un échange diplomatique au Club diplomatique de Lomé',
  'Des diplomates et acteurs de la coopération internationale se sont réunis au Club diplomatique de Lomé pour échanger sur l\'évolution du FMI depuis les accords de Bretton Woods jusqu\'au 21e siècle.',
  'Des diplomates, représentants consulaires et acteurs de la coopération internationale se sont réunis au Club diplomatique de Lomé pour un échange centré sur l\'évolution du Fonds Monétaire International (FMI) depuis sa création.\n\nLa représentante résidente du FMI au Togo, Mme Racheeda Boukezia, a animé la rencontre sur le thème « De Bretton Woods au 21e siècle, le FMI et son histoire ». Son intervention a retracé les grandes transformations institutionnelles depuis les accords de Bretton Woods de 1944, qui ont posé les bases du système monétaire international d\'après-guerre.\n\nLes échanges ont porté sur le rôle du FMI dans la stabilité financière mondiale, les réalités économiques africaines, les mécanismes d\'appui aux États membres et les réformes en cours au sein des institutions financières internationales.\n\nLe ministre togolais des Affaires étrangères, Robert Dussey, a exprimé sa gratitude pour la qualité des échanges et la participation des acteurs diplomatiques.',
  'https://actu-togo.tg/wp-content/uploads/2026/06/IMG_9421.jpeg',
  '11111111-1111-1111-1111-111111111101',
  '22222222-2222-2222-2222-222222222201',
  '["FMI","diplomatie","Lomé","économie","coopération","Bretton Woods"]',
  'published', 0,
  'Actu-Togo',
  NULL,
  '2026-06-19 12:00:00'
);

-- Article 6 : Militaires à la retraite (Togo Breaking News)
INSERT IGNORE INTO `articles`
  (`id`, `slug`, `title`, `excerpt`, `content`, `cover_image`, `category_id`, `commune_id`, `tags`, `status`, `featured`, `source_name`, `source_url`, `published_at`)
VALUES (
  'a0000000-0000-0000-0000-000000000006',
  'militaires-retraite-gouvernement-togolais-brisera-silence',
  'Militaires à la retraite : le gouvernement togolais brisera-t-il le silence ?',
  'La diffusion sur les réseaux sociaux d\'une déclaration de militaires à la retraite en uniforme a déclenché une vague d\'indignation. La députée Brigitte Adjamagbo-Johnson saisit l\'Assemblée nationale pour exiger des comptes.',
  'Au Togo, la diffusion sur les réseaux sociaux d\'une déclaration de militaires à la retraite arborant leurs grades a déclenché une vague d\'indignation chez les citoyens et la société civile. La députée Brigitte Adjamagbo-Johnson saisit l\'Assemblée nationale pour exiger des comptes.\n\nPour de nombreux internautes, activistes et acteurs politiques, cette mise en scène franchit une ligne rouge républicaine. Face à la montée de la colère et des inquiétudes en ligne, la députée Brigitte Kafui Adjamagbo-Johnson, figure de proue de la Dynamique pour la Majorité du Peuple (DMP), a décidé de porter le fer sur le terrain institutionnel. Elle a adressé, le 16 juin 2026, une question orale au gouvernement par l\'intermédiaire du président de l\'Assemblée nationale.\n\nSur X (ex-Twitter), Facebook et dans les boucles de messagerie WhatsApp, les réactions de citoyens et de figures de la société civile oscillent entre stupéfaction et colère. Les critiques se cristallisent sur l\'usage des attributs de l\'armée à des fins de communication politique par des civils.\n\nAvant Brigitte Adjamagbo-Johnson, Nathaniel Olympio avait dénoncé le 15 juin dernier les menaces proférées par ces militaires à la retraite qui évoquaient l\'idée de combattre les « ennemis de Faure Gnassingbé jusqu\'au dernier souffle ».',
  'https://togobreakingnews.info/wp-content/uploads/2026/06/Militaires_Retraite.webp',
  '11111111-1111-1111-1111-111111111101',
  NULL,
  '["militaires","retraite","politique","Assemblée nationale","gouvernement","société civile"]',
  'published', 1,
  'Togo Breaking News',
  NULL,
  '2026-06-19 13:00:00'
);

-- ============================================================
-- TABLE : comments
-- ============================================================
CREATE TABLE IF NOT EXISTS `comments` (
  `id`          VARCHAR(36)  NOT NULL,
  `article_id`  VARCHAR(36)  NOT NULL,
  `user_id`     VARCHAR(36)  DEFAULT NULL,
  `author_name` VARCHAR(255) NOT NULL,
  `content`     TEXT         NOT NULL,
  `approved`    TINYINT(1)   NOT NULL DEFAULT 0,
  `created_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `comments_article_idx` (`article_id`),
  CONSTRAINT `fk_comments_article` FOREIGN KEY (`article_id`) REFERENCES `articles`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_user`    FOREIGN KEY (`user_id`)    REFERENCES `users`(`id`)    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$
DROP TRIGGER IF EXISTS `comments_before_insert`$$
CREATE TRIGGER `comments_before_insert`
BEFORE INSERT ON `comments` FOR EACH ROW
BEGIN
  IF NEW.id = '' OR NEW.id IS NULL THEN
    SET NEW.id = UUID();
  END IF;
END$$
DELIMITER ;

-- ============================================================
-- TABLE : newsletter_subscribers
-- ============================================================
CREATE TABLE IF NOT EXISTS `newsletter_subscribers` (
  `id`         VARCHAR(36)  NOT NULL,
  `email`      VARCHAR(254) NOT NULL,
  `first_name` VARCHAR(100),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `newsletter_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$
DROP TRIGGER IF EXISTS `newsletter_before_insert`$$
CREATE TRIGGER `newsletter_before_insert`
BEFORE INSERT ON `newsletter_subscribers` FOR EACH ROW
BEGIN
  IF NEW.id = '' OR NEW.id IS NULL THEN
    SET NEW.id = UUID();
  END IF;
END$$
DELIMITER ;

-- ============================================================
SET FOREIGN_KEY_CHECKS = 1;
-- Fin du fichier — togo_info_hub_mysql.sql
-- ============================================================
