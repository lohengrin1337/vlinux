#!/usr/bin/env bash

##
## Main module of
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
source "src/error_handlers.bash"

# source functions for error handling
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
                app_usage
                exit 0
            ;;

            ( --version | -v )
                app_version
                exit 0
            ;;

            ( --count | -c )
                shift
                [[ $1 != "view" ]] && \
                    badUsage "$*" "Usage for '--count' option: '$0 --count view <filter> <value>'"
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

            ( * )
                badUsage "$1"
            ;;
        esac
    done

    badUsage
}



# run main with arguments
main "$@"
