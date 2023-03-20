/*
 * ez-draw++
 * Copyright (C) 2008-2023 Edouard THIEL, Eric REMY
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/*
 * ez-draw++
 * Copyright (C) 2008-2023 Edouard THIEL, Eric REMY
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/* demo++13.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 28/10/2008 - version 0.1
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++13.cpp ez-draw++.o ez-image++.o -o demo++13 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++13.cpp ez-draw++.o ez-image++.o -o demo++13.exe -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#include <sstream>

using namespace std;

#include "ez-draw++.hpp"

class MyWindow : public EZWindow {
    EZImage image;
public:
    MyWindow(const char *name, const char *filename)
            : EZWindow(1, 1, name), image(filename) {
        setWidthHeight(image.getWidth(), image.getHeight());
        setDoubleBuffer(true); // On active le double buffer pour limiter le syntillement de l'image
    }

    void expose() {
        image.paint(*this, 0, 0);
    }

    void keyPress(EZKeySym keysym) {
        switch (keysym) {
            case EZKeySym::plus:
                setWidth(getWidth() + 10);
                break;
            case EZKeySym::minus:
                setWidth(getWidth() - 10);
                break;
            case EZKeySym::asterisk:
                setHeight(getHeight() + 10);
                break;
            case EZKeySym::slash:
                setHeight(getHeight() - 10);
                break;
            case EZKeySym::Escape:
            case EZKeySym::q  :
                EZDraw::quit();
                break;
            default: // Dans tous les autres cas on ne fait rien (necessaire
                break; // pour eviter un warning a la compilation).
        }
    }
};


int main(int /*argc*/, char */*argv*/[]) {
    EZDraw ezDraw;

    MyWindow win1("Demo++13 : affichage d'une image", "images/tux2.gif");

    ezDraw.mainLoop();

    return 0;
}

