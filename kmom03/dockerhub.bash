#!/usr/bin/env bash
#
# Run apache2 server from docker container on localhost,
# and serve a volume at 'http://mysite.vlinux.se:8080/' (or specified port)
# author: Olof Jönsson
#

USAGE="Usage: $0 'path-to-site-folder' [incoming port ('8080' by default)]"

# Check if Docker is running
if ! command -v docker &> /dev/null; then
    echo "Please install/start Docker before running script!"
    exit 1
fi

# Check first argument
if [[ -z $1 ]]; then
    echo "Run script with path to your site-folder as argument!"
    echo $USAGE
    exit 1
fi

# Print usage
[[ $1 = "-h" || $1 = "--help" ]] && echo $USAGE && exit 0

CURRENT_DIR="$(pwd)"
SITE_FOLDER="$1"
CONTAINER_NAME="$(basename "$SITE_FOLDER")"
DOCKER_PORT_MAPPING="${2:-8080}:80" # defaults to '8080:80' if no $2
DOCUMENT_ROOT="/var/www/vhosts/mysite.vlinux.se"
DOCKER_HOST_ENTRY="mysite.vlinux.se:127.0.0.1"
DOCKER_IMAGE="lohengrin1337/vlinux-vhost:1.0"

# Check site folder
if [[ ! -d "$SITE_FOLDER" ]]; then
    echo "The site-folder '$SITE_FOLDER' does not exist!"
    echo $USAGE
    exit 1
fi

# Run server
docker run -d --rm \
    --name "$CONTAINER_NAME" \
    -p "$DOCKER_PORT_MAPPING" \
    -v "$CURRENT_DIR"/"$SITE_FOLDER":"$DOCUMENT_ROOT" \
    --add-host "$DOCKER_HOST_ENTRY" \
    "$DOCKER_IMAGE"

# Check exit status of docker run
if [[ $? -ne 0 ]]; then
    echo "Failed to run Docker container"
    exit 1
fi

# Success
echo "Success: Your site is being served at http://mysite.vlinux.se:${2:-8080}/ from container '$CONTAINER_NAME'"
