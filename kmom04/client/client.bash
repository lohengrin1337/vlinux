#!/usr/bin/env bash
#
# Script to test an express/flask server
#
# Exit values:
#  0 on success
#  1 on failure
#


# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"


# Port and url of express/flask dev server
PORT=${DBWEBB_PORT:-8080}
URL="http://localhost:$PORT"

# Define color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
NO_COLOR="\033[0m"


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
        "   all              Request /all               present all plants"
        "   names            Request /names             present all names"
        "   color <color>    Request /color/<color>     present matching plants"
        "   test <url>       Test server                get current status"
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
    ./"$0" "$@" &> "saved.data"
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
    # request url, and get header or error message
    if header=$( curl -IsS "$URL" 2>&1 ); then
        top_line=$( echo "$header" | head -n 1 | sed 's/\r//g' )    # top line of header without newline
        status_code=$( echo "$top_line" | cut -f 2 -d ' ' )         # cut out status code
        status_msg=$( echo "$top_line" | cut -f 3- -d ' ' )         # cut out status text

        local msg="Server is responding with status $status_code ($status_msg), when requesting $URL"

        # success
        [[ $status_code  == "200" ]] && \
            echo -e "${GREEN}$msg${NO_COLOR}" && \
            exit 0

        # failure
        echo -e "${RED}$msg${NO_COLOR}" && \
        exit 1
    fi

    # error message from curl, when failing to request url
    error=$header   # catched in header variable due to '2>&1'

    error_msg=$( echo "$error" | cut -f 10- -d ' ')     # cut out last part

    echo -e "${RED}Curl failed when requesting '$URL'!\nError: $error_msg${NO_COLOR}" && \
    exit 1


    # # get status code and msg
    # read -r status_code status_msg < <(curl -Is "$URL" | head -n 1 | cut -f 2,3 -d ' ')

    # # remove newline \r
    # status_msg="${status_msg//$'\r'/}"
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
