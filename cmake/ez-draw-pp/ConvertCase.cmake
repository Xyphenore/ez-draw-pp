include(NotBlankString)
include(AsciiString)

function(camel_case_to_snake_case)
    set(optional "")
    set(oneValueArgs CAMEL_CASE_STRING SNAKE_CASE_STRING)
    set(multiValueArgs "")
    cmake_parse_arguments(CONVERT "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH CONVERT_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the function 'camel_case_to_snake_case'.
             Arguments: ${CONVERT_UNPARSED_ARGUMENTS}."
        )
    endif ()

    if (DEFINED ${CONVERT_SNAKE_CASE_STRING})
        message(
            DEBUG
            "Overwrite the content of the output variable.
             The previous content : ${${CONVERT_SNAKE_CASE_STRING}}"
        )
    endif ()

    is_blank(STRING_INPUT "${CONVERT_CAMEL_CASE_STRING}" BOOLEAN_OUTPUT blank_input)
    if (blank_input)
        message(DEBUG "The input string is blank. The function returns the same string.")
    else ()
        string(STRIP "${CONVERT_CAMEL_CASE_STRING}" striped_input)

        string(REGEX MATCH "^[a-z][A-Za-z0-9]*$" matched_string "${striped_input}")
        if (NOT "${matched_string}" STREQUAL "${striped_input}")
            message(
                FATAL_ERROR
                "Cannot convert CamelCase to snake_case.
                 The input string is not camel case: '${CONVERT_CAMEL_CASE_STRING}'.
                 Please give a CamelCase input string to the function 'camel_case_to_snake_case',
                 like camel_case_to_snake_case(
                    CAMEL_CASE_STRING \"aCamelCaseString\"
                    SNAKE_CASE_STRING snake_case_string
                 )."
            )
        endif ()

        is_ascii(STRING_INPUT "${CONVERT_CAMEL_CASE_STRING}" BOOLEAN_OUTPUT ascii_string)
        if (NOT ascii_string)
            message(
                FATAL_ERROR
                "Cannot convert not ASCII string from CamelCase to snake_case.
                 Please give an ASCII string to the function 'camel_case_to_snake_case',
                 like camel_case_to_snake_case(
                    CAMEL_CASE_STRING \"asciiCamelCaseString\"
                    SNAKE_CASE_STRING snake_case_string
                 ).
                "
            )
        endif ()

        set(treated_string "${striped_input}")

        set(UPPER_ALPHABET A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
        foreach (upper_letter IN LISTS UPPER_ALPHABET)
            string(TOLOWER "${upper_letter}" lower_letter)
            string(
                REPLACE "${upper_letter}" "_${lower_letter}"
                treated_string "${treated_string}"
            )
        endforeach ()

        string(
            REPLACE "${striped_input}" "${treated_string}"
            CONVERT_CAMEL_CASE_STRING "${CONVERT_CAMEL_CASE_STRING}"
        )
    endif ()

    set(${CONVERT_SNAKE_CASE_STRING} "${CONVERT_CAMEL_CASE_STRING}" PARENT_SCOPE)
endfunction()

function(pascal_case_to_snake_case)
    set(optional "")
    set(oneValueArgs PASCAL_CASE_STRING SNAKE_CASE_STRING)
    set(multiValueArgs "")
    cmake_parse_arguments(CONVERT "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH CONVERT_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the function 'pascal_case_to_snake_case'.
             Arguments: ${CONVERT_UNPARSED_ARGUMENTS}."
        )
    endif ()

    if (DEFINED ${CONVERT_SNAKE_CASE_STRING})
        message(
            DEBUG
            "Overwrite the content of the output variable.
             The previous content : ${${CONVERT_SNAKE_CASE_STRING}}"
        )
    endif ()

    is_blank(STRING_INPUT "${CONVERT_PASCAL_CASE_STRING}" BOOLEAN_OUTPUT blank_input)
    if (blank_input)
        message(DEBUG "The input string is blank. The function returns the same string.")
    else ()
        string(STRIP "${CONVERT_PASCAL_CASE_STRING}" striped_input)

        string(REGEX MATCH "^[A-Z][A-Za-z0-9]*$" matched_string "${striped_input}")
        if (NOT "${matched_string}" STREQUAL "${striped_input}")
            message(
                FATAL_ERROR
                "Cannot convert PascalCase to snake_case.\
                 \t The input string is not pascal case: '${CONVERT_PASCAL_CASE_STRING}'.\
                 \t Please give a PascalCase input string to the function 'pascal_case_to_snake_case',\
                 like pascal_case_to_snake_case(\
                    PASCAL_CASE_STRING \"APascalCaseString\"\
                    SNAKE_CASE_STRING snake_case_string\
                 )."
            )
        endif ()

        is_ascii(STRING_INPUT "${CONVERT_PASCAL_CASE_STRING}" BOOLEAN_OUTPUT ascii_string)
        if (NOT ascii_string)
            message(
                FATAL_ERROR
                "Cannot convert not ASCII string from PascalCase to snake_case.\
                 Please give an ASCII string to the function 'pascal_case_to_snake_case',\
                 like pascal_case_to_snake_case(\
                    PASCAL_CASE_STRING \"APascalCaseString\"\
                    SNAKE_CASE_STRING snake_case_string\
                 ).
                "
            )
        endif ()

        string(LENGTH "${striped_input}" striped_string_length)
        string(SUBSTRING "${striped_input}" 1 ${striped_string_length} remaining_letters)

        camel_case_to_snake_case(CAMEL_CASE_STRING "${remaining_letters}" SNAKE_CASE_STRING snake_case_string)

        string(SUBSTRING "${striped_input}" 0 1 first_letter)
        string(TOLOWER "${first_letter}" lower_first_letter)
        string(CONCAT concatenated_string "${lower_first_letter}" "${snake_case_string}")

        string(
            REPLACE "${striped_input}" "${concatenated_string}"
            CONVERT_PASCAL_CASE_STRING "${CONVERT_PASCAL_CASE_STRING}"
        )
    endif ()

    set(${CONVERT_SNAKE_CASE_STRING} "${CONVERT_PASCAL_CASE_STRING}" PARENT_SCOPE)
endfunction()

function(pascal_case_to_screaming_snake_case)
    set(optional "")
    set(oneValueArgs PASCAL_CASE_STRING SCREAMING_SNAKE_CASE_STRING)
    set(multiValueArgs "")
    cmake_parse_arguments(CONVERT "${optional}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(LENGTH CONVERT_UNPARSED_ARGUMENTS unparsed_arguments_length)
    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            "Too much arguments given to the function 'pascal_case_to_screaming_snake_case'.
             Arguments: ${CONVERT_UNPARSED_ARGUMENTS}."
        )

    endif ()

    if (DEFINED ${CONVERT_SCREAMING_SNAKE_CASE_STRING})
        message(
            DEBUG
            "Overwrite the content of the output variable.
             The previous content : ${${CONVERT_SCREAMING_SNAKE_CASE_STRING}}"
        )
    endif ()

    pascal_case_to_snake_case(PASCAL_CASE_STRING "${CONVERT_PASCAL_CASE_STRING}" SNAKE_CASE_STRING snake_case_string)
    string(TOUPPER "${snake_case_string}" screaming_snake_case)

    set(${CONVERT_SCREAMING_SNAKE_CASE_STRING} "${screaming_snake_case}" PARENT_SCOPE)
endfunction()
