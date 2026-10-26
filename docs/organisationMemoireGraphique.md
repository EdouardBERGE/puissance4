# Organisation de la mémoire graphique

Le générateur d'adresse de l'Amstrad parcourt plusieurs compteurs définissant l'écran.

De gauche à droite, l'adresse vidéo courante augmente de 2 en 2 jusqu'à atteindre sa définition de largeur.

De haut en bas, l'adresse vidéo parcourt 1 à 1 les lignes du bloc courant. Chaque changement de ligne de bloc s'effectue en ajoutant #800 à l'adresse de début de ligne. Par exemple si l'écran commence en #C000, alors les lignes suivantes auront comme adresse de départ #C800, #D000, #D800, #E000, #E800, #F000, #F800.

Lorsqu'on passe de la dernière ligne de bloc à la première ligne du bloc suivant, on soustrait tous les ajouts de bloc (#3800) et on ajoute la longueur en octet d'une ligne.

L'adresse de n'importe quelle ligne se calcule alors avec la formule suivante :
``formule
addresseDebutLigne = debutPage + (ligne>>3)*largeurEcran + (ligne&7)*#800
```

## optimisation

Il est d'usage de précalculer toutes les adresses de ligne dans un tableau et de lire l'adresse à la ligne du tableau

