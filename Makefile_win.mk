# Makefile pour EZ-Draw++ : version pour Windows
#
# 04/05/2020 - Eric.Remy@univ-amu.fr

# Variables pour Windows, toutes versions
ifeq ($(CXX),)
CXX=g++
endif
CFLAGS   = -g -Wall -pedantic -O2
CXXFLAGS = $(CFLAGS) -std=c++14
#LDFLAGS = -static # Activer ceci pour que les programmes puissent être transférés d'un ordinateur à un autre.
LIBS     = -lgdi32 -lmsimg32
RM       = del

.PHONY: all clean distclean

# Rajoutez vos executables C++ a la fin de EXECSPP =
#
EXECSPP = \
  demo++01.exe demo++02.exe demo++03.exe demo++04.exe demo++05.exe \
  demo++06.exe demo++07.exe demo++08.exe              demo++10.exe \
  demo++11.exe demo++12.exe demo++13.exe demo++14.exe demo++15.exe \
  demo++17.exe \
  tracer.exe

all :: $(EXECSPP)

.cpp.o :
	$(CXX) $(CXXFLAGS) -c $*.cpp


# Cette double dependance un peu speciale est une syntaxe spécifique à GNU-make ;
# elle est équivalente à :
#     demo++01 : demo++01.o ez-draw++.o
#     demo++02 : demo++02.o ez-draw++.o
#     etc.
$(EXECSPP) : %.exe : %.o ez-draw++.o
	$(CXX) $(LDFLAGS) -o $@ $^ $(LIBS)

ez-draw++.o :: ez-draw++.hpp ez-draw++.cpp


clean ::
	$(RM) *.o core

distclean :: clean
	$(RM) *~ *.swp $(EXECSPP)

