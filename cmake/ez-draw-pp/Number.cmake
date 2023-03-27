function(is_integer)
    set(optional "")
    set(oneValueArgs STRING_INPUT BOOLEAN_OUTPUT)
    set(multiValueArgs "")
    cmake_parse_arguments(IS_INTEGER "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH IS_INTEGER_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the function 'is_integer'.\
             Arguments: ${IS_INTEGER_UNPARSED_ARGUMENTS}."
        )
    endif ()

    if (DEFINED ${IS_INTEGER_BOOLEAN_OUTPUT})
        message(
            DEBUG
            "Overwrite the content of the output variable.
             The previous content : ${${IS_INTEGER_BOOLEAN_OUTPUT}}"
        )
    endif ()

    string(REGEX MATCH "^[0-9]+$" out_string "${IS_INTEGER_STRING_INPUT}")

    set(${IS_INTEGER_BOOLEAN_OUTPUT} FALSE PARENT_SCOPE)
    if ("${out_string}" STREQUAL "${IS_INTEGER_STRING_INPUT}")
        set(${IS_INTEGER_BOOLEAN_OUTPUT} TRUE PARENT_SCOPE)
    endif ()
endfunction()
