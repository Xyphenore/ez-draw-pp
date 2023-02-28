/* demo++5.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 28/10/2008 - version 0.1
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++5.cpp ez-draw++.o -o demo++5 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++5.cpp ez-draw++.o -o demo++5 -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#include <iostream>
#include <sstream>

using namespace std;

#include "ez-draw++.hpp"

class MyWindow : public EZWindow 
{
 int ax, ay, ab;
public:
 MyWindow(int w,int h,const char *name)
  : EZWindow(w,h,name),ax(0),ay(0),ab(0)
 {}

 void expose()
  {
    setColor(EZColor::black);
    drawText(EZAlign::TL, 10, 10,
        "Cliquez et bougez la souris dans la fenetre pour dessiner.\n"
        "Tapez sur espace pour vider la fenetre, 'q' pour quitter.");
  }

 // Un bouton de la souris a ete enfonce ou relache :
 void buttonPress(int mouse_x,int mouse_y,int button)
  {
    ab = button;
    setColor(EZColor::grey);
    drawPoint(mouse_x,mouse_y);
    ax = mouse_x; ay = mouse_y;
    setColor(EZColor::green);
    ostringstream oss;
    oss << "Clic " << mouse_x << "," << mouse_y;
    drawText(EZAlign::BCF, mouse_x, mouse_y, oss.str());
  }

 // Deplacement de la souris :
 void motionNotify(int mouse_x,int mouse_y,int /*button*/)
  {
    if (ab == 0) return;
    setColor(EZColor::grey);
    drawLine(mouse_x, mouse_y, ax, ay);
    ax = mouse_x; ay = mouse_y;
  }

 void buttonRelease(int /*mouse_x*/,int /*mouse_y*/,int /*button*/)
  {
    ab = 0;
  }

 // Une touche du clavier a ete enfoncee ou relachee :
 void keyPress(EZKeySym keysym)
  {
    switch (keysym)
     {
        case EZKeySym::q : EZDraw::quit (); break;
        case EZKeySym::space : sendExpose(); break;
        default: // Dans tous les autres cas on ne fait rien (necessaire
          break; // pour eviter un warning a la compilation).
     }
  }
};

// Une classe dérivée de EZDraw pour attacher notre fenêtre.
class MyApp : public EZDraw {
  MyWindow win1;
 public:
  MyApp()
  : win1(400, 300, "Demo++06 : dessin a la souris")
  {}
};

int main (int /*argc*/, char */*argv*/[])
{
 MyApp myapp;

 myapp.mainLoop();

 return 0;
}

