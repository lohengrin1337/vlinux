#!/usr/bin/env bash

##
## Main program of
## Bthloggen client
## Author: Olof Jönsson - oljn22
##

# source client.conf if exists (contains global CUSTOM_HOST=<name set with command 'use'>)
# shellcheck disable=SC1091
[[ -f "client.conf" ]] && source "client.conf"

# source global variables
source "src/variables.bash"

# source print- and parse functions
source "src/utils.bash"

# source functions for error handling
source "src/error_handler.bash"

# source verifying functions
source "src/verifiers.bash"

# source function for log-server requests
source "src/request.bash"

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

            ( --count | -c )
                shift
                [[ $1 != "view" ]] && badUsage "$*"
                shift
                app_count_view "$@"
                exit 0
            ;;

            ( use | url | view )
                command="$1"
                shift
                app_"$command" "$@"     # run app_function with remaining args
                exit 0
            ;;

            ( test )

                # request_log_server "/data"
                request_log_server "/"

                cat $RESPONSE_TEMP

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
