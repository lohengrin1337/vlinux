#!/usr/bin/env bash

##
## Global variables for bthloggen client
##

# name of the script
name=$( basename "$0" )
export SCRIPT="$name"

# current version
export VERSION="1.0.0"

# name of the config file
export CONFIG_FILE="client.conf"

# host and port of log-server
export HOST="${CUSTOM_HOST:-log-server}"
export PORT="8000"
export BASE_URL="$HOST:$PORT"

# url for accessing log-server via browser
export PUBLIC_URL="http://localhost:8080/"

# define color codes
export GREEN="\033[0;32m"
export RED="\033[0;31m"
export NO_COLOR="\033[0m"

# query string set by 'build_query'
export QUERY_STRING

# create temp file to store large response, and clean up with 'trap' when script exits
temp_file=$(mktemp)
export RESPONSE_TEMP="$temp_file"
trap 'rm -f "$RESPONSE_TEMP"' EXIT

# count of entries
export COUNT

# multiplied string set by 'multiply_str'
export MULTIPLIED_STR

# array with text strings to print with pretty_print
declare -a PRETTY_PRINT
export PRETTY_PRINT
