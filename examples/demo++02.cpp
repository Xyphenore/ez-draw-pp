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

/* demo++02.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 28/10/2008 - version 0.1
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++02.cpp ez-draw++.o -o demo++02 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++02.cpp ez-draw++.o -o demo++02.exe -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#include <ez-draw-pp/ez-draw++.hpp>

class MyWindow : public EZWindow {
public:
    MyWindow(int w, int h, const char *name)
        : EZWindow(w, h, name)// On transmet les arguments au constructeur de EZWindow
    {}

    void expose()                      // Fonction membre declenchee lorsque le contenu de la fenetre
    {                                  // doit etre retrace.
        setColor(EZColor::red);        // Rend la couleur rouge active pour les prochains traces
        drawText(EZAlign::MC, 200, 150,// Dessine le texte avec son centre en (200,150).
                 "Pour quitter, tapez sur la touche 'q' ou 'Esc', ou\n"
                 "cliquez sur l'icone fermeture de la fenetre");
    }

    // Si l'utilisateur appuie sur une touche
    void keyPress(EZKeySym keysym) {
        switch (keysym) {
            case EZKeySym::Escape:// Si la touche est Echap
            case EZKeySym::q:     // ou la touche Q minuscule
                EZDraw::quit();   // alors on termine le programme.
                break;
            default:  // Dans tous les autres cas on ne fait rien (necessaire
                break;// pour eviter un warning a la compilation).
        }
    }
};

int main() {
    EZDraw ezDraw;

    // Cette fois on cree une MyWindow qui herite de EZWindow !
    MyWindow win1(400, 300, "Demo++02 : fenetre et evenements");

    ezDraw.mainLoop();

    return 0;
}
