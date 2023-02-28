/* demo++07.cpp : demonstration de EZ-Draw
 *
 * eric.remy@univ-provence.fr - 05/04/2010 - version 0.9
 *
 * Compilation sous Unix :
 *     g++ -Wall demo++07.cpp ez-draw++.o -o demo++07 -L/usr/X11R6/lib -lX11 -lXext
 * Compilation sous Windows :
 *     g++ -Wall demo++07.cpp ez-draw++.o -o demo++07.exe -lgdi32
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#include <iostream>
#include <sstream>

using namespace std;

#include "ez-draw++.hpp"

// Les declarations de classes :

//= déclaration par avance de l'existance de la clase MyApplication. ==========
class MyApplication; // Nécessaire pour la donnée myApp de MyMainWindow.

//= classe MyMainWindow =======================================================
class MyMainWindow : public EZWindow
{
 MyApplication *myApp;
public:
 MyMainWindow(MyApplication* _myApp,int w,int h,const char *name);
 ~MyMainWindow();
 void expose();
 void keyPress(EZKeySym keysym);
 void close();
};

//= classe MyWindow2 ==========================================================
class MyWindow2 : public EZWindow
{
 MyApplication *myApp;
public:
      MyWindow2(MyApplication* _myApp,int w,int h,const char *name);
      ~MyWindow2();
 void expose();
 void motionNotify(int mouse_x,int mouse_y,int button);
 void close();
};

//= classe MyWindow3 ==========================================================
class MyWindow3 : public EZWindow
{
 MyApplication *myApp;
public:
 MyWindow3(MyApplication* _myApp,int w,int h,const char *name);
 void expose();
 void close();
 ~MyWindow3(); // Destructeur de la fenetre 3. Il est défini plus bas lorsque cela devient possible.
};

//= classe MyApplication ===========================================================
class MyApplication : public EZDraw {
public: // Pour des raisons pratiques, on met exceptionnellement ces donnees membres en public.
 MyMainWindow myMainWindow; // La fenetre principale.
 MyWindow2    myWindow2;    // La fenetre qui peut etre cachee et montree.
 MyWindow3    *myWindow3;   // Un pointeur vers la troisieme fenetre de l'application.

 MyApplication();  // Declaration du constructeur de l'application, et de ses fenetres.
 ~MyApplication(); // Declaration du desctructeur de l'application.
};

//= Les definitions de fonctions membres de MyApplication =====================
 MyApplication::MyApplication()  // Definition du constructeur de l'application, et de ses fenetres
 : myMainWindow(this,400, 300, "Demo++07 : plusieurs fenetres"), // grace a la liste d'initialisations.
   myWindow2(this,400, 200, "Fenetre 2"),
   myWindow3(nullptr) // On initialise a nullptr le pointeur de la troisieme fenetre car pour l'instant elle n'est pas creee.
 { setAutoQuit(false); } // Pour gerer soi-meme la fermeture des fenetres.

 MyApplication::~MyApplication() // Definition du desctructeur de l'application.
  { delete myWindow3; myWindow3=nullptr; } // On detruit chaque fenetre.

//= Les definitions de fonctions membre de MyMainWindow =======================
 MyMainWindow::MyMainWindow(MyApplication *_myApp,int w,int h,const char *name)
  : EZWindow(w,h,name),myApp(_myApp)
 { cerr << "Construction de MyMainWindow" << endl; }

 MyMainWindow::~MyMainWindow()
 { cerr << "Destruction de MyMainWindow" << endl; }

 void MyMainWindow::expose()
  {
    setColor(EZColor::black);
    drawText(EZAlign::TL, 10, 10,
                "Cliquez dans cette fenetre (pour donner le focus clavier),\n"
                "puis tapez :\n"
                "    - sur 'm' pour montrer ou cacher la fenetre 2 ;\n"
                "    - sur 'c' pour creer ou detruire la fenetre 3 ;\n"
                "    - sur 'q' pour quitter.\n"
                "\n"
                "Si vous fermez cette fenetre, le programme se terminera.");
  }

 void MyMainWindow::keyPress(EZKeySym keysym) // Une touche du clavier a ete enfoncee ou relachee
  {
    switch (keysym)
     {
        case EZKeySym::m :
	    myApp->myWindow2.setVisible( ! myApp->myWindow2.isVisible() );
	    break;
        case EZKeySym::Escape:
        case EZKeySym::q :
            myApp->quit ();
            break;
        case EZKeySym::c :
            if (myApp->myWindow3 == nullptr)
              myApp->myWindow3 = new MyWindow3(myApp,300, 250, "Fenetre 3");
            else
              { delete myApp->myWindow3; }
            break;
        default: // Dans tous les autres cas on ne fait rien (necessaire
          break; // pour eviter un warning a la compilation).
     }
  }

 void MyMainWindow::close() { myApp->quit(); }


 //= Les definitions des fonctions membres de MyWindow3 =======================
 MyWindow3::MyWindow3(MyApplication* _myApp,int w,int h,const char *name)
   : EZWindow(w,h,name),myApp(_myApp)
  { cerr << "Construction de MyWindow3" << endl; }

 MyWindow3::~MyWindow3() // Definition du destructeur de MyWindow3
  {
   myApp->myWindow3 = nullptr; // Astuce : l'instance marque elle-même dans MyApplication qu'elle n'existe plus.
   cerr << "Destruction de MyWindow3" << endl;
  }

 void MyWindow3::expose()
  {
    setColor(EZColor::black);
    drawText(EZAlign::TR, getWidth()-11, 10,
        "Changez la taille de cette fenetre,\nle dessin s'adapte");
    setColor(EZColor::red);
    drawLine (0, 0, getWidth()-1, getHeight()-1);
  }

 void MyWindow3::close()
  { delete this; } // Provoque la destruction C++ de cette fenetre.


 //= Les definitions des fonctions membres de MyWindow2 =======================
  MyWindow2::MyWindow2(MyApplication* _myApp,int w,int h,const char *name)
   : EZWindow(w,h,name),myApp(_myApp)
  { cerr << "Construction de MyWindow2" << endl; }

  MyWindow2::~MyWindow2()
  { cerr << "Destruction de MyWindow2" << endl; }

 void MyWindow2::expose()
  { drawText(EZAlign::TL, 10, 10, "Si vous fermez cette fenetre, elle sera simplement cachee. Elle conserve donc sa taille puisqu'elle n'est ni detruite ni recreee quand on la ferme et qu'on la reouvre."); }

 void MyWindow2::motionNotify(int mouse_x,int mouse_y,int /*button*/)
  {
    setColor(EZColor::black);
    ostringstream oss;
    oss << mouse_x << "," << mouse_y;
    drawText(EZAlign::BLF, 10, getHeight()-5,oss.str());
  }

 void MyWindow2::close()
  { setVisible( ! isVisible() ); }

//= Main ======================================================================
int main (int /*argc*/, char */*argv*/[])
{
 MyApplication myApplication; // On cree une instance de notre classe derivee de EZDraw.

 myApplication.mainLoop(); // Le main() est reduit a sa plus simple expression !
 return 0;
}
