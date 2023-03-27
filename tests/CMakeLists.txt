cmake_minimum_required(VERSION 3.12)

# ----------------------------------------------------------------------------------------------------------------------
# Download latest version of doctest
# ----------------------------------------------------------------------------------------------------------------------

# TODO Lock the doctest version to the latest

set(DOCTEST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/doctest")
set(DOCTEST_FILE "${DOCTEST_DIR}/doctest.h")

option(REGENERATE_DOCTEST "Re-download the DOCTEST library." OFF)
message(STATUS "Re-download the DOCTEST library: " ${REGENERATE_DOCTEST})

if (NOT EXISTS ${DOCTEST_FILE} OR REGENERATE_DOCTEST)
    message(STATUS "Download the latest doctest library.")
    file(
        DOWNLOAD
        https://raw.githubusercontent.com/doctest/doctest/master/doctest/doctest.h
        ${DOCTEST_FILE}
        TIMEOUT 15
    )
    message(STATUS "Download the latest doctest library: 100%.")

    # TODO Check sha256 sum

endif ()

# ----------------------------------------------------------------------------------------------------------------------
# Create the doctest library and the main function
# ----------------------------------------------------------------------------------------------------------------------

add_library(doctest INTERFACE)
target_compile_features(doctest INTERFACE cxx_std_20)
target_include_directories(doctest INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/doctest")

add_library(Test_Main OBJECT main.test.cpp)
target_compile_features(Test_Main PRIVATE cxx_std_20)
target_link_libraries(Test_Main PRIVATE doctest)

# ----------------------------------------------------------------------------------------------------------------------
# Set all tests
# ----------------------------------------------------------------------------------------------------------------------

set(
    TestsToRun
)

# ----------------------------------------------------------------------------------------------------------------------
# Create the executable AllTests
# ----------------------------------------------------------------------------------------------------------------------

add_executable(AllTests ${TestsToRun} $<TARGET_OBJECTS:Test_Main>)
target_compile_features(AllTests PRIVATE cxx_std_20)
target_include_directories(AllTests PRIVATE "${PROJECT_SOURCE_DIR}/include")

# ----------------------------------------------------------------------------------------------------------------------
# Create each unique test
# ----------------------------------------------------------------------------------------------------------------------

foreach (test IN LISTS ${TestsToRun})
    get_filename_component(TName ${test} NAME_WE)
    add_test(NAME ${TName} COMMAND AllTests ${TName})

    add_executable(${TName} "${TName}.cpp" $<TARGET_OBJECTS:Test_Main>)
    target_compile_features(${TName} PRIVATE cxx_std_20)
    target_include_directories(${TName} PRIVATE "${PROJECT_SOURCE_DIR}/include")
endforeach ()
