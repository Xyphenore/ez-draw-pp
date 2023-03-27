include(NotBlankString)
include(Number)

function(is_cxx_version)
    set(optional "")
    set(oneValueArgs CXX_STANDARD BOOLEAN_OUTPUT)
    set(multiValueArgs "")
    cmake_parse_arguments(IS_CXX "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH IS_CXX_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the function 'is_cxx_version'.
             Arguments: ${IS_CXX_UNPARSED_ARGUMENTS}."
        )
    endif ()

    if (DEFINED ${IS_CXX_BOOLEAN_OUTPUT})
        message(
            DEBUG
            "Overwrite the content of the output variable.
             The previous content : ${${IS_CXX_BOOLEAN_OUTPUT}}"
        )
    endif ()

    set(CXX_STANDARD_AVAILABLE 11 14 17 20 23)

    set(${IS_CXX_BOOLEAN_OUTPUT} FALSE PARENT_SCOPE)

    is_integer(STRING_INPUT "${IS_CXX_CXX_STANDARD}" BOOLEAN_OUTPUT is_an_integer)
    if (NOT is_an_integer)
        message(
            FATAL_ERROR
            "Cannot determine if it is a C++ version.\
             The C++ version '${IS_CXX_CXX_STANDARD}' is not an integer in ${CXX_STANDARD_AVAILABLE}.\
             Please give a valid C++ version to the function 'is_cxx_version',\
             like is_cxx_version( CXX_STANDARD 20 BOOLEAN_OUTPUT is_cxx_version ).
            "
        )
    endif ()

    list(GET CXX_STANDARD_AVAILABLE 0 first_version_supported)
    if (IS_CXX_CXX_STANDARD VERSION_LESS first_version_supported)
        message(
            FATAL_ERROR
            "The C++ version '${IS_CXX_CXX_STANDARD}'
             is less than the minimum C++ version '${first_version_supported}'.
             Please give a C++ version equals or greater than '${first_version_supported}'
             to the function 'is_cxx_version',
             like is_cxx_version( CXX_STANDARD 20 BOOLEAN_OUTPUT is_cxx ).
            "
        )
    endif ()

    math(EXPR value "(${IS_CXX_CXX_STANDARD} - ${first_version_supported}) % 3" OUTPUT_FORMAT DECIMAL)
    if (value EQUAL 0)
        set(${IS_CXX_BOOLEAN_OUTPUT} TRUE PARENT_SCOPE)
    endif ()

    list(GET CXX_STANDARD_AVAILABLE -1 last_version_supported)
    if (IS_CXX_CXX_STANDARD VERSION_GREATER last_version_supported)
        message(
            WARNING
            "The C++ version '${IS_CXX_CXX_STANDARD}' is over than the supported version.
             Please ask the author to update the C++ version available."
        )
    endif ()
endfunction()

