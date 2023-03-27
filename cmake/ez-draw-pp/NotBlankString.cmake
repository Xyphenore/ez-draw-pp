include(InternalUtils)

# Check if the string is blank.
#
# @param STRING_INPUT - The string to check.
# @param BOOLEAN_OUTPUT - The output variable.
#
# @returns boolean - Returns in the boolean_output variable, True if the string is blank, else False.
#
# @author: Xyphenore
# @since 1.0.0
function(is_blank)
    set(option "")
    set(oneValueArgs STRING_INPUT BOOLEAN_OUTPUT)
    set(multiValueArgs "")
    cmake_parse_arguments(IS_BLANK "${option}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})


    check_unparsed_arguments(
        FUNCTION "is_blank"
        ARGUMENTS ${IS_BLANK_UNPARSED_ARGUMENTS}
    )


    # Check if the output variable is defined
    # Print the value in a debug message if it defined
    if (DEFINED ${IS_BLANK_BOOLEAN_OUTPUT})
        message(
            DEBUG
            "Overwrite the content of the boolean output variable.
             The previous content : ${${IS_BLANK_BOOLEAN_OUTPUT}}"
        )
    endif ()


    set(${IS_BLANK_BOOLEAN_OUTPUT} FALSE PARENT_SCOPE)

    string(STRIP "${IS_BLANK_STRING_INPUT}" striped_input)
    string(LENGTH "${striped_input}" striped_input_length)

    if (striped_input_length EQUAL 0)
        set(${IS_BLANK_BOOLEAN_OUTPUT} TRUE PARENT_SCOPE)
    endif ()

endfunction()
