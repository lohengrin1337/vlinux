#!/usr/bin/env bash

##
## Main program of
## Bthloggen client
## Author: Olof Jönsson - oljn22
##

# source .custom_host if exists (contains global CUSTOM_HOST=<name set with command 'use'>)
# shellcheck disable=SC1091
[[ -f ".custom_host" ]] && source ".custom_host"

# source global variables
source "src/variables.bash"

# source print- and parse functions
source "src/utils.bash"

# source function for log-server requests
source "src/request.bash"

# source functions for error handling
source "src/error_handler.bash"

# source core functions
source "src/core.bash"



#
# process options, commands and arguments
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

            ( url | view | use )
                command=$1
                shift
                app_"$command" "$@"     # run app_function with remaining args
                exit 0
            ;;

            ( test )
                request_log_server "/data?time=15:15"
                # request_log_server "/"

                # RESPONSE='[{"ip":"3.173.201.120","day":"15","month":"aug","time":"15:15:15","url":"https://dbwebb.se"}]'

                pretty_jq=$( echo "$RESPONSE" | jq -r . )
                echo "$pretty_jq"
                exit 0
            ;;

            ( * )
                badUsage "$1"
            ;;
        esac
    done

    badUsage
}



# run main with arguments
main "$@"
