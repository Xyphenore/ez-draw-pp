/******************************************************************************
 * ez-draw++                                                                  *
 * Copyright (C) 2008-2023 Edouard THIEL, Eric REMY                           *
 *                                                                            *
 * This library is free software; you can redistribute it and/or              *
 * modify it under the terms of the GNU Lesser General Public                 *
 * License as published by the Free Software Foundation; either               *
 * version 2.1 of the License, or (at your option) any later version.         *
 *                                                                            *
 * This library is distributed in the hope that it will be useful,            *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU          *
 * Lesser General Public License for more details.                            *
 *                                                                            *
 * You should have received a copy of the GNU Lesser General Public           *
 * License along with this library; if not, write to the Free Software        *
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA  *
 ******************************************************************************/

/* demo++11.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 29/03/2008 - version 0.8
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++11.cpp ez-draw++.o -o demo++11 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++11.cpp ez-draw++.o -o demo++11.exe -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#include <iomanip>
#include <iostream>
#include <sstream>

#define _USE_MATH_DEFINES// Enable M_PI constant from the next inclusion

#include <cmath>

using namespace std;

#include <ez-draw-pp/ez-draw++.hpp>

class MyWindow1 : public EZWindow {
public:
    MyWindow1(int w, int h, const char *name)
        : EZWindow(w, h, name) { setDoubleBuffer(true); }

    void expose() {
        const char *color_names[9] = {"EZColor::black", "EZColor::white", "EZColor::grey", "EZColor::red",
                                      "EZColor::green", "EZColor::blue", "EZColor::yellow", "EZColor::cyan",
                                      "EZColor::magenta"};
        EZColor c[9];
        int x, y;

        c[0] = EZColor::black;
        c[1] = EZColor::white;
        c[2] = EZColor::grey;
        c[3] = EZColor::red;
        c[4] = EZColor::green;
        c[5] = EZColor::blue;
        c[6] = EZColor::yellow;
        c[7] = EZColor::cyan;
        c[8] = EZColor::magenta;

        for (int i = 0; i < 9; i++) {
            x = 20 + (i % 3) * 100;
            y = 20 + (i / 3) * 60;
            setColor(EZColor::black);
            drawText(EZAlign::TL, x, y, color_names[i]);
            drawRectangle(x, y + 20, x + 60, y + 40);
            setColor(c[i]);
            fillRectangle(x + 1, y + 21, x + 59, y + 39);
        }

        setColor(EZColor::black);
        drawText(EZAlign::TL, 20, 200, "Grey levels: 0..255");
        drawRectangle(20, 220, 277, 240);
        for (int i = 0; i < 256; i++) {
            setColor(EZColor(i));
            drawLine(21 + i, 221, 21 + i, 239);
        }

        setColor(EZColor::black);
        drawText(EZAlign::TL, 20, 260, "HSV color: H = 0..360, S = V = 1");
        drawRectangle(20, 280, 380, 300);
        for (double i = 0; i < 360; i++) {
            setColor(EZColor(i, 1., 1.));
            drawLine(21 + i, 281, 21 + i, 299);
        }

        EZuint8 r = EZDraw::random(256), g = EZDraw::random(256), b = EZDraw::random(256);
        setColor(EZColor::black);
        ostringstream oss;
        oss << "Random RGB\n"
            << setw(3) << int(r) << " "
            << setw(3) << int(g) << " "
            << setw(3) << int(b);

        drawText(EZAlign::TLF, 320, 160, oss.str());
        drawRectangle(320, 200, 380, 240);
        setColor(EZColor(r, g, b));
        fillRectangle(321, 201, 379, 239);
    }

    void keyPress(EZKeySym keysym) {
        switch (keysym) {
            case EZKeySym::Escape:
            case EZKeySym::q:
                EZDraw::quit();
                break;
            default:  // Dans tous les autres cas on ne fait rien (necessaire
                break;// pour eviter un warning a la compilation).
        }
    }

    void close() { EZDraw::quit(); }
};


int main(int /*argc*/, char * /*argv*/[]) {
    EZDraw ezDraw;
    MyWindow1 win1(410, 320, "Demo++11 : Couleurs");

    ezDraw.mainLoop();

    return 0;
}
