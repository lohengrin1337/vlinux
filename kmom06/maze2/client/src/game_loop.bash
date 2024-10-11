#!/usr/bin/env bash

###
### Game loop for one continous game
###


function game_loop
{
    # unset globas from .game_config
    clean_up

    # init a new game
    app_init

    # get maps
    app_maps

    # print header and info
    pretty_print \
        "${MESSAGES["welcome"]}" \
        "${MESSAGES["init"]}" \
        "${MESSAGES["maps"]}" \
        "${MAP_SELECTION[@]}" \

    while true; do
        # prompt user to select map or help / quit
        echo -e "    Select a map (enter a number, or 'help'):"
        read -r -p "    --> " mapNumber

        # handle user input
        case "$mapNumber" in
            ( "help" )
                # print usage and help
                usage
            ;;

            ( "quit" )
                # quit
                exit_friendly
            ;;

            ( * )
                # validate user input
                ! map_selection_is_valid "$mapNumber" && \
                    pretty_print -red "${MESSAGES["invalid_map"]}" && \
                    continue

                # select the map, and break while-loop
                app_select "$mapNumber"
                break
            ;;
        esac
    done

    # enter maze
    app_enter

    # print info
    pretty_print \
        "You have entered ${SELECTED_MAP%.json}" \
        "${ROOM_INFO["description"]}" \
        "${ROOM_INFO["valid_directions"]}"

    while ! exit_is_found; do
        # promt user for a direction or info / help / quit
        echo -e "    Move to the next room (enter a direction, or 'help'):"
        read -r -p "    --> " direction

        # handle user input
        case "$direction" in
            ( "help" )
                # print help
                usage
            ;;

            ( "quit" )
                # quit
                exit_friendly
            ;;

            ( "info" )
                # get room info
                app_info

                # print info
                pretty_print \
                    "${ROOM_INFO_PRINT[@]:0:2}"
            ;;

            ( * )
                # validate user input
                ! direction_is_valid "$direction" && \
                    pretty_print -red "${MESSAGES["invalid_direction"]}" && \
                    continue

                # try to move in a direction
                app_go "$direction"

                # check move was made successfully
                ! response_is_ok && \
                    pretty_print -red "${MESSAGES["invalid_door"]}" && \
                    continue

                # print new room info
                pretty_print \
                    "${ROOM_INFO_PRINT[@]:0:2}"
            ;;
        esac
    done

    # game is over, leave loop
    exit_friendly
}