macro(add_header_only_lib)
    set(optional REQUIRE_CXX_STANDARD ENABLE_CXX_EXTENSIONS)
    set(oneValueArgs NAME CXX_STANDARD)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'add_header_only_lib'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_NAME}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot add the header only library.\
             The name is blank.\
             Please give a not blank name to the macro 'add_header_only_lib',\
             like add_header_only_lib(\
                NAME lib_name\
                CXX_STANDARD 20\
                [REQUIRE_CXX_STANDARD, ENABLE_CXX_EXTENSIONS]\
             ).
            "
        )

    endif ()
    unset(blank_name)

    if (DEFINED ${LIB_NAME})
        message(
            FATAL_ERROR
            "Cannot add the header only library.\
             The name '${LIB_NAME}' is already use for another variable.\
             Please give a name variable available to the macro 'add_header_only_lib',\
             like add_header_only_lib(\
                NAME lib_name\
                CXX_STANDARD 20\
                [REQUIRE_CXX_STANDARD, ENABLE_CXX_EXTENSIONS]\
             ).
            "
        )

    endif ()

    is_cxx_version(CXX_STANDARD "${LIB_CXX_STANDARD}" BOOLEAN_OUTPUT is_cxx)
    if (NOT is_cxx)
        message(
            FATAL_ERROR
            "Cannot add the header only library.\
             The C++ version '${LIB_CXX_STANDARD}' is not a valid C++ version.\
             Please give a valid C++ version to the macro 'add_header_only_lib',\
             like add_header_only_lib(\
                NAME lib_name\
                CXX_STANDARD 20\
                [REQUIRE_CXX_STANDARD, ENABLE_CXX_EXTENSIONS]\
             ).
            "
        )
    endif ()

    add_library(${LIB_NAME} INTERFACE)
    set_target_properties(${LIB_NAME} PROPERTIES CXX_STANDARD ${LIB_CXX_STANDARD})
    set_target_properties(${LIB_NAME} PROPERTIES CXX_STANDARD_REQUIRED ${LIB_REQUIRE_CXX_STANDARD})
    set_target_properties(${LIB_NAME} PROPERTIES CXX_EXTENSIONS ${LIB_ENABLE_CXX_EXTENSIONS})
    target_compile_features(${LIB_NAME} INTERFACE cxx_std_${LIB_CXX_STANDARD})

    unset(LIB_CXX_STANDARD)
    unset(LIB_ENABLE_CXX_EXTENSIONS)
    unset(LIB_REQUIRE_CXX_STANDARD)
    unset(LIB_NAME)
    unset(LIB_UNPARSED_ARGUMENTS)
endmacro()

macro(add_ipo_to_lib)
    set(optional "")
    set(oneValueArgs NAME)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'add_ipo_to_lib'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_NAME}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot add IPO to the library.\
             The name is blank.\
             Please give a not blank name to the macro 'add_ipo_to_lib',\
             like add_ipo_to_lib( NAME lib_name ).
            "
        )
    endif ()
    unset(blank_name)

    include(CheckIPOSupported)

    check_ipo_supported(
        RESULT ipo_supported
        OUTPUT error_output
        LANGUAGES CXX
    )

    set_target_properties(${LIB_NAME} PROPERTIES INTERPROCEDURAL_OPTIMIZATION ${ipo_supported})

    if (NOT ipo_supported)
        message(FATAL_ERROR "IPO is not supported: ${error_output}")
    endif ()
    unset(error_output)
    unset(ipo_supported)

    unset(LIB_NAME)
    unset(LIB_UNPARSED_ARGUMENTS)
endmacro()

macro(add_compile_option)
    set(optional "")
    set(oneValueArgs NAME)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'add_compile_option'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_NAME}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot add compile options to the library.\
             The name is blank.\
             Please give a not blank name to the macro 'add_compile_option',\
             like add_compile_option( NAME lib_name ).
            "
        )
    endif ()
    unset(blank_name)

    set(EXTRA_FLAGS "")
    if (${CMAKE_CXX_COMPILER_ID} EQUAL "GNU")
        set(
            EXTRA_FLAGS
            -fimplicit-constexpr -Wnoexcept -Wstrict-null-sentinel -Wcatch-value=2 -Wuseless-cast
            -Wsuggest-final-types -Wsuggest-final-methods
        )
    elseif (${CMAKE_CXX_COMPILER_ID} EQUAL "clang")
    endif ()

    target_compile_options(
        ${LIB_NAME}
        INTERFACE
        -Wall -Wextra -Weffc++ -Wpedantic
        -fstrict-enums
        -Wctor-dtor-privacy -Wnon-virtual-dtor -Wold-style-cast -Woverloaded-virtual
        -Wmismatched-tags -Wmismatched-new-delete -Wzero-as-null-pointer-constant -Wextra-semi
        -Wsuggest-override -Wdouble-promotion
        ${EXTRA_FLAGS}
    )
    unset(EXTRA_FLAGS)

    unset(LIB_NAME)
    unset(LIB_UNPARSED_ARGUMENTS)
endmacro()

