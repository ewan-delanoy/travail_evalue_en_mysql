/*

Avant de lancer les requêtes ci-dessous, il faut d'abord importer
le fichier episodes_precedents.sql


*/


/*
Question 1. Afficher le nombre de commande totales supérieur à 50e que l’on a dans le catalogue et la moyenne des prix des commandes

Réponse à la question 1 : 

Pour le nombre de commande totales supérieur à 50e que l’on a dans le catalogue : 
*/

SELECT COUNT(c.id) AS nbCommandes
FROM commande AS c
INNER JOIN product AS p
ON c.product_id = p.id
WHERE p.price > 50;


/*
Pour la moyenne du prix des commandes : 
*/

SELECT SUM(p.price)/COUNT(c.id) AS moyennePrix
FROM commande AS c
INNER JOIN product AS p
ON c.product_id = p.id;


/*
Question 2. Insérer 3 nouvelles promotion pour les produits de chez Apple ou tagué “Siri’ (en SQL)

On commence par créer les nouvelles promotions : 
*/


INSERT INTO `promotion` (`id`, `rate`, `title`, `enabled`) VALUES
(12, 20, 'Promotion hiver Apple ou Siri', 1),
(13, 30, 'Promotion printemps Apple ou Siri', 1),
(14, 20, 'Promotion été Apple ou Siri', 1);

/*
Ensuite, on les affecte aux produits concernés dans la table étrangère :
*/

INSERT INTO `product_promotion` (`product_id`,`promotion_id`) 
SELECT pd.id, pm.id 
FROM product AS pd
INNER JOIN product_tag 
ON product_tag.product_id=pd.id
INNER JOIN tag 
ON product_tag.tag_id = tag.id
INNER JOIN promotion AS pm 
WHERE 
((pd.title REGEXP 'Apple') OR
(pd.description REGEXP 'Apple') OR
(tag.name = 'Siri'))
AND (pm.id IN (12, 13, 14));


/*
Question 3. Gérer les marques pour les produits (1 produit a 1 seul marque) avec title et
localisation(ville)
*/

/* Créer une nouvelle table pour les marques */

CREATE TABLE `brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(60) NOT NULL,
  `city` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* Ajouter un clé étrangère pour la relation 1-to-many entre product et brand */

ALTER TABLE product ADD `brand_id` int ; 
ALTER TABLE product ADD FOREIGN KEY (`brand_id`) REFERENCES `brand`(`id`) ;


INSERT INTO `brand` (`id`, `title`, `city`) VALUES
(1, 'Voisin', 'Lyon'),
(2, 'L\'Oréal', 'Clichy'),
(3, 'YSL', 'Paris'),
(4, 'Alory', 'Lyon');

/* Mettre les marques sur quelques produits */

UPDATE `product` SET `brand_id` = 1 WHERE `id` IN (10, 11);
UPDATE `product` SET `brand_id` = 4 WHERE `id` = 12;


/*
Afficher le nombre de marques par produits qui sont de Lyon
*/

SELECT b.title AS marque, COUNT(p.id) AS nbProduits
FROM product AS p
INNER JOIN brand AS b
ON p.brand_id = b.id 
WHERE b.city='Lyon'
GROUP BY b.id;


/*
Question 4. Gérer les avis des utilisateurs sur les produits.
*/

/* Créer une nouvelle table pour les avis */

CREATE TABLE `feedback` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `grade` int NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`product_id`) REFERENCES `product`(`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* Insérer quelques avis */

INSERT INTO `feedback` (`id`, `product_id`, `user_id`, `content`, `grade`) VALUES 
(NULL, '1', '2', 'Assez bien', '14'), (NULL, '3', '4', 'Pas trop mal', '13'), 
(NULL, '5', '6', 'Répond à mes attentes.', '15'), 
(NULL, '7', '8', 'C\'est une arnaque', '0');

/*
Question 5. Supprimer tous les avis à 0 ou dont le contenu est inférieur à 3 mots
*/

DELETE FROM feedback 
WHERE (grade=0) OR (LENGTH(content) - LENGTH(REPLACE(content, ' ', ''))<2);

/*
Question 6. Gérer les cartes de fidélité pour les utilisateurs (1 à 1).
*/

/*Créer la table des cartes de fidélité */

