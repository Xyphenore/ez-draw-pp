# Check if a function received too many arguments.
# Print an author error if it is the case.
#
# @param FUNCTION - String - Name of function
# @param ARGUMENTS - Variable - List of unparsed arguments
#
# @example
# function(test)
#     set(option "")
#     set(oneValueArgs TEST)
#     set(multiValueArgs "")
#     cmake_parse_arguments(TEST "${option}" "${oneValueArg}" "${multiValueArg}" ${ARGN})
#
#     check_unparsed_arguments(
#         FUNCTION "test"
#         ARGUMENTS TEST_UNPARSED_ARGUMENTS
#     )
#
#     # Do something ...
#
# endfunction()
#
# @errors FATAL_ERROR if 'FUNCTION' OR 'ARGUMENTS' are missing.
# @errors AUTHOR_WARNING if too many arguments are given.
# @errors AUTHOR_WARNING if 'FUNCTION' has a blank string.
#
# @author Xyphenore
# @since 1.0.0
function(check_unparsed_arguments)
    set(option "")
    set(oneValueArg FUNCTION)
    set(multiValueArg ARGUMENTS)
    cmake_parse_arguments(CHECK "${option}" "${oneValueArg}" "${multiValueArg}" ${ARGN})

    # Check if required arguments are missing
    # Cannot call the function 'check_missing_arguments' because 'check_missing_arguments' calls this function
    if (DEFINED CHECK_KEYWORDS_MISSING_VALUES)
        message(
            FATAL_ERROR
            " Missing arguments for the function 'check_unparsed_arguments'.\
              Arguments: ${CHECK_KEYWORDS_MISSING_VALUES}."
        )
    endif ()


    # Check if the developer give too many arguments to 'check_unparsed_arguments'.
    if (DEFINED CHECK_UNPARSED_ARGUMENTS)
        #        list(LENGTH CHECK_UNPARSED_ARGUMENTS unparsed_arguments_length)

        #        if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            " Too much arguments given to the function 'check_unparsed_arguments'.\
              Arguments: ${CHECK_UNPARSED_ARGUMENTS}."
        )
        #        endif ()
    endif ()


    # Check if the function name is blank
    # Cannot import the cmake function is_blank because 'is_blank' import 'check_unparsed_arguments' function
    string(STRIP "${CHECK_FUNCTION}" striped_input)
    string(LENGTH "${striped_input}" striped_input_length)

    if (striped_input_length EQUAL 0)
        message(
            AUTHOR_WARNING
            " The function name '${CHECK_FUNCTION}' is blank.\
              Please give a not blank function name."
        )
    endif ()


    # Check if the developer gives too many arguments to the function 'FUNCTION'
    list(LENGTH ${CHECK_ARGUMENTS} unparsed_arguments_length)

    if (NOT unparsed_arguments_length EQUAL 0)
        message(
            AUTHOR_WARNING
            " Too much arguments given to the function '${CHECK_FUNCTION}'.\
              Arguments: ${CHECK_ARGUMENTS}."
        )
    endif ()

endfunction()


function(check_missing_arguments)
    set(option "")
endfunction()
