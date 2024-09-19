#!/usr/bin/env bash
#
# Script to test an express server
#
# Exit values:
#  0 on success
#  1 on failure
#


# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"


# Port and url of express server
PORT=${DBWEBB_PORT:-1337}
URL="http://localhost:$PORT"


#
# Message to display for usage and help.
#
function usage
{
    local txt=(
        "$SCRIPT for testing routes of dev server."
        "Usage: $SCRIPT [options] <command> [arguments]"
        ""
        "Commands:"
        "   all              Request /all           - present all plants"
        "   names            Request /names         - present all names"
        "   color <color>    Request /color/<color> - present matching plants"
        "   test <url>       Test server            - get current status"
        ""
        "Options:"
        "   --help, -h       Print help."
        "   --version, -h    Print version."
        "   --save, -s       Output to 'saved.data'"
    )

    printf "%s\\n" "${txt[@]}"
}



#
# message to display when bad usage.
#
function badUsage
{
    local message="$1"
    local txt=(
"For an overview of the commands, execute:"
"$SCRIPT --help, -h"
    )

    [[ -n $message ]] && printf "%s\\n" "$message"

    printf "%s\\n" "${txt[@]}"
}



#
# print version.
#
function version
{
    local txt=(
"$SCRIPT version $VERSION"
    )

    printf "%s\\n" "${txt[@]}"
}



#
# save output of command to file 'saved.data'
#
function save
{
    # run script recursive with args
    ./"$SCRIPT" "$@" &> saved.data
}



#
# request /all
#
function app-all
{
    curl -s "$URL/all"
}



#
# request /names
#
function app-names
{
    curl -s "$URL/names"
}



#
# request /color/<color>
#
function app-color
{
    curl -s "$URL/color/$1"
}



#
# check server status
#
function app-test
{
    # get status code and msg
    read -r status_code status_msg < <(curl -Is "$URL" | head -n 1 | cut -f 2,3 -d ' ')

    # remove newline \r
    status_msg="${status_msg//$'\r'/}"

    # status="$( curl -Is "$URL" | head -n 1 | cut -f 2,3 -d ' ' )"
    # status_code="$( echo "$status" | cut -f 1 -d ' ' )"
    # status_msg="$( echo "$status" | cut -f 2 -d ' ' | tr -d '\r' )"
    # echo status="$status"
    # echo status_code="$status_code"
    # echo status_msg="$status_msg"
    # echo "$status_msg" | cat -v

    [[ $status_msg  == "OK" ]] && \
    echo "Server is running with status $status_code" && \
    exit 0

    echo "Server is not responding properly" && \
    exit 1
}


#
# Main function to process options
#
function main
{
    while (( $# )); do
        case "$1" in
            ( --help | -h )
                usage
                exit 0
            ;;

            ( --version | -v )
                version
                exit 0
            ;;

            ( --save | -s )
                shift
                save "$@"               # run save with remaining args
                exit 0
            ;;

            ( all | names | color | test )
                command=$1
                shift
                app-"$command" "$@"     # run app-function with remaining args
                exit 0
            ;;

            ( * )
                badUsage "Option/command not recognized."
                exit 1
            ;;
        esac
    done

    badUsage
}

# run main with args
main "$@"
exit 1
