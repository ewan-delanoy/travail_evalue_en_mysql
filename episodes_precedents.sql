CREATE TABLE IF NOT EXISTS `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` float DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime NOT NULL,
  `enabled` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `commande` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `tva` int NOT NULL,
  `created` datetime NOT NULL,
  `quantity` int NOT NULL,
  `status` enum('0','1','2') COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_id` int NOT NULL,
  `paiement_id` int NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `promotion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rate` float NOT NULL,
  `title` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `product_promotion` (
  `product_id` int NOT NULL,
  `promotion_id` int NOT NULL,
  FOREIGN KEY (`product_id`) REFERENCES `product`(`id`),
  FOREIGN KEY (`promotion_id`) REFERENCES `promotion`(`id`),
  UNIQUE (`product_id`,`promotion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tag` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `product_tag` (
  `product_id` int NOT NULL,
  `tag_id` int NOT NULL,
  FOREIGN KEY (`product_id`) REFERENCES `product`(`id`),
  FOREIGN KEY (`tag_id`) REFERENCES `tag`(`id`),
  UNIQUE (`product_id`,`tag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `age` int NOT NULL,
  `email` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `product` (`id`, `title`, `description`, `price`, `createdAt`, `updatedAt`, `enabled`) VALUES
(1, 'Amazon Kindle', 'Tablette Amazon Kindle', 220, '2022-05-15 10:22:23', '2023-05-15 10:14:59', 1),
(2, 'Thermomètre Braun', 'Thermomètre précis', 39.55, '2022-05-19 10:16:34', '2023-05-19 10:16:34', 1),
(3, 'Chaussures Panama Jack', 'Chaussures très solides', 60.2, '2022-05-15 10:23:23', '2023-05-15 10:23:23', 1),
(4, 'Full metal Jacket', 'DVD de film', 30, '2022-05-15 10:23:23', '2023-05-15 10:22:23', 1),
(5, 'PC Huawei', 'PC reconditionné Human Booster', 600, '2022-05-15 10:23:23', '2023-05-15 10:19:23', 1),
(6, 'Mac Book Air', 'Mac Book Air (Produit Apple)', 3000, '2022-05-15 10:23:23', '2023-05-15 10:18:23', 1),
(7, 'Mac Book Pro', 'Mac Book Pro (Produit Apple)', 3000, '2022-05-15 10:23:23', '2023-05-15 10:18:23', 1),
(8, 'Chaussures Méphisto Montagne', 'Chaussures de randonnée', 60.2, '2022-05-15 10:23:23', '2023-05-15 10:23:23', 1),
(9, 'Siri', 'Logiciel vocal pour Mac', 5, '2023-05-26 11:47:34', '2023-05-26 11:47:34', 1),
(10, 'Guatemala Grand Cru 78%', 'Chocolat boisé aux notes de fruits jaunes', 20, '2023-05-26 00:00:00', '2023-05-26 00:00:00', 1),
(11, 'Café BIO 1KG Grain Salvador Andalucia', 'Cultivé en forêt à 1400 mètres d\'altitude dans une ferme de la région d\'Ahuachapan.\r\n\r\nNotes de pain d\'épices et de miel.\r\n\r\nCafé artisanal fraîchement torréfié\r\n\r\n100% Arabica', 28, '2023-05-26 00:00:00', '2023-05-26 00:00:00', 1),
(12, 'Veste Alicia', 'Veste upcyclée en velours et tissu imprimé floral', 28, '2023-05-26 00:00:00', '2023-05-26 00:00:00', 1);;

INSERT INTO `commande` (`id`, `user_id`, `tva`, `created`, `quantity`, `status`, `product_id`, `paiement_id`, `enabled`) VALUES
(6, 3, 0, '2023-03-22 08:04:52', 4, '0', 1, 0, 0),
(5, 8, 0, '2023-04-22 08:04:52', 5, '0', 2, 0, 0),
(4, 2, 0, '2022-05-22 08:03:58', 3, '0', 4, 0, 0),
(7, 9, 0, '2023-04-22 08:04:52', 1, '0', 3, 0, 0),
(8, 1, 0, '2023-03-22 08:04:52', 6, '0', 5, 0, 0),
(9, 2, 0, '2022-05-22 08:03:58', 3, '0', 2, 0, 0),
(10, 8, 0, '2023-04-22 08:04:52', 5, '0', 1, 0, 0),
(11, 3, 0, '2023-03-22 08:04:52', 4, '0', 3, 0, 0),
(12, 9, 0, '2023-04-22 08:04:52', 1, '0', 5, 0, 0),
(13, 4, 0, '2023-05-26 13:28:55', 2, '0', 5, 1, 1),
(14, 5, 0, '2023-05-25 13:28:55', 3, '0', 5, 1, 1);

INSERT INTO `tag` (`id`, `name`) VALUES
(1, 'Geographie'),
(2, 'Sql'),
(3, 'Histoire'),
(4, 'Feux de forêt'),
(5, 'Sport'),
(6, 'High-tech'),
(7, 'Siri');


INSERT INTO `product_tag` (`tag_id`, `product_id`) VALUES
(6, 1), (6, 3), (6, 4), (6, 5), (6, 6), (6, 7), (6, 9),
(5, 8),
(7, 9);

INSERT INTO `user` (`id`, `first_name`, `last_name`, `password`, `age`, `email`,  `created`, `updated`) VALUES
(1, 'Arthur', 'Conan Doyle', 'Elyod#Nanocruhtra1', 34, 'arthur.conandoyle@gmail.com', '2023-05-26 16:51:45', '2023-05-26 16:51:45'),
(2, 'Suzanne', 'Vega', 'Agev#Ennazus2', 34, 'suzanne.vega@gmail.com', '2021-05-26 16:51:45', '2023-05-26 16:51:45'),
(3, 'Ophelie', 'Bau', 'Uab#Eilehpo3', 25, 'ophelie.bau@gmail.com', '2022-05-26 16:51:45', '2023-05-26 16:51:45'),
(4, 'Gaelle', 'Bona', 'anobelleag', 24, 'gaelle.bona@gmail.com', '2020-05-26 16:51:45', '2023-05-26 16:51:45'),
(5, 'Jordan', 'Peterson', 'nadrojnosretep', 24, 'jordan.peterson@gmail.com', '2017-05-26 16:51:45', '2023-05-26 16:51:45'),
(6, 'John', 'Doe', 'weodvnhoj', 24, 'john.doe@gmail.com', '2023-05-26 16:51:45', '2018-05-26 16:51:45'),
(7, 'Killian', 'Smith', 'htimsnaillik', 24, 'killian.smith@gmail.com', '2019-05-26 16:51:45', '2023-05-26 16:51:45'),
(8, 'Adnane', 'Belladona', 'ecorcottedeneb', 61, 'benedetto.belladona@gmail.com', '2016-05-26 16:51:45', '2023-05-26 16:51:45'),
(9, 'Abraham', 'Maslow', 'wolsamaharba', 62, 'abraham.maslow@gmail.com', '2015-05-26 16:51:45', '2023-05-26 16:51:45');



