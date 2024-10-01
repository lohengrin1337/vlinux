#!/usr/bin/env bash

##
## Main program of
## Command line interface for Mazerunner game
## Author: Olof Jönsson - oljn22
##

# source global variables
source "variables.bash"

# source util functions
source "utils.bash"

# source core functions (app_xxx)
source "core.bash"

# source .game_config if exists (globals GAME_ID, ROOM_ID and MAPS_AVAILABLE)
# shellcheck disable=SC1091
[[ -f ".game_config" ]] && source ".game_config"



#
# process arguments
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

            ( init | maps | select | enter | info | go )
                command=$1
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
