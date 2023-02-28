# Makefile pour EZ-Draw++ : version pour Linux
#
# 04/05/2020 - Eric.Remy@univ-amu.fr

# Variables pour Linux, toutes versions
ifeq ($(CXX),)
CXX=g++
endif
CFLAGS   = -g -Wall -pedantic -O2
CXXFLAGS = $(CFLAGS) -std=c++11
LDFLAGS  =
LIBS     = -L/usr/X11R6/lib -lX11 -lXext
RM       = rm -rf

.PHONY: all clean distclean

# Rajoutez vos executables C++ a la fin de EXECSPP =
#
EXECSPP = \
  demo++01 demo++02 demo++03 demo++04 demo++05 \
  demo++06 demo++07 demo++08          demo++10 \
  demo++11 demo++12 demo++13 demo++14 demo++15 \
  demo++17 \
  tracer

all :: $(EXECSPP)

.cpp.o :
	$(CXX) $(CXXFLAGS) -c $*.cpp


# Cette double dependance un peu speciale est une syntaxe spécifique à GNU-make ;
# elle est équivalente à :
#     demo++01 : demo++01.o ez-draw++.o
#     demo++02 : demo++02.o ez-draw++.o
#     etc.
$(EXECSPP) : % : %.o ez-draw++.o
	$(CXX) $(LDFLAGS) -o $@ $^ $(LIBS)

ez-draw++.o :: ez-draw++.hpp ez-draw++.cpp


clean ::
	$(RM) *.o core

distclean :: clean
	$(RM) *~ *.swp $(EXECSPP)

