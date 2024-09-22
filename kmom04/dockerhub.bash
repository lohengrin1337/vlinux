#!/usr/bin/env bash
#
# Run express/Flask server from docker container on localhost,
# and serve a volume at 'localhost:8080/' (or DBWEBB_PORT)
# author: Olof Jönsson
#

SCRIPT=$( basename "$0" )
USAGE="Usage: $SCRIPT [option] <path-to-volume>"
HELP=(
        "$USAGE"
        "Options:"
        "  --help | -h      Print help "
        "  --flask          Use flask instead of express"
)

# check if Docker is running
if ! command -v docker &> /dev/null; then
    echo "Please install/start Docker before running $SCRIPT!"
    exit 1
fi

# handle options
case "$1" in
    ( --help | -h )
        printf "%s\\n" "${HELP[@]}"
        exit 0
    ;;

    ( --flask )
        FLASK_IMAGE="lohengrin1337/vlinux-server-flask:1.0"
        FLASK_PORT="5000"
        FLASK="Flask"
        shift
    ;;
esac

# check volume is existing and a valid path
VOLUME_OUTSIDE="$1"
if [[ ! -d $VOLUME_OUTSIDE ]]; then
    echo "The volume '$VOLUME_OUTSIDE' is not found!"
    echo "$USAGE"
    exit 1
fi

# set variables for express or Flask (default is express)
CURRENT_DIR="$(pwd)"
CONTAINER_NAME="myserver"
OUTSIDE_PORT="${DBWEBB_PORT:-8080}"
INSIDE_PORT="${FLASK_PORT:-1337}"
URL="http://localhost:$OUTSIDE_PORT"
VOLUME_INSIDE="/server/data"
DOCKER_IMAGE="${FLASK_IMAGE:-lohengrin1337/vlinux-server:1.0}"
SERVER_NAME="${FLASK:-express}"

# run server, and check status
if ! docker run -d --rm \
    --name "$CONTAINER_NAME" \
    -p "$OUTSIDE_PORT:$INSIDE_PORT" \
    -v "$CURRENT_DIR/$VOLUME_OUTSIDE:$VOLUME_INSIDE" \
    "$DOCKER_IMAGE"
then
    # fail
    echo "Failed to run Docker image!"
    exit 1
fi

# success
echo "Success: Your site is being served with $SERVER_NAME at '$URL' from container '$CONTAINER_NAME'"
