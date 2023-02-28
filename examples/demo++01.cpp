/* demo++01.cpp : demonstration de EZ-Draw++
 *
 * eric.remy@univ-provence.fr - 28/10/2008 - version 0.1
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++01.cpp ez-draw++.o -o demo++01 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++01.cpp ez-draw++.o -o demo++01.exe -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#include "ez-draw++.hpp"

int main ()
{
 // La base de tout : la creation d'une instance de la classe EZDraw.

 EZDraw ezDraw;

 // Simple creation de fenetre de taille 400 pixels de large par 300 pixels de haut,
 // avec pour titre "Demo++ 0 : Hello World".
 EZWindow win(400, 300, "Demo++01 : Hello World");

 // L'appel a la fonction membre mainLoop() de la classe EZDraw permet d'assurer la
 // gestion des evenements. En l'occurence, il est indispensable pour que la fenetre
 // puisse aparaitre (et donc etre dessinee) et se fermer.
 ezDraw.mainLoop();

 // Lorsque la fenetre est fermee, la boucle de gestion de vie des fenetres se termine,
 // et on arrive ici... pour finir le programme.
 return 0;
}

