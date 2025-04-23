Rapport de Projet : Jeu d'Aventure Textuel en Swift

📜 Description du Projet

Le Jeu d'Aventure Textuel est un jeu interactif développé en Swift qui se joue entièrement en ligne de commande. Le jeu plonge le joueur dans une série de salles mystérieuses, où il devra explorer, résoudre des énigmes, et interagir avec des objets pour progresser. Ce projet combine des éléments de jeu de rôle et de résolution d'énigmes, tout en offrant un système de sauvegarde et une interface utilisateur colorée grâce à l'utilisation des codes de couleur ANSI.
Objectifs :

    Créer une expérience immersive dans un monde textuel en 2D, avec des énigmes qui requièrent des objets spécifiques pour avancer.

    Gérer les éléments du jeu tels que l'inventaire, les objets interactifs, et les énigmes à résoudre.

    Permettre la sauvegarde et la reprise de la progression du joueur entre les sessions.

    Optimiser l'expérience utilisateur avec une interface simple mais colorée en ligne de commande.

🎮 Mécaniques de Jeu
🗺️ Système de Carte

Le jeu propose une carte composée de 8 salles interconnectées. Chaque salle est décrite de manière dynamique, changeant en fonction des actions du joueur et des énigmes résolues. Voici les principales caractéristiques du système de carte :

    8 Salles interconnectées : Chaque salle est reliée à d'autres par des passages. Certaines connexions sont débloquées lorsque le joueur résout des énigmes.

    Mini-map visuelle : Une carte rapide est affichée lors des actions du joueur, indiquant sa position actuelle et les salles accessibles.

    Passages secrets : Certaines zones sont initialement inaccessibles, mais peuvent être débloquées une fois les énigmes résolues (par exemple, vider l'eau dans la Salle 6 avec un seau).

🧩 Énigmes Principales

Les énigmes du jeu sont une composante essentielle de l'aventure. Elles nécessitent des objets spécifiques pour être résolues et permettre au joueur de progresser. Voici un résumé des énigmes principales :

    Éboulement (Salle 2) : Le passage est bloqué par un éboulement, que le joueur doit traverser en utilisant une torche. La torche est indispensable pour éclairer la route et déverrouiller le passage.

    Inondation (Salle 6) : La salle est inondée. Le joueur doit utiliser un seau pour vider l'eau et ouvrir un passage à l'est.

    Coffre verrouillé (Salle 7) : Un coffre contient un levier qui permet de débloquer un passage vers le nord. Pour l'ouvrir, le joueur doit trouver la clé du laboratoire (clé clelab).

📦 Système d'Objets

L'inventaire du joueur est un élément clé pour résoudre les énigmes. Le système d'objets fonctionne comme suit :

    3 objets clés : Torche, seau, et clé du laboratoire. Ces objets sont essentiels pour progresser dans le jeu.

    Inventaire persistant : L'inventaire du joueur est sauvegardé et peut être consulté à tout moment. Le joueur peut collecter des objets à travers le jeu et les utiliser au moment opportun.

    Interaction avec les objets : Le joueur peut interagir avec les objets de l'inventaire en utilisant des commandes comme prendre <id> pour ajouter un objet à l'inventaire et utiliser <id> pour résoudre des énigmes ou débloquer des passages.

🕹️ Comment Jouer

Le jeu se joue dans le terminal (ligne de commande) et propose une interface simple avec des commandes textuelles pour naviguer, interagir avec les objets, et résoudre les énigmes. Voici un aperçu des principales commandes que le joueur peut utiliser :
Commandes de Déplacement :

    nord, sud, est, ouest : Se déplacer dans la carte du jeu en fonction des connexions disponibles. Certaines directions peuvent être bloquées par des énigmes ou des obstacles.

Commandes d'Interaction :

    prendre <id> : Ramasser un objet spécifique dans la salle actuelle. Exemple : prendre torche.

    utiliser <id> : Utiliser un objet de l'inventaire pour interagir avec l'environnement ou résoudre une énigme. Exemple : utiliser seau.

Commandes de Gestion :

    inventaire : Affiche la liste des objets actuellement dans l'inventaire du joueur.

    carte : Affiche la carte rapide de l'environnement, indiquant la position du joueur.

    aide, ? : Affiche un message d'aide avec toutes les commandes disponibles.

    quitter : Sauvegarde la partie en cours et quitte le jeu.

🔧 Architecture Technique
1. Modèle de Données :

    Salle : Chaque salle a un identifiant, un nom, une description, une liste d'objets présents, et des connexions vers d'autres salles.

    Objet : Chaque objet a un identifiant, un nom, et une description. Les objets peuvent être utilisés dans certaines situations pour résoudre des énigmes.

    Puzzle : Un puzzle est un défi à résoudre, et il peut être lié à une salle et à un objet spécifique. Une fois résolu, il modifie les connexions de la salle ou débloque de nouvelles options.

    Joueur : Le joueur a un inventaire, une position dans le monde, un score et des énigmes résolues.

2. Gestion de Sauvegarde :

Le jeu permet de sauvegarder la progression à tout moment. Lorsqu'un joueur quitte, l'état du jeu est enregistré dans un fichier JSON. Lors du lancement suivant, le joueur peut charger la sauvegarde et reprendre là où il s'est arrêté.
3. Interface Utilisateur :

L'interface utilise les codes ANSI pour ajouter de la couleur aux textes dans le terminal, rendant l'expérience visuelle plus agréable et immersive.
4. Système de Puzzles Dynamiques :

Les énigmes modifient le monde du jeu en fonction de leur résolution. Par exemple, la salle 6 est inondée jusqu'à ce que le joueur vide l'eau avec le seau, ce qui débloque un passage vers la salle suivante.
📈 Évolutions et Perspectives

Le jeu est conçu pour être évolutif et pourrait être amélioré de plusieurs façons :

    Ajout de nouvelles salles et énigmes pour enrichir l'expérience de jeu.

    Système de score pour encourager le joueur à résoudre les énigmes de manière plus rapide ou avec moins d'indices.

    Interface graphique : Bien que le jeu soit actuellement en ligne de commande, une interface graphique simple pourrait être ajoutée pour améliorer l'accessibilité.

    Multijoueur : Ajouter une dimension multijoueur où plusieurs joueurs peuvent interagir dans le même monde.