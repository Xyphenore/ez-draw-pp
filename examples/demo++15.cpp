/* demo++15.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 28/10/2008 - version 0.1
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++15.cpp ez-draw++.o ez-image++.o -o demo++15 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++15.cpp ez-draw++.o ez-image++.o -o demo++15.exe -lgdi32
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
 EZImage sprite, *sprite2;
 int alpha;
 double time1, factor;
public:
 MyWindow(const char *name,const char* fond_filename)
  : EZWindow(640,480,name),sprite(fond_filename),sprite2(nullptr),alpha(1),time1(-1),factor(1)
 {
  setWidthHeight(sprite.getWidth()*2,sprite.getHeight()*2+24);
  sprite2 = new EZImage(sprite);
  sprite2->setAlpha(alpha);
 }

 void expose()
  {
    setColor(EZColor(220,255,200));
    fillRectangle( 0, 0, getWidth()-1, getHeight()-20);
    sprite2->paint(*this, 0, 0);
    setColor(EZColor::black);
    ostringstream oss1,oss2;
    oss1 << "+-: factor " << factor << " a: alpha " << (alpha ? "ON ":"OFF");
    drawText ( EZAlign::BLF, 4, getHeight()-4,oss1.str());
    oss2 << time1*1000 << " ms";
    if(time1 > 0)
        drawText (EZAlign::TRF, getWidth()-4, 4, oss2.str());
  }

 void keyPress(EZKeySym keysym)
  {
    switch (keysym)
     {
        case EZKeySym::plus:   factor+=0.02;   sendExpose(); break;
        case EZKeySym::minus:  factor-=0.02;   sendExpose(); break;
        case EZKeySym::a:      alpha = !alpha; sendExpose(); break;
        case EZKeySym::Escape:
        case EZKeySym::q  :
          EZDraw::quit();
          break;
        default: // Dans tous les autres cas on ne fait rien (necessaire
          break; // pour eviter un warning a la compilation).
     }
    delete sprite2;
    time1 = EZDraw::getTime();
    sprite2 = sprite.scale(factor);
    sprite2->setAlpha(alpha);
    time1 = EZDraw::getTime() - time1;
  }
};


int main (int /*argc*/, char */*argv*/[])
{
 EZDraw ezDraw;

 MyWindow win1("Demo++15 : mise a l'echelle d'images","images/tux2.gif");

 ezDraw.mainLoop();

 return 0;
}

