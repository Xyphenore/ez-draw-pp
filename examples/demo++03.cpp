/* demo++03.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 28/10/2008 - version 0.1
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++03.cpp ez-draw++.o -o demo++03 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++03.cpp ez-draw++.o -o demo++03.exe -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#include "ez-draw++.hpp"

class MyWindow : public EZWindow 
{
public:
 MyWindow(int w,int h,const char *name)
  : EZWindow(w,h,name)
 {}

 void expose()
  {
    setColor      (EZColor::magenta);
    drawText      (EZAlign::BL, 10, 20, "draw epaisseur 1 :");
    setThick      (1);
    drawPoint     (  30,  50);
    drawLine      (  60,  35, 130,  70);
    drawRectangle ( 160,  30, 220,  70);
    drawCircle    ( 240,  30, 300,  70);
    drawTriangle  ( 320,  30, 380,  40, 350,  70);

    setColor      (EZColor::black);
    drawText      (EZAlign::BL, 10, 100, "draw epaisseur 2 :");
    setColor      (EZColor::cyan);
    setThick      (2);
    drawPoint     (  30, 130);
    drawLine      (  60, 115, 130, 150);
    drawRectangle ( 160, 110, 220, 150);
    drawCircle    ( 240, 110, 300, 150);
    drawTriangle  ( 320, 110, 380, 120, 350, 150);

    setColor      (EZColor::blue);
    drawText      (EZAlign::BL, 10, 180, "draw epaisseur 9 :");
    setColor      (EZColor::green);
    setThick      (9);
    drawPoint     (  30, 210);
    drawLine      (  60, 195, 130, 230);
    drawRectangle ( 160, 190, 220, 230);
    drawCircle    ( 240, 190, 300, 230);
    drawTriangle  ( 320, 190, 380, 200, 350, 230);

    setColor      (EZColor::red);
    drawText      (EZAlign::BL, 10, 260, "fill :");
    setColor      (EZColor::yellow);
    fillRectangle ( 160, 270, 220, 310);
    fillCircle    ( 240, 270, 300, 310);
    fillTriangle  ( 320, 270, 380, 280, 350, 310);
  }

 void keyPress(EZKeySym keysym)
  {
    switch (keysym)
     {
        case EZKeySym::Escape:
        case EZKeySym::q  :
          EZDraw::quit();
          break;
        default: // Dans tous les autres cas on ne fait rien (necessaire
          break; // pour eviter un warning a la compilation).
     }
  }
};

int main (int /*argc*/, char */*argv*/[])
{
 EZDraw ezDraw;

 MyWindow win1(400, 320, "Demo++03 : tous les dessins");

 ezDraw.mainLoop();

 return 0;
}
