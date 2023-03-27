include(NotBlankString)

macro(add_option)
    set(optional "")
    set(oneValueArgs NAME DESCRIPTION DEFAULT_VALUE)
    set(multiValueArgs "")
    cmake_parse_arguments(ADD_OPTION "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH ADD_OPTION_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the macro 'add_option'.
             Arguments: ${ADD_OPTION_UNPARSED_ARGUMENTS}."
        )
    endif ()
    unset(unparsed_arguments_length)

    if (DEFINED ${ADD_OPTION_NAME})
        message(
            DEBUG
            "Cannot add the option '${ADD_OPTION_NAME}'.
             The variable '${ADD_OPTION_NAME}' already exists."
        )
    endif ()

    is_blank(STRING_INPUT "${ADD_OPTION_NAME}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "The option name is blank.
             Please give to the macro 'add_option' a not blank name,
             like add_option( NAME name DESCRIPTION \"description\" DEFAULT_VALUE OFF )."
        )
    endif ()
    unset(blank_name)

    is_blank(STRING_INPUT "${ADD_OPTION_DESCRIPTION}" BOOLEAN_OUTPUT blank_description)
    if (blank_description)
        message(
            FATAL_ERROR
            "The option description is blank.
             Please give to the macro 'add_option' a not blank description,
             like add_option( NAME name DESCRIPTION \"description\" DEFAULT_VALUE OFF )."
        )
    endif ()
    unset(blank_description)

    is_blank(STRING_INPUT "${ADD_OPTION_DEFAULT_VALUE}" BOOLEAN_OUTPUT blank_value)
    if (blank_value)
        message(
            FATAL_ERROR
            "The option default value is blank.
             Please give to the macro 'add_option' a not blank default value,
             like add_option( NAME name DESCRIPTION \"description\" DEFAULT_VALUE OFF )."
        )
    endif ()
    unset(blank_value)

    set(ACCEPTED_DEFAULT_VALUE ON on On OFF off Off)
    if (NOT ADD_OPTION_DEFAULT_VALUE IN_LIST ACCEPTED_DEFAULT_VALUE)
        message(
            FATAL_ERROR
            "The option default value '${ADD_OPTION_DEFAULT_VALUE}' is not a valid value.
             Please give to the macro 'add_option' a default value in ${ACCEPTED_DEFAULT_VALUE},
             like add_option( NAME name DESCRIPTION \"description\" DEFAULT_VALUE OFF )."
        )
    endif ()
    unset(ACCEPTED_DEFAULT_VALUE)

    option(${ADD_OPTION_NAME} "${ADD_OPTION_DESCRIPTION}" ${ADD_OPTION_DEFAULT_VALUE})
    print_option(NAME ${ADD_OPTION_NAME} DESCRIPTION "${ADD_OPTION_DESCRIPTION}")
endmacro()

function(print_option)
    set(optional "")
    set(oneValueArgs NAME DESCRIPTION)
    set(multiValueArgs "")
    cmake_parse_arguments(PRINT_OPTION "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH PRINT_OPTION_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the function 'print_option'.
             Arguments: ${PRINT_OPTION_UNPARSED_ARGUMENTS}."
        )
    endif ()

    if (NOT DEFINED ${PRINT_OPTION_NAME})
        message(
            FATAL_ERROR
            "Cannot print the option '${PRINT_OPTION_NAME}'.
             The option '${PRINT_OPTION_NAME}' not exists."
        )
    endif ()

    is_blank(STRING_INPUT "${PRINT_OPTION_NAME}" BOOLEAN_OUTPUT blank_name)
    if (blank_name)
        message(
            FATAL_ERROR
            "The option name is blank.
             Please give to the macro 'print_option' a not blank name,
             like print_option( NAME name DESCRIPTION \"description\" )."
        )
    endif ()

    is_blank(STRING_INPUT "${PRINT_OPTION_DESCRIPTION}" BOOLEAN_OUTPUT blank_description)
    if (blank_description)
        message(
            FATAL_ERROR
            "The option description is blank.
             Please give to the macro 'print_option' a not blank description,
             like print_option( NAME name DESCRIPTION \"description\" )."
        )
    endif ()

    string(STRIP "${PRINT_OPTION_DESCRIPTION}" status_message)
    string(REGEX REPLACE "[?.!,;=:]$" "" status_message "${status_message}")
    string(CONCAT status_message "${status_message}" ": ")

    message(STATUS "${status_message}" "${${PRINT_OPTION_NAME}}")
endfunction()
