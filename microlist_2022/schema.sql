DROP TABLE IF EXISTS Regions;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Coordonees;
DROP TABLE IF EXISTS Annonces;

CREATE TABLE Regions (
idRegion INTEGER PRIMARY KEY AUTOINCREMENT,
nomRegion TEXT
);

CREATE TABLE Categories (
idCategorie INTEGER PRIMARY KEY AUTOINCREMENT,
nomCategorie TEXT
);

CREATE TABLE Coordonees (
utilisateur TEXT PRIMARY KEY,
email TEXT,
mdp TEXT,
telephone TEXT
);

CREATE TABLE Annonces (
idAnnonce INTEGER PRIMARY KEY AUTOINCREMENT,
titre TEXT,
description TEXT,
dateAnnonce TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
ville TEXT,
idRegion INTEGER,
idCategorie INTEGER,
codePostal TEXT,
auteur TEXT,
prix INTEGER,
FOREIGN KEY(idRegion) REFERENCES Regions(idRegion)
FOREIGN KEY(idCategorie) REFERENCES Categories(idCategorie)
FOREIGN KEY(auteur) REFERENCES Coordonees(utilisateur)
);

INSERT INTO `annonces` (`titre`, `description`, `dateAnnonce`, `ville`, `idRegion`, `idCategorie`, `codePostal`, `auteur`, `prix`) VALUES
('coq de compétition', 'donne coq de compétition, peu servi, dans son jus', '2016-02-01', 'Nantes', 1, 1, '44000', 'coq', 0),
('ordinateur transportable', 'ordinateur transportable 23 pouces de marque soni, remis à zéro pour la vente', '2016-02-01', 'Carquefou', 1, 2, '44470', 'bob', 0),
('lit à barreaux', 'lit bébé à barreaux blanc, vendu sans matelas et sans bébé', '2016-02-01', 'Carquefou', 1, 3, '44470', 'bob', 0),
('appartment au bord de la mer', 'appartement T4 en bord de mer pour sénor avertis, trois chambres, 2 caves, 5 places de parking et piste d''attérissage pour hélicoptère', '2016-02-05', 'Pornic', 1, 4, '44210', 'crevette', NULL),
('cartes pokémon collector ultra rares', 'lot de 5 cartes pokémon rares comprenant un pikachou et deux rondoudons', '2016-02-04', 'Aix-en-Provence', 2, 5, '13100', 'arthur', 0),
('Sous vétements petit navire', 'ensemble de culottes blanches de la marque petit navire, produit absolument original, quelques taches sont présentes mais rien de grave', '2016-02-05', 'Aix-en-Provence', 2, 6, '13100', 'arthur', 0),
('Fiat 500 aménagée en Camping Car', 'Fiat 500, carte grise 12 places aménagée camping car avec lit 3 places, auvent et evier/frigo intégré dans la banquette arrière', '2016-02-05', 'Cayenne', 3, 7, '97300', 'landing', 0),
('Cours particulier de Nyotaimori', 'propose cours particulier de Nyotaimori, avec ou sens wasabi', '2016-02-05', 'La roche sur Yon', 1, 8, '85000', 'danone.bala', 0),
('fèves de paque', 'lot de fèves dora l''exploratrice usagées, à finir de nettoyer', '2016-02-06', 'Nantes', 1, 1, '44000', 'coq', 0),
('sapin de noel', 'vend cause no crois plus au pere noel, un sapin en plastique avec son lot de boules et plusieurs guirlandes lumineuses', '2016-02-06', 'Aix-en-Provence', 2, 9, '13100', 'brigitteu', 0),
('cassette vidéo ayant appartenu à Françoi', 'cassette vidéo vierge certifiée etre passée dans les mains de notre feu président, aucune idée du film...', '2016-02-06', 'Saint-Julien-de-Concelles', 1, 10, '44450', 'anon', NULL),
('smartefone samsoung', 'je souhaite vendre, cause triple emploi, un smartefone samsoung absolument neuf et qui a servi 2 ans. Vendu sans batterie, carte sim et écouteurs stéréau. bloqué opérateur lidl mobile', '2016-02-06', 'Aix-en-Provence', 2, 2, '13100', 'arthur', 0),
('vélo à réparer', 'je me sépare de mon fidèle desprier, quelques travaux à prévoir: roues, cadre, frein, selle, pneus, pédalier et chaine sont probablement à changer. Affaire à saisir!', '2016-02-04', 'Piriac-sur-Mer', 1, 7, '44420', 'jack.lang', 0),
('arbre multi-centenaire', 'arbre très vieux, je sais pas ce que c''est mais c''est vieux. A venir chercher sur place, prévoir un pelle', '2016-02-08', 'Saint-Nazaire', 1, 12, '44600', 'jacque.haricot', 0),
('exercices corrigés de base de données', 'je met à disposition, contre un petit repas chaleureux agrémenté de boissons agréables, l''ensemble des sujets corrigés du cours de base de données en Licence 1 de l''université de Nantes', '2016-02-08', 'Chéméré', 1, 8, '44040', 'memepaspeur', 0),
('T-shirt britney spears', 'Cause déménagement, je cède à contre coeur, snif, mon t-shirt collector Britney Spears, baby one more time special tour. Objet rare sur le marché, faire offre en accord avec sa valeur sentimentale', '2016-02-08', 'Paimbœuf', 1, 6, '44116', 'britney', 0),
('4x4 de luxe', 'Suite à un controle fiscal, je vend mon 4x4 de luxe toutes options : accoudoirs chauffants, jantes en bois de chène, aileron sport en titane-carbone, etc.', '2016-02-08', 'La Turballe', 1, 7, '211', 'jean.rapetou', 0),
('maison bourgeoise', 'Madame et moi-meme souhaiterions nous séparer de notre pied à terre nantais. Il s''agit d''une maison bourgeoise avec 12 chambres, 6 salles de bain et 1 canapé blanc en cuir de vachette', '2016-02-08', 'Nantes', 1, 4, '44000', 'bour.geois', 0),
('kazou numérique', 'vends un kazou numérique fender à double frete', '2016-02-09', 'Piriac-sur-Mer', 1, 11, '44420', 'jack.lang', 0),
('ordinateur de landing', 'vend cause double emploi, ordinateur de landing de compétition avec clavier, écran,cables et webcam.Très peu servi, sauf projet python', '2016-02-05', 'Cayenne', 3, 2, '97300', 'landing', 0),
('eeeee', 'zz', '2016-04-24', 'eeeee', 1, 1, '78854', 'coq', 44);

