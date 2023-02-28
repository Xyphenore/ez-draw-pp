/* demo++12.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 29/03/2008 - version 0.8
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++12.cpp ez-draw++.o -o demo++12 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++12.cpp ez-draw++.o -o demo++12.exe -lgdi32
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

class MyWindow1 : public EZWindow
{
 double  value;
 EZImage image;
 double  time;

 double computeHSVImage ()
  {
    unsigned int xc = image.getWidth()/2 , yc = image.getHeight()/2;
    double rc = xc-1 , rc2 = rc*rc;
    double t1 = EZDraw::getTime();

    for (int y = 0; y < image.getHeight(); y++)
    for (int x = 0; x < image.getWidth() ; x++)
    {
        int dx = x-xc , dy = y-yc;
        double dc2 = dx*dx + dy*dy;
        EZColor color;
        double H,S;

        if (dc2 <= rc2) {
            double dc = sqrt (dc2);
            S = dc/rc;

            /* acos() returns angle between 0 and +M_PI */
            H = (S == 0) ? 0 :
                (dy <= 0) ? acos (dx / dc) * 180 / M_PI :
                          - acos (dx / dc) * 180 / M_PI + 360;

            image.getPixel(x,y).setColor(EZColor(H, S, value));
        }
        else
          image.getPixel(x,y).setColor(EZColor::white);
    }
    return EZDraw::getTime()-t1;
 }

public:
 MyWindow1(int w,int h,const char *name)
  : EZWindow(w+20,h+40,name),value(1),image(w,h),time(0)
 {
  setDoubleBuffer(true);
  time = computeHSVImage();
 }

 void expose()
  {
    image.paint (*this,10, 20);
    setColor (EZColor::black);
    ostringstream oss1,oss2;
    oss1 << "V = " << setprecision(2) << value;
    drawText (EZAlign::TLF,   10,   10, oss1.str());
    oss2 << setprecision(3) << time*1000 << " ms";
    drawText (EZAlign::TRF, getWidth()-10,   10, oss2.str());
    drawText (EZAlign::BL ,   10, getHeight()-10, "Press Space ...");
  }

 void keyPress(EZKeySym keysym)
  {
    switch (keysym)
     {
        case EZKeySym::Escape:
        case EZKeySym::q  :
          EZDraw::quit();
          break;
        case EZKeySym::space :
          value -= 0.05;
          if (value < 0) value = 1;
          time = computeHSVImage();
          sendExpose();
          break;
        default: // Dans tous les autres cas on ne fait rien (necessaire
          break; // pour eviter un warning a la compilation).
     }
  }

 void close()
  { EZDraw::quit(); }
};


int main (int /*argc*/, char */*argv*/[])
{
    EZDraw ezDraw;
    MyWindow1 win1(400, 400, "Demo++12 : Palette HSV");

    ezDraw.mainLoop();

    return 0;
}
