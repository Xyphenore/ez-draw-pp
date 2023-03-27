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

/* demo++08.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 28/10/2008 - version 0.1
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++08.cpp ez-draw++.o -o demo++08 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++08.cpp ez-draw++.o -o demo++08 -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#include <iostream>
#include <sstream>

using namespace std;

#include <ez-draw-pp/ez-draw++.hpp>

class MyWindow1 : public EZWindow {
    string tampon = "";

public:
    MyWindow1(int w, int h, const char *name)
        : EZWindow(w, h, name) {}

    void expose() {
        setColor(EZColor::black);
        drawText(EZAlign::TL, 10, 10, "Texte : " + tampon + "_");
    }

    int saisie_texte(EZKeySym key_sym, string & /*s*/) {
        switch (key_sym) {

            case EZKeySym::BackSpace: /* Touche backspace */
                if (tampon.length() == 0) break;
                tampon.resize(tampon.length() - 1);
                sendExpose();
                break;

            case EZKeySym::Return:
                return 1; /* Renvoie 1 si touche Entree */

            default: /* Insertion d'un caractere */
                if (currentEvent().keyCount() != 1) break;
                tampon.push_back(currentEvent().keyString()[0]);
                sendExpose();
                break;
        }
        return 0;
    }

    // Une touche du clavier a ete enfoncee :
    void keyPress(EZKeySym keysym) {
        if (saisie_texte(keysym, tampon) == 1) {
            setColor(EZColor::red);
            ostringstream oss;
            oss << "Vous avez valide le texte :\n"
                << tampon;
            drawText(EZAlign::TC, 200, 70, oss.str());
        }
    }

    void close() { EZDraw::quit(); }
};


int main(int /*argc*/, char * /*argv*/[]) {
    EZDraw ezDraw;

    MyWindow1 win1(400, 200, "Demo++08 : saisie de texte");

    ezDraw.mainLoop();

    return 0;
}
