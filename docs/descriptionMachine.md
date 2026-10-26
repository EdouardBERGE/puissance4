# description technique de la machine

## capacités graphiques

palette de 4096 couleurs RGB

- mode 0 : pixels rectangulaires (ratio 2:1), 16 couleurs, 2 pixels par octet
- mode 1 : pixels carrés, 4 couleurs, 4 pixels par octet
- mode 2 : pixels fins (ratio 0.5:1), 2 couleurs, 8 pixels par octet

Un écran dont les dimensions sont programmées présentera toujours la même taille physique quel que soit le mode choisi. C'est la raison des différents ratio en fonction du nombre de couleurs affichable.

Les données graphiques se situent toujours dans la même page de 16K. Considère que l'adressage ne peut jamais déborder de sa page de 16K. Les pages possibles sont situées uniquement dans les premiers 64K de la machine, aux adresses 0, 16384, 32768 et 49152.

### sprites hard

La machine possède 16 sprites hard dont le contenu est accessible via une page mémoire spéciale.

Les sprites possèdent une palette qui leur est propre, de 15 couleurs parmi 4096.

Chaque sprite possède une résolution de 16x16 pixels. La couleur d'index zéro est une transparence.

Il est possible de définir individuellement pour chaque sprite un pixel ratio :
- mode 0, mode 1 ou mode 2
- mais aussi ces même ratios étirés en hauteur, deux fois ou quatre fois

## résolutions graphiques

Le contrôleur graphique de l'Amstrad CPC est très flexible et propose une infinité de résolutions graphiques. Voici une liste des résolutions les plus pertinentes (c'est à dire occupant 16K de mémoire ou moins):

### 160x200 en mode 0 ou 320x200 en mode 1 ou 640x200 en mode 2 ou écran par défaut

Ceci sont les résolutions par défaut de la machine lorsqu'on démarre avec le Basic.

### 128x256 en mode 0 ou 256x256 en mode 1 ou 512x256 en mode 2 ou écran carré

La largeur de 64 octets est très utilisée pour les jeux vidéos car on peut optimiser le calcul d'adresse horizontal en ne modifiant que le poids faible de l'adresse.

## processeur

Z80 cadencé à 4MHz

note : La machine resynchronise régulièrement le processeur pour donner priorité à la lecture des données graphiques. La durée des instructions se compte uniquement en NOP.

## audio

Demander à l'utilisateur d'ajourner ce fichier si tu as besoin d'informations à ce sujet 

## disquette

Demander à l'utilisateur d'ajourner ce fichier si tu as besoin d'informations à ce sujet 

## support de masse

Demander à l'utilisateur d'ajourner ce fichier si tu as besoin d'informations à ce sujet 

