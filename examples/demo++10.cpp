/* demo++10.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 29/03/2008 - version 0.8
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++10.cpp ez-draw++.o -o demo++10 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++10.cpp ez-draw++.o -o demo++10 -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#include <iostream>
#include <sstream>
#include <iomanip>

#define _USE_MATH_DEFINES // Enable M_PI constant from the next inclusion
#include <cmath>

// Au cas où l
#ifndef M_PI
#define M_PI (3.14159265359)
#endif

using namespace std;

#include "ez-draw++.hpp"

// Fenetre 1 : une horloge avec ses aiguilles qui tournent.

class WinHorloge : public EZWindow {
 static const unsigned int delay = 30; // delai de 30 ms entre deux reaffichages.
 unsigned int cpt;
 bool etat;
public:
  WinHorloge(const char *name="")
   : EZWindow(250,250,name), // On transmet les parametres au contructeur de EZWindow,
     cpt(0), // on initialise cpt a zero,
     etat(true) // et au debut l'horloge tourne.
  {
    setDoubleBuffer(true);
    startTimer(delay);
  }

private:
  void dessin_aiguille (EZColor color, double angle, int xc, int yc, int d1, int d2, int ra)
  {
    double a = (angle-90) * M_PI / 180., c = cos (a), s = sin (a),
           x1 = xc + c*d1, y1 = yc + s*d1, x2 = xc + c*d2, y2 = yc + s*d2,
           x3 = x1 - s*ra, y3 = y1 + c*ra, x4 = x1 + s*ra, y4 = y1 - c*ra,
           x5 = x2 - s*ra, y5 = y2 + c*ra, x6 = x2 + s*ra, y6 = y2 - c*ra;

    setColor(color);
    drawLine(int(x3), int(y3), int(x5), int(y5)); drawLine (int(x5), int(y5), int(x6), int(y6));
    drawLine(int(x6), int(y6), int(x4), int(y4)); drawLine (int(x4), int(y4), int(x3), int(y3));
  }

  void expose()
  {
    double h = cpt / 60.0, m = cpt % 60;

    setColor(EZColor::magenta);
    setFont(2);
    ostringstream oss;
    oss << setfill('0') << setw(2) << int(h) // heure sans la partie apres la virgule, sur une largeur de deux lettres completee au besoin avec des '0'.
        << ':'
        << setfill('0') << setw(2) << int(m);
    drawText(EZAlign::TC, getWidth()/2, 6, oss.str());

    dessin_aiguille (EZColor::red,  h*30, getWidth()/2, getHeight()/2, 20, 70, 10);
    dessin_aiguille (EZColor::blue, m* 6, getWidth()/2, getHeight()/2, 15, 92, 6);

    setColor(EZColor::black);
    setFont(0);
    drawText(EZAlign::BL, 8, getHeight()-8, "espace : pause   q : quitter");
  }

  void timerNotify() // declenchee a chaque fois que le timer est ecoule.
  {
    cpt = (cpt + 1) % 720; // On modifie cpt.
    sendExpose(); // On force un reaffichage.
    startTimer(delay);  // On rearme le timer
  }

  void keyPress(EZKeySym keysym)
  {
    switch (keysym) {
       case EZKeySym::q : EZDraw::quit(); break;
       case EZKeySym::space : 
         if (etat) { etat = false; stopTimer(); }
         else      { etat = true;  startTimer(delay); } 
         break;
        default: // Dans tous les autres cas on ne fait rien (necessaire
          break; // pour eviter un warning a la compilation).
    }
  }
};


// Fenetre 2 : une balle rebondit sur une raquette

class WinRebond : public EZWindow {
 unsigned int delay;
 int ba_x,ba_y,ba_dx,ba_dy;
public:
  WinRebond(const char *name="")
   : EZWindow(280,180,name), // On transmet les parametres au contructeur de EZWindow,
     delay(20),
     ba_x(100),ba_y(100),ba_dx(4),ba_dy(3)
  {
    setDoubleBuffer(true); // On demande un affiche avec double tampon pour eviter les scintillements.
    startTimer(delay); // On demarre le timer.
  }

private:
  void avancer_balle(int x1, int y1, int x2, int y2)
   {
    ba_x += ba_dx; ba_y += ba_dy;
    if (ba_x <= x1) { ba_x = x1; ba_dx = -ba_dx; }
    else if (ba_x >= x2) { ba_x = x2; ba_dx = -ba_dx; } 
    if (ba_y <= y1) { ba_y = y1; ba_dy = -ba_dy; }
    else if (ba_y >= y2) { ba_y = y2; ba_dy = -ba_dy; } 
   }

  void expose() // Il faut tout redessiner
   {
    setColor(EZColor::black);
    drawCircle(ba_x-10, ba_y-10, ba_x+10, ba_y+10);
    setColor(EZColor::blue);
    fillRectangle(ba_x-25, getHeight()-8, ba_x+25, getHeight()-3);
   }

  void timerNotify() // declenchee a chaque fois que le timer est ecoule.
   {
    avancer_balle (10, 10, getWidth()-10, getHeight()-19);
    sendExpose(); // On force le reaffichage.
    startTimer(delay); // On rearme le timer.
   }
};



int main (int /*argc*/, char */*argv*/[])
{
    EZDraw ezDraw;
    WinHorloge win1("Demo++10 : horloge");
    WinRebond  win2("Demo++10 : rebonds");

    ezDraw.mainLoop();

    return 0;
}


