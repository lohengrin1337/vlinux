#!/usr/bin/env bash

##
## Main program of
## Command line interface for Mazerunner game
## Author: Olof Jönsson - oljn22
##

# source global variables
source "src/variables.bash"

# source print- and parse functions
source "src/utils.bash"

# source function for maze-server requests
source "src/request.bash"

# source verifying functions
source "src/verifiers.bash"

# source functions for error handling
source "src/error_handler.bash"

# source core functions
source "src/core.bash"

# source game loop
source "src/game_loop.bash"

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
                pretty_print "${PRETTY_PRINT[@]}"
                exit 0
            ;;

            ( loop )
                game_loop
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
