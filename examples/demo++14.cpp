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

/* demo++14.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 28/10/2008 - version 0.1
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++14.cpp ez-draw++.o ez-image++.o -o demo++14 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++14.cpp ez-draw++.o ez-image++.o -o demo++14.exe -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#include <iostream>
#include <sstream>

using namespace std;

#include <ez-draw-pp/ez-draw++.hpp>

#include <config.hpp>

class MyWindow : public EZWindow {
    EZImage fond, sprite;
    int sprite_x, sprite_y;

public:
    MyWindow(const char *name, const char *fond_filename, const char *sprite_filename)
        : EZWindow(640, 480, name), fond(fond_filename), sprite(sprite_filename) {
        setWidthHeight(fond.getWidth(), fond.getHeight());
        sprite_x = (getWidth() - sprite.getWidth()) / 2;// On centre le sprite au milieu de la fenêtre
        sprite_y = (getHeight() - sprite.getHeight()) / 2;
        setDoubleBuffer(true);// On active le double buffer pour limiter le syntillement de l'image
    }

    void expose() {
        fond.paint(*this, 0, 0);
        sprite.paint(*this, sprite_x, sprite_y);
    }

    void keyPress(EZKeySym keysym) {
        switch (keysym) {
            case EZKeySym::Up:
                sprite_y -= 10;
                sendExpose();
                break;
            case EZKeySym::Down:
                sprite_y += 10;
                sendExpose();
                break;
            case EZKeySym::Left:
                sprite_x -= 10;
                sendExpose();
                break;
            case EZKeySym::Right:
                sprite_x += 10;
                sendExpose();
                break;
            case EZKeySym::Escape:
            case EZKeySym::q:
                EZDraw::quit();
                break;
            default:  // Dans tous les autres cas on ne fait rien (necessaire
                break;// pour eviter un warning a la compilation).
        }
    }
};


int main(int /*argc*/, char * /*argv*/[]) {
    EZDraw ezDraw;

    MyWindow win1(
        "Demo++14 : affichage de deux images avec utilisation de l'alpha-channel",
        (examples::RESSOURCES_DIR + "/images/paper1.jpg").c_str(),
        (examples::RESSOURCES_DIR + "/images/tux2.gif").c_str());

    ezDraw.mainLoop();

    return 0;
}
