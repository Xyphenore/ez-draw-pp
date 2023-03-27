cmake_minimum_required(VERSION 3.16.3..3.24.2)

project(
    ez-draw-pp
    DESCRIPTION "A graphic toy lib to show windows and draw on them."
    HOMEPAGE_URL https://github.com/Xyphenore/ez-draw-pp
    VERSION 1.2.6
    LANGUAGES CXX
)

# ----------------------------------------------------------------------------------------------------------------------
# Set the build type
# ----------------------------------------------------------------------------------------------------------------------

set(BUILD_TYPE_AVAILABLE RELEASE DEBUG)

if (NOT DEFINED CMAKE_BUILD_TYPE)
    set(
        CMAKE_BUILD_TYPE RELEASE CACHE STRING
        "Choose the type of build, options are: ${BUILD_TYPE_AVAILABLE}."
        FORCE
    )
endif ()

string(TOUPPER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE)

if (NOT "${CMAKE_BUILD_TYPE}" IN_LIST BUILD_TYPE_AVAILABLE)
    message(STATUS "Choose the type of build, options are: ${BUILD_TYPE_AVAILABLE}.")
endif ()

# ----------------------------------------------------------------------------------------------------------------------
# Create the ez-draw-pp library
# ----------------------------------------------------------------------------------------------------------------------

set(SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/${PROJECT_NAME}")
set(RESSOURCES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/data")

add_library(${PROJECT_NAME} "${SRC_DIR}/ez-draw++.cpp")
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 20)
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD_REQUIRED ON)
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_20)
target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE
    # Links for Windows
    $<$<PLATFORM_ID:Windows>:gdi32>
    $<$<PLATFORM_ID:Windows>:msimg32>

    # Links for Linux
    $<$<PLATFORM_ID:Linux>:X11>
    $<$<PLATFORM_ID:Linux>:Xext>
)


# Apply distinct compiler options for each common compiler
if (${CMAKE_CXX_COMPILER_ID} EQUAL "GNU")
    set(
        EXTRA_FLAGS
        -fimplicit-constexpr -Wnoexcept -Wstrict-null-sentinel -Wcatch-value=2 -Wuseless-cast
        -Wsuggest-final-types -Wsuggest-final-methods
    )

elseif (${CMAKE_CXX_COMPILER_ID} EQUAL "clang")
endif ()

target_compile_options(
    ${PROJECT_NAME}
    INTERFACE
    -Wall -Wextra -Weffc++ -Wpedantic
    -fstrict-enums
    -Wctor-dtor-privacy -Wnon-virtual-dtor -Wold-style-cast -Woverloaded-virtual
    -Wmismatched-tags -Wmismatched-new-delete -Wzero-as-null-pointer-constant -Wextra-semi
    -Wsuggest-override -Wdouble-promotion
    ${EXTRA_FLAGS}
)

# ----------------------------------------------------------------------------------------------------------------------
# Set available options
# ----------------------------------------------------------------------------------------------------------------------

string(TOUPPER ${PROJECT_NAME} UPPER_PROJECT_NAME)

# Options Tests
option(${UPPER_PROJECT_NAME}_WITH_TESTS "Build the test directory" OFF)
message(STATUS "Build the test directory: " ${${UPPER_PROJECT_NAME}_WITH_TESTS})

# Option Install
option(${UPPER_PROJECT_NAME}_INSTALL "Don't install the library" ON)
message(STATUS "Install the library: " ${${UPPER_PROJECT_NAME}_INSTALL})

# Option Documentation
option(${UPPER_PROJECT_NAME}_WITH_DOCUMENTATION "Build the documentation" OFF)
message(STATUS "Build the documentation: " ${${UPPER_PROJECT_NAME}_WITH_DOCUMENTATION})

# Option Examples
option(${UPPER_PROJECT_NAME}_WITH_EXAMPLES "Build all examples" OFF)
message(STATUS "Build all examples: " ${${UPPER_PROJECT_NAME}_WITH_DOCUMENTATION})

# Install option
if (${UPPER_PROJECT_NAME}_INSTALL)
    include(GNUInstallDirs)
    add_subdirectory(cmake)
endif ()

# Tests option
if (${UPPER_PROJECT_NAME}_WITH_TESTS OR BUILD_TESTING)
    include(CTest)
    enable_testing()

    add_subdirectory(tests)
endif ()

# Documentation option
if (${UPPER_PROJECT_NAME}_WITH_DOCUMENTATION)
    add_subdirectory(docs)
endif ()

# Examples option
if (${UPPER_PROJECT_NAME}_WITH_EXAMPLES)
    add_subdirectory(examples)
endif ()
