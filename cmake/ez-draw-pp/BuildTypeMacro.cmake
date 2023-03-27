include(NotBlankString)
include(InternalUtils)

macro(initialize_build_type)
    set(option " ")
    set(oneValueArgs DEFAULT_BUILD_TYPE)
    set(multiValueArgs AVAILABLE_BUILD_TYPE)
    cmake_parse_arguments(INITIALIZE "${option}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    check_unparsed_arguments(UNPARSED_ARGUMENTS ${INITIALIZE_UNPARSED_ARGUMENTS})

    is_blank(STRING_INPUT "${INITIALIZE_DEFAULT_BUILD_TYPE}" BOOLEAN_OUTPUT blank_default_value)
    if (blank_default_value)
        message(
            FATAL_ERROR
            " Cannot initialize the build type of the project.\
                          The default value is blank.\
                          Please give a not blank default value for the build type to the macro 'initialize_build_type',\
                          the default value must be in the given available build type,\
                          like initialize_build_type (\
                          DEFAULT_BUILD_TYPE \"Release\"\
                          AVAILABLE_BUILD_TYPE \"Release\" \"Debug\" \"MinSizeRel\"\
                          )."
        )
    endif ()
    unset(blank_default_value)

    list(LENGTH INITIALIZE_AVAILABLE_BUILD_TYPE available_build_type_length)
    if (available_build_type_length EQUAL 0)
        message(
            FATAL_ERROR
            "Cannot initialize the build type of the project.\
    The available build type list is empty.\
    Please give at least one value for available build type to the macro 'initialize_build_type',\
    the default value must be in the given available build type,\
    like initialize_build_type(\
    DEFAULT_BUILD_TYPE \"Release\"
    AVAILABLE_BUILD_TYPE \"Release\" \"Debug\" \"MinSizeRel\"\
    )."
        )
    endif ()
    unset(available_build_type_length)

    if (NOT INITIALIZE_DEFAULT_BUILD_TYPE IN_LIST INITIALIZE_AVAILABLE_BUILD_TYPE)
        message(
            FATAL_ERROR
            "Cannot initialize the build type of the project.\
    The default build type is not in the available build type list.\
    Please give a value in the available build type list for the default build type\
    to the macro 'initialize_build_type',\
    like initialize_build_type(\
    DEFAULT_BUILD_TYPE \"Release\"
    AVAILABLE_BUILD_TYPE \"Release\" \"Debug\" \"MinSizeRel\"\
    )."
        )
    endif ()

    if (NOT DEFINED CMAKE_BUILD_TYPE)
        message(STATUS "Setting build type to '${INITIALIZE_DEFAULT_BUILD_TYPE}' as none was specified.")
        set(
            CMAKE_BUILD_TYPE "${INITIALIZE_DEFAULT_BUILD_TYPE}" CACHE STRING
            "Choose the type of build, options are: ${INITIALIZE_AVAILABLE_BUILD_TYPE}."
            FORCE
        )
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${INITIALIZE_AVAILABLE_BUILD_TYPE})
    endif ()

    string(TOUPPER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE)

    if (NOT CMAKE_BUILD_TYPE IN_LIST INITIALIZE_AVAILABLE_BUILD_TYPE)
        message(FATAL_ERROR "Choose the type of build, options are: ${INITIALIZE_AVAILABLE_BUILD_TYPE}.")
    endif ()

    unset(INITIALIZE_AVAILABLE_BUILD_TYPE)
    unset(INITIALIZE_DEFAULT_BUILD_TYPE)
    unset(INITIALIZE_UNPARSED_ARGUMENTS)
endmacro()