macro(create_lib)
    set(optional "")
    set(oneValueArgs NAME)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'create_lib'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_NAME}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot create the library.\
             The name is blank.\
             Please give a not blank name to the macro 'create_lib',\
             like create_lib( NAME lib_name ).
            "
        )
    endif ()
    unset(blank_name)

    if (DEFINED ${LIB_NAME})
        message(
            FATAL_ERROR
            "Cannot create the library.\
             The name '${LIB_NAME}' is already used by another variable.\
             Please give a name not used to the macro 'create_lib',\
             like create_lib( NAME lib_name ).
            "
        )
    endif ()

    unset(LIB_NAME)
    unset(LIB_UNPARSED_ARGUMENTS)

    add_subdirectory(src)
endmacro()

macro(install_lib)
    set(optional "")
    set(oneValueArgs NAME)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'install_lib'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_NAME}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot install the library.\
             The name is blank.\
             Please give a not blank name to the macro 'install_lib',\
             like install_lib( NAME lib_name ).
            "
        )
    endif ()
    unset(blank_name)

    unset(LIB_NAME)
    unset(LIB_UNPARSED_ARGUMENTS)

    include(GNUInstallDirs)
    add_subdirectory(cmake)
endmacro()

macro(generate_doc)
    set(optional "")
    set(oneValueArgs "")
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'generate_doc'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)
    unset(LIB_UNPARSED_ARGUMENTS)

    add_subdirectory(doc)
endmacro()

macro(build_tests)
    set(optional "")
    set(oneValueArgs NAME)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'build_tests'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_NAME}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot install the library.\
             The name is blank.\
             Please give a not blank name to the macro 'build_tests',\
             like build_tests( NAME lib_name ).
            "
        )
    endif ()
    unset(blank_name)

    unset(LIB_NAME)
    unset(LIB_UNPARSED_ARGUMENTS)

    include(CTest)
    enable_testing()

    add_subdirectory(test)
endmacro()

macro(build_examples)
    set(optional "")
    set(oneValueArgs NAME)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'build_examples'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_NAME}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot install the library.\
             The name is blank.\
             Please give a not blank name to the macro 'build_examples',\
             like build_examples( NAME lib_name ).
            "
        )
    endif ()
    unset(blank_name)

    unset(LIB_NAME)
    unset(LIB_UNPARSED_ARGUMENTS)

    add_subdirectory(example)
endmacro()

macro(download_external_libraries)
    set(optional "")
    set(oneValueArgs "")
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'download_external_libraries'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    unset(LIB_UNPARSED_ARGUMENTS)

    add_subdirectory(extern)
endmacro()

macro(add_object_lib)
    set(optional REQUIRE_CXX_STANDARD ENABLE_CXX_EXTENSIONS)
    set(oneValueArgs NAME CXX_STANDARD)
    set(multiValueArgs SOURCE_FILES)
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'add_object_lib'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_NAME}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot add the object library.\
             The name is blank.\
             Please give a not blank name to the macro 'add_object_lib',\
             like add_object_lib(\
                NAME lib_name\
                CXX_STANDARD 20\
                SOURCE_FILES *.cpp\
                [REQUIRE_CXX_STANDARD, ENABLE_CXX_EXTENSIONS]\
             ).
            "
        )
    endif ()
    unset(blank_name)

    if (DEFINED ${LIB_NAME})
        message(
            FATAL_ERROR
            "Cannot add the object library.\
             The name '${LIB_NAME}' is already use for another variable.\
             Please give a name variable available to the macro 'add_object_lib',\
             like add_object_lib(\
                NAME lib_name\
                CXX_STANDARD 20\
                SOURCE_FILES *.cpp\
                [REQUIRE_CXX_STANDARD, ENABLE_CXX_EXTENSIONS]\
             ).
            "
        )
    endif ()

    is_cxx_version(CXX_STANDARD "${LIB_CXX_STANDARD}" BOOLEAN_OUTPUT is_cxx)
    if (NOT is_cxx)
        message(
            FATAL_ERROR
            "Cannot add the object library.\
             The C++ version '${LIB_CXX_STANDARD}' is not a valid C++ version.\
             Please give a valid C++ version to the macro 'add_object_lib',\
             like add_object_lib(\
                NAME lib_name\
                CXX_STANDARD 20\
                SOURCE_FILES *.cpp\
                [REQUIRE_CXX_STANDARD, ENABLE_CXX_EXTENSIONS]\
             ).
            "
        )
    endif ()
    unset(is_cxx)

    list(LENGTH LIB_SOURCE_FILES src_files_length)
    if (src_files_length EQUAL 0)
        message(
            FATAL_ERROR
            "Cannot add the object library.\
             The C++ version '${LIB_CXX_STANDARD}' is not an integer in ${CXX_STANDARD_AVAILABLE}.\
             Please give a valid C++ version to the macro 'add_object_lib',\
             like add_object_lib(\
                NAME lib_name\
                CXX_STANDARD 20\
                SOURCE_FILES *.cpp\
                [REQUIRE_CXX_STANDARD, ENABLE_CXX_EXTENSIONS]\
             ).
            "
        )
    endif ()
    unset(src_files_length)

    add_library(${LIB_NAME} OBJECT ${LIB_SOURCE_FILES})
    set_target_properties(${LIB_NAME} PROPERTIES CXX_STANDARD ${LIB_CXX_STANDARD})
    set_target_properties(${LIB_NAME} PROPERTIES CXX_STANDARD_REQUIRED ${LIB_REQUIRE_CXX_STANDARD})
    set_target_properties(${LIB_NAME} PROPERTIES CXX_EXTENSIONS ${LIB_ENABLE_CXX_EXTENSIONS})
    target_compile_features(${LIB_NAME} PRIVATE cxx_std_${LIB_CXX_STANDARD})

    unset(LIB_NAME)
    unset(LIB_UNPARSED_ARGUMENTS)
    unset(LIB_REQUIRE_CXX_STANDARD)
    unset(LIB_ENABLE_CXX_EXTENSIONS)
    unset(LIB_SOURCE_FILES)
    unset(LIB_CXX_STANDARD)