CREATE TABLE `fidelitycard` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created` datetime NOT NULL,
  `nbAchatsRealises` int NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* Créer quelques cartes de fidélité */

INSERT INTO `fidelitycard` (`id`, `user_id`, `created`, `nbAchatsRealises`) VALUES 
(NULL, '5', '2023-05-25 00:00:00', '10'), (NULL, '1', '2022-05-25 00:00:00', '9'), 
(NULL, '3', '2020-05-25 00:00:00', '8'), (NULL, '2', '2020-05-25 00:00:00', '7');


/*
Question 7. Afficher le nom des cartes de fidélité sur les 3 dernières commandes des utilisateurs
*/

SELECT c.created, u.first_name, u.last_name
FROM user AS u
INNER JOIN fidelitycard AS f
ON f.user_id = u.id
INNER JOIN commande AS c
ON c.user_id = u.id
ORDER BY c.created
LIMIT 3;


/*
Gérer les fournisseurs pour les produits. Attention 1 produit peut avoir plusieurs fournisseurs
à la fois.
*/

/*C'est une relation many to many, donc on utilise une table étrangère*/

CREATE TABLE `supplier` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `product_supplier` (
  `product_id` int NOT NULL,
  `supplier_id` int NOT NULL,
  `since` datetime,
  FOREIGN KEY (product_id) REFERENCES product(id),
  FOREIGN KEY (supplier_id) REFERENCES supplier(id),
  UNIQUE(product_id,supplier_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* Définir quelques fournisseurs */

INSERT INTO `supplier` (`id`, `name`, `phone`) VALUES
(NULL, 'LéondeLyon', '0482000000'), 
(NULL, 'ArthurleParisien', '0100000000'), 
(NULL, 'MarceldeClermont', '0473000000');

/* Associer quelques fournisseurs et produits */

INSERT INTO `product_supplier` (`product_id`, `supplier_id`,`since`) VALUES
(1, 1,'2022-05-25 00:00:00'), (2, 2,'2019-05-25 00:00:00'), (3, 3,'2018-05-25 00:00:00'), 
(4, 1,'2022-05-25 00:00:00'), (4, 2,'2019-05-25 00:00:00'), (5, 1,'2017-05-25 00:00:00'), 
(5, 3,'2022-05-25 00:00:00'), (6, 2,'2022-05-25 00:00:00'), (6, 3,'2022-05-25 00:00:00'), 
(7, 1,'2022-05-25 00:00:00'), (7, 2,'2018-05-25 00:00:00'), (7, 3,'2022-05-25 00:00:00');

/*
Afficher les fournisseurs qui fournissent le plus de produits depuis 2 ans ou plus.
*/

SELECT s.name AS fournisseur, COUNT(p.id) AS nbDeProduits
FROM supplier AS s
INNER JOIN product_supplier AS ps
ON ps.supplier_id=s.id
INNER JOIN product AS p
ON ps.product_id=p.id 
WHERE ps.since <= DATE_SUB(NOW(),INTERVAL 2 YEAR)
GROUP BY s.id
ORDER BY nbDeProduits DESC;



/*
Gérer les administrateurs. Les administrateurs sont des super utilisateurs et on affichera les
2 derniers administrateurs créer. Parmis ces admins, il y aura 1 seul super-admin.
*/

ALTER TABLE user ADD isAdmin boolean;

/*
Convention : L'unique super-admin est celui qui a un user.id égal à 1 (plus simple que de créer un champ isSuperAdmin).
*/

/*
Nommer quelques admininstrateurs 
*/

UPDATE `user` SET `isAdmin` = 1 WHERE `id` IN (1, 2, 3, 5, 6);

/*

Afficher les 2 derniers administrateurs créés

*/

SELECT u.created, u.first_name, u.last_name 
FROM user AS u
WHERE isAdmin = 1
ORDER BY u.created DESC
LIMIT 2;


/*
Gérer les adresses de facturation et livraison pour les utilisateurs avec les champs:
- pays
- Région
- CP
- adresse
- ville,
- longitude
- latitude
*/

CREATE TABLE `address` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `region` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `postal_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `longitude` float NOT NULL,
  `latitude` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
 
ALTER TABLE user ADD delivery_address_id int;
ALTER TABLE user ADD FOREIGN KEY (`delivery_address_id`) REFERENCES `address`(`id`) ;

ALTER TABLE user ADD billing_address_id int;
ALTER TABLE user ADD FOREIGN KEY (`billing_address_id`) REFERENCES `address`(`id`) ;






ALTER TABLE user ADD facturation_address_id int;
