#!/usr/bin/env bash
#
# create docker network 'dbwebb' (bridge network)
# run mazeserver on dbwebb (custom node server with access to a maze game)
# run mazeclient on dbwebb (script to run the maze-game, accessing the mazeserver)
# stop containers
# remove network
#
# author: Olof Jönsson
#

SCRIPT=$( basename "$0" )
USAGE="Usage: $SCRIPT"
HELP=(
        "Script $SCRIPT to run two docker containers on a network, and play mazerunner"
        "$USAGE"
        "Options:"
        "  --help | -h      Print help "
)

# handle options
case "$1" in
    ( --help | -h )
        printf "%s\\n" "${HELP[@]}"
        exit 0
    ;;
esac

# check if Docker is running
if ! docker -v &> "/dev/null"; then
    echo "Please start Docker before running $SCRIPT!"
    exit 1
fi

# set variables
NETWORK="dbwebb"
SERVER_IMAGE="lohengrin1337/vlinux-mazeserver:1.0"
# CLIENT_IMAGE="lohengrin1337/vlinux-mazeclient:1.0"
CLIENT_IMAGE="client-kmom06"
SERVER_CONTAINER="maze-server"
CLIENT_CONTAINER="maze-client"
OUTSIDE_PORT="${DBWEBB_PORT:-8080}"
INSIDE_PORT="1337"
URL="http://localhost:$OUTSIDE_PORT"

#
# handle cleanup and exit with error code
#
function cleanup_and_exit
{
    local exit_code="${1:-0}"

    # stop and remove client-container if running
    if docker ps | grep -ow "$CLIENT_CONTAINER" > /dev/null; then
        docker stop "$CLIENT_CONTAINER" > /dev/null
        echo "Mazerunner-client closed and removed"
    fi

    # stop and remove server-container if running
    if docker ps | grep -ow "$SERVER_CONTAINER" > /dev/null; then
        docker stop "$SERVER_CONTAINER" > /dev/null
        echo "Mazerunner-server closed and removed"
    fi

    # stop and remove network if existing
    if docker network ls | grep -ow "$NETWORK" > /dev/null; then
        docker network rm "$NETWORK" > /dev/null
        echo "$NETWORK network removed"
    fi

    exit "$exit_code"
}


# create network, and check status
if ! docker network create "$NETWORK"; then
    echo "Failed to create network!"
    cleanup_and_exit 1
fi

# run maze server (detached mode), and check status
if ! docker run -d --rm \
    --name "$SERVER_CONTAINER" \
    --net $NETWORK \
    -p "$OUTSIDE_PORT:$INSIDE_PORT" \
    "$SERVER_IMAGE"
then
    # fail
    echo "Failed to run maze server!"
    cleanup_and_exit 1
fi

# success
echo "Mazerunner-server is running from container '$SERVER_CONTAINER', accessible from '$URL'"
echo "Starting Mazerunner-client from container '$CLIENT_CONTAINER'"

# run maze client (interactive mode), and check status
if ! docker run -it --rm \
    --name "$CLIENT_CONTAINER" \
    --net $NETWORK \
    --link "$SERVER_CONTAINER:$SERVER_CONTAINER" \
    -v "$(pwd)/maze2/client/mazerunner.bash:/client/mazerunner.bash" \
    -v "$(pwd)/maze2/client/src:/client/src" \
    "$CLIENT_IMAGE"
then
    # fail
    echo "Mazerunner-client closed and removed"
    cleanup_and_exit 1
fi

# container removed when exiting client-container
echo "Mazerunner-client closed and removed"

# clean up an exit with status 0
cleanup_and_exit 0