endmacro()

macro(download_doctest)
    set(optional "")
    set(oneValueArgs OUTPUT_FILE)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'download_doctest'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_OUTPUT_FILE}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot download the doctest library.\
             The output file is blank.\
             Please give a not blank output file to the macro 'download_doctest',\
             like download_doctest( OUTPUT_FILE \"path_to_output_file\" ).
            "
        )
    endif ()
    unset(blank_name)

    if (EXISTS "${LIB_OUTPUT_FILE}")
        message(DEBUG "Rewrite the content of the file '${LIB_OUTPUT_FILE}'.")
    endif ()

    message(STATUS "Download the latest doctest library.")
    file(
        DOWNLOAD
        https://raw.githubusercontent.com/doctest/doctest/master/doctest/doctest.h
        "${LIB_OUTPUT_FILE}"
        TIMEOUT 15
        INACTIVITY_TIMEOUT 15
        STATUS validated
    )

    list(GET validated 0 error_code)
    if (error_code EQUAL 0)
        message(STATUS "Download the latest doctest library: 100%.")
    else ()
        list(GET validated 1 error_message)
        message(WARNING "Download failed the latest doctest library. Reason: '${error_message}'.")
        unset(error_message)
    endif ()
    unset(error_code)

    unset(LIB_UNPARSED_ARGUMENTS)
    unset(LIB_OUTPUT_FILE)
endmacro()

macro(download_doctest_version_file)
    set(optional "")
    set(oneValueArgs OUTPUT_FILE)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'download_doctest_version_file'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_OUTPUT_FILE}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot download the doctest library version file.\
             The output file is blank.\
             Please give a not blank output file to the macro 'download_doctest_version_file',\
             like download_doctest_version_file( OUTPUT_FILE \"path_to_output_file\" ).
            "
        )
    endif ()
    unset(blank_name)

    if (EXISTS "${LIB_OUTPUT_FILE}")
        message(DEBUG "Rewrite the content of the file '${LIB_OUTPUT_FILE}'.")
    endif ()

    message(STATUS "Download the doctest version.")
    file(
        DOWNLOAD
        https://raw.githubusercontent.com/doctest/doctest/master/scripts/version.txt
        "${LIB_OUTPUT_FILE}"
        TIMEOUT 15
        INACTIVITY_TIMEOUT 15
        STATUS validated
    )

    list(GET validated 0 error_code)
    if (error_code EQUAL 0)
        message(STATUS "Download the doctest version: 100%.")
    else ()
        list(GET validated 1 error_message)
        message(WARNING "Download failed the latest doctest library version file. Reason: '${error_message}'.")
        unset(error_message)
    endif ()
    unset(error_code)

    unset(LIB_OUTPUT_FILE)
    unset(LIB_UNPARSED_ARGUMENTS)