--
-- Contenu de la table `categories`
--

INSERT INTO `categories` (`nomCategorie`) VALUES
('Animaux'),
('Informatique'),
('Ameublement'),
('Immobilier'),
('Jeux & Jouets'),
('Vétements'),
('Véhicules'),
('Services'),
('Décoration'),
('Image & son'),
('Instruments de Musique'),
('Autre');

--
-- Contenu de la table `coordonees`
--

INSERT INTO `coordonees` (`utilisateur`, `email`, `mdp`, `telephone`) VALUES
('coq', 'coq@gmoul.com', 'pass', NULL),
('bob', 'bob@bobo.org', 'word', '601010101'),
('crevette', 'crevette@pornic.com', 'lolxd', '826262626'),
('arthur', 'arthur@lol.gro', 'mdrilegro', NULL),
('landing', 'landing@cci.fr', 'flute', '645464748'),
('danone', 'danone.bala@voi.ne', '1234', '633940594'),
('brigitteu', 'brigitteu@edu.gouv', '5678', NULL),
('anon', 'anon@ce.pr', 'password', NULL),
('jacklang', 'jack.lang@pouf.pif', 'passwerd', NULL),
('jaqueharicotmagique', 'jacque.haricot@magique.conte', 'tropfacileapirater', NULL),
('memepaspeur', 'memepaspeur@etu.univ-nantes.fr', 'hackme', NULL),
('britneylove', 'britney@love.actually', 'lemotdepasse', NULL),
('jeanrapetou', 'jean.rapetou@magouille.fr', 'u', NULL),
('bourgeois', 'bour.geois@riche.dollar', 'jesuisrichedoncjaipasbesoindemotdepasse', '9999999999');

--
-- Contenu de la table `regions`
--

INSERT INTO `regions` (`nomRegion`) VALUES
('Pays de la Loire'),
('Provence-Alpes-Côte d''Azur'),
('Guyanne');