function(is_ascii)
    set(optional "")
    set(oneValueArgs STRING_INPUT BOOLEAN_OUTPUT)
    set(multiValueArgs "")
    cmake_parse_arguments(IS_ASCII "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH IS_ASCII_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the function 'is_ascii'.\
             Arguments: ${IS_ASCII_UNPARSED_ARGUMENTS}."
        )
    endif ()

    string(
        REGEX MATCH
        "^([][A-Za-z0-9 \t\r\n?.,\;!/:&\"\#'{\(\)-|`\\_\@\$%*+<>\^~=}])*$"
        out_string
        "${IS_ASCII_STRING_INPUT}"
    )

    if (DEFINED ${IS_ASCII_BOOLEAN_OUTPUT})
        message(
            DEBUG
            "Overwrite the content of the output variable.
             The previous content : ${${IS_ASCII_BOOLEAN_OUTPUT}}"
        )
    endif ()

    set(${IS_ASCII_BOOLEAN_OUTPUT} FALSE PARENT_SCOPE)
    if ("${out_string}" STREQUAL "${IS_ASCII_STRING_INPUT}")
        set(${IS_ASCII_BOOLEAN_OUTPUT} TRUE PARENT_SCOPE)
    endif ()
endfunction()
