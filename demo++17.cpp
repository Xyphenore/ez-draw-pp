/* demo++17.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 28/10/2008 - version 0.1
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++17.cpp ez-draw++.o ez-image++.o -o demo++17 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++17.cpp ez-draw++.o ez-image++.o -o demo++17 -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/
#include <iostream>
#include <sstream>
#include <iomanip>

using namespace std;

#include "ez-draw++.hpp"

class Ball {
 int x, y;
 int dx, dy;
public:
 Ball()
  : x(0),y(0),dx(0),dy(0)
  {}
 void init(const EZWindow& win,const EZImage& img)
  { 
   x = EZDraw::random(win.getWidth()-img.getWidth());
   y = EZDraw::random(win.getHeight()-img.getHeight());
   dx = 2+EZDraw::random(6);
   dy = 2+EZDraw::random(6);
  }
 void step(const EZWindow& win,const EZImage& img)
  {
    if(dx < 0 && x < -dx) 
     { x = 0; dx = -dx; }
    else if (x > win.getWidth() - img.getWidth() )
     { x = win.getWidth() - img.getWidth(); dx = -dx; }
    else
     x+=dx;

    if(dy < 0 && y < -dy) 
     { y = 0; dy = -dy; }
    else if (y > win.getHeight() - img.getHeight() )
     { y = win.getHeight() - img.getHeight(); dy = -dy; }
    else
     y+=dy;
  }
 void paint(EZWindow& win,const EZImage& img)
  { img.paint(win,x,y); }
 void paint(EZWindow& win,const EZPixmap& pix)
  { pix.paint(win,x,y); }
};

class MyWindow : public EZWindow 
{
 const EZImage image;
 const EZPixmap pixmap;
 static const size_t BALL_MAX = 500;
 static const unsigned int DELAY = 5;
 size_t nbBalls,nbExpose;
 Ball balls[BALL_MAX];
 double time_ref,fps;
 bool usePixmaps;

 void updateFPS()
  {
    double time_now = EZDraw::getTime();
    nbExpose++;
    if (time_now - time_ref < 0.5) return;
    fps = nbExpose / (time_now - time_ref);
    nbExpose = 0;
    time_ref = time_now;
  }

public:

 MyWindow(const char *name,const char* filename)
  : EZWindow(900,700,name),image(filename),pixmap(image),nbBalls(50),nbExpose(0),time_ref(0),fps(-1),usePixmaps(false)
 {
  setDoubleBuffer(true);
  for(size_t i=0;i<nbBalls;++i)
    balls[i].init(*this,image);
  time_ref = EZDraw::getTime();
  startTimer(DELAY);
 }

 void expose()
  {
    updateFPS();

    for(size_t i = 0; i < nbBalls; ++i)
      if(usePixmaps)
             balls[i].paint(*this,pixmap);
        else balls[i].paint(*this,image);

    setColor(EZColor::black);
    ostringstream oss;
    oss << "+-: balls " << setw(3) << nbBalls << " p: pixmap " << (usePixmaps ? "ON ":"OFF");
    drawText (EZAlign::BLF, 10, getHeight()-10,oss.str());
    if (fps > 0)
     {
      ostringstream oss2;
      oss2 << "fps " << fixed << setprecision(1) << fps;
      drawText (EZAlign::BRF, getWidth()-10,getHeight()-10,oss2.str());
     }
  }

 void keyPress(EZKeySym keysym)
  {
    switch (keysym)
     {
        case EZKeySym::plus:
          if(nbBalls<BALL_MAX)
           { balls[nbBalls++].init(*this,image); sendExpose(); }
          break;
        case EZKeySym::minus:
          if(nbBalls>1) { --nbBalls; sendExpose(); }
          break;
        case EZKeySym::p:
          usePixmaps = ! usePixmaps;
          sendExpose();
          break;
        case EZKeySym::Escape:
        case EZKeySym::q  :
          EZDraw::quit();
          break;
        default: // Dans tous les autres cas on ne fait rien (necessaire
          break; // pour eviter un warning a la compilation).
     }
  }

  void timerNotify() // declenchee a chaque fois que le timer est ecoule.
  {
    for(size_t i = 0; i < nbBalls; ++i)
      balls[i].step(*this,image);
    startTimer(DELAY);
    sendExpose();
  }
};


int main (int /*argc*/, char */*argv*/[])
{
 EZDraw ezDraw;

 MyWindow win1("Demo++17 : Pixmaps","images/ball2.gif");

 ezDraw.mainLoop();

 return 0;
}

