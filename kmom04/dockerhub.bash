#!/usr/bin/env bash
#
# Run express server from docker container on localhost,
# and serve a volume at 'localhost:1337/' (or DBWEBB_PORT)
# author: Olof Jönsson
#

SCRIPT=$( basename "$0" )
USAGE="Usage: $SCRIPT <path-to-volume> [--flask]"

# Check if Docker is running
if ! command -v docker &> /dev/null; then
    echo "Please install/start Docker before running script!"
    exit 1
fi

# Check first argument
if [[ -z $1 ]]; then
    echo "Run script with path to your volume as argument!"
    echo "$USAGE"
    exit 1
fi

# Print usage
[[ $1 = "-h" || $1 = "--help" ]] && echo "$USAGE" && exit 0

# set optional flask-image if $2 = --flask
if [[ -n $2 && $2 = "--flask" ]]; then
    DOCKER_IMAGE="lohengrin1337/vlinux-server-flask:1.0"
    FLASK_PORT="5000"
    FLASK="Flask"
fi

CURRENT_DIR="$(pwd)"
SITE_FOLDER="$1"
CONTAINER_NAME="myserver"
OUTSIDE_PORT="${DBWEBB_PORT:-${FLASK_PORT:-1337}}" # dbwebb / flask / 1337 (express)
INSIDE_PORT="${FLASK_PORT:-1337}"
URL="http://localhost:$OUTSIDE_PORT"
DOCUMENT_ROOT="/server/data"
DOCKER_IMAGE="${DOCKER_IMAGE:-lohengrin1337/vlinux-server:1.0}"
SERVER_NAME="${FLASK:-express}"

# Check site folder
if [[ ! -d "$SITE_FOLDER" ]]; then
    echo "The volume '$SITE_FOLDER' does not exist!"
    echo "$USAGE"
    exit 1
fi

# Run server, and check status
if ! docker run -d --rm \
    --name "$CONTAINER_NAME" \
    -p "$OUTSIDE_PORT:$INSIDE_PORT" \
    -v "$CURRENT_DIR/$SITE_FOLDER:$DOCUMENT_ROOT" \
    "$DOCKER_IMAGE"
then
    # Fail
    echo "Failed to run Docker image!"
    exit 1
fi

# Success
echo "Success: Your site is being served with $SERVER_NAME at '$URL' from container '$CONTAINER_NAME'"
