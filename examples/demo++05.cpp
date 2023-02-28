/* demo++05.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 28/10/2008 - version 0.1
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++05.cpp ez-draw++.o -o demo++05 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++05.cpp ez-draw++.o -o demo++05.exe -lgdi32
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
public:
 MyWindow(int w,int h,const char *name)
  : EZWindow(w,h,name)
 {}

 // Fenetre devenue visible ; contenu a redessiner :
 void expose()
  {
    setColor(EZColor::red);
    drawText(EZAlign::MC, 200, 150,"L'affichage des evenements\nest fait dans la console");
    cout << "Expose           win = "<< this << endl;
  }

 // Bouton de la souris enfonce :
 void buttonPress(int mouse_x,int mouse_y,int button)
  {
    cout << "ButtonPress      win = " << this << " mouse_x = " << mouse_x << " mouse_y = " << mouse_y << " button = " << button << endl ;
  }

 // Bouton relache :
 void buttonRelease(int mouse_x,int mouse_y,int button)
  {
    cout << "ButtonRelease    win = " << this << " mouse_x = " << mouse_x << " mouse_y = " << mouse_y << " button = " << button << endl ;
  }

 // Deplacement de la souris :
 void motionNotify(int mouse_x,int mouse_y,int button)
  {
    cout << "MotionNotify     win = " << this << " mouse_x = " << mouse_x << " mouse_y = " << mouse_y << " button = " << button << endl ;
  }

 // Touche enfoncee :
 void keyPress(EZKeySym keysym)
  {
    cout << "KeyPress         win = " << this
         << " key_sym = " << keysym
         // Les informations suivantes sont accessible de manière indirecte
         << " mouse_x = " << currentEvent().mouseX() << " mouse_y = " << currentEvent().mouseY() 
         << " key_name = " << currentEvent().keyName()
         << " key_string = \"" << currentEvent().keyString() <<"\""
         << endl;
  }

 // Touche relachee :
 void keyRelease(EZKeySym keysym)
  {
    cout << "KeyRelease       win = " << this
         << " key_sym = " << keysym
         // Les informations suivantes sont accessible de manière indirecte
         << " mouse_x = " << currentEvent().mouseX() << " mouse_y = " << currentEvent().mouseY() 
         << " key_name = " << currentEvent().keyName()
         << " key_string = \"" << currentEvent().keyString() <<"\""
         << endl;
    if(keysym == EZKeySym::q || keysym == EZKeySym::Escape)
      EZDraw::quit();
  }

 // Changement des dimensions de la fenetre :
 void configureNotify(int width,int height)
  { cout << "ConfigureNotify  win = " << this << " width = " << width << " height = " << height << endl; }

 // La fermeture de la fenetre est empechee par le simple fait de definir la fonction membre suivante :
 void close()
  { cout << "WindowClose      win = " << this << endl; }
};


int main (int /*argc*/, char */*argv*/[])
{
 EZDraw ezDraw;

 MyWindow win1(400, 300, "Demo++05 : trace les evenements");

 // Empeche la fermeture automatique afin de donner la
 // possibilité de traiter l'évènement WindowClose.
 ezDraw.setAutoQuit(false);

 ezDraw.mainLoop();

 return 0;
}

