# Changelog of ez-draw++

## Unreleased

### Changed

- Add tests directory with doctest 2.4.11.
- Change the versioning to respect 'Semantic Versioning'.
- Add a configuration to generate the doxygen documentation.

#### BREAKING Changes

- Split sources files into directories 'include', 'src' and 'examples'.
- Update requirements to C++20.
- Use CMake 3.16.2 to build.
- Drop Makefile support.
- Update requirements to Doxygen 1.9.6.

## [1.2.6] - 2022-04

### Changed

- The class 'EZColor' encapsulates 'ez-color', to permit the overload of operators '<<' and '>>'.
  This makes portable the reading and writing of Web color (Hex color).

#### BREAKING Changes

- Throw the exception 'EZDrawError', which encapsulates errors from the library 'EZ-Draw' and from
  'ez-draw++'.

### Fixed

- Fixed the detection of transparency in a gray+alpha image.
- Minor fixes in the documentation.

## [1.2.5] - 2021-09

### Fixed

#### BREAKING Changes

- Fixed types for returned width and height of windows.

## [1.2.4] - 2020-04

### New features

- Possibility to change the background color.

## [1.2.3] - 2017-03

### Changed features

- Decoupling the C layer of the library.
- Hide the C layer behind the C++ layer.
- Rewrite the tutorial with Doxygen.

## [1.2.2] - 2017-03

### New features

- Added EZImage and EZPixmap.
- Added the Doxygen documentation.

### Changed features

- Merge EZ-Draw-1.2 in ez-draw++.

## [1.2.0] - 2016-02

## [1.1.0] - 2014-02

### Changed features

- Merge EZ-Draw-1.1 in ez-draw++.

## [0.9.1] ?

## [0.9.0] ?

## [0.8.0] - 2009-03

### New features

- Members function to manage timers.

## [0.7.0] - 2009-03

### New features

- C++ support for the library 'EZ-Draw-0.7'