endmacro()

macro(extract_version_from_file)
    set(optional "")
    set(oneValueArgs VERSION_FILE VERSION_OUTPUT)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'extract_version_from_file'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_VERSION_FILE}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot extract the doctest library version from the file.\
             The version file path is blank.\
             Please give a not blank version file path to the macro 'extract_version_from_file',\
             like extract_version_from_file( VERSION_FILE \"path_to_version_file\" VERSION_OUTPUT version ).
            "
        )
    endif ()
    unset(blank_name)

    if (NOT EXISTS "${LIB_VERSION_FILE}")
        message(
            FATAL_ERROR
            "Cannot extract the doctest library version from the file.\
             The version file path does not exists '${LIB_VERSION_FILE}'.\
             Please give an existing version file to the macro 'extract_version_from_file',\
             like extract_version_from_file( VERSION_FILE \"path_to_version_file\" VERSION_OUTPUT version ).
            "
        )
    endif ()

    if (DEFINED ${LIB_VERSION_OUTPUT})
        message(
            DEBUG
            "Rewrite the content of the variable '${LIB_VERSION_OUTPUT}'.
             Previous content: '${${LIB_VERSION_OUTPUT}}'.
            "
        )
    endif ()

    file(STRINGS "${LIB_VERSION_FILE}" ${LIB_VERSION_OUTPUT} LIMIT_COUNT 1 REGEX "^[0-9]+[.][0-9]+[.][0-9]+$")

    unset(LIB_VERSION_OUTPUT)
    unset(LIB_VERSION_FILE)
    unset(LIB_UNPARSED_ARGUMENTS)
endmacro()

macro(download_doxygen_awesome_css)
    set(optional "")
    set(oneValueArgs OUTPUT_FILE)
    set(multiValueArgs "")
    cmake_parse_arguments(LIB "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH LIB_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'download_doxygen_awesome_css'.
             Arguments: ${LIB_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    is_blank(STRING_INPUT "${LIB_OUTPUT_FILE}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "Cannot download the doxygen awesome css library.\
             The output file is blank.\
             Please give a not blank output file to the macro 'download_doxygen_awesome_css',\
             like download_doxygen_awesome_css( OUTPUT_FILE \"path_to_output_file\" ).
            "
        )
    endif ()
    unset(blank_name)

    if (EXISTS "${LIB_OUTPUT_FILE}")
        message(DEBUG "Rewrite the content of the file '${LIB_OUTPUT_FILE}'.")
    endif ()

    set(
        HASH_AWESOME_CSS
        a4ad0b630a3ec8b360637e345e6dcf6d3b05fa097574c2a43cf53cfd78bd6af84dc8919aab7db9c75edc8c5745558799407f80ea000f3a2bd2b2353ff1d92e9c
    )

    message(STATUS "Download the latest doxygen awesome css library.")
    file(
        DOWNLOAD
        https://github.com/jothepro/doxygen-awesome-css/archive/refs/tags/v2.1.0.tar.gz
        "${LIB_OUTPUT_FILE}"
        TIMEOUT 15
        INACTIVITY_TIMEOUT 15
        STATUS validated
        EXPECTED_HASH SHA3_512=${HASH_AWESOME_CSS}
    )

    list(GET validated 0 error_code)
    if (error_code EQUAL 0)
        message(STATUS "Download the latest doxygen awesome css library: 100%.")
    else ()
        list(GET validated 1 error_message)
        message(WARNING "Download failed the latest doctest library. Reason: '${error_message}'.")
        unset(error_message)
    endif ()
    unset(error_code)

    unset(HASH_AWESOME_CSS)
    unset(LIB_UNPARSED_ARGUMENTS)
    unset(LIB_OUTPUT_FILE)
endmacro()
