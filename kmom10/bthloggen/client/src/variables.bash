#!/usr/bin/env bash

##
## Global variables for bthloggen client
##

# Name of the script
name=$( basename "$0" )
export SCRIPT="$name"

# Current version
export VERSION="1.0.0"

# host and port of log-server
export HOST="${CUSTOM_HOST:-log-server}"
export PORT="8000"
export BASE_URL="$HOST:$PORT"

# Define color codes
export GREEN="\033[0;32m"
export RED="\033[0;31m"
export NO_COLOR="\033[0m"

# response from log-server set by 'request_log_server'
export RESPONSE

# array with text strings to print with pretty_print
declare -a PRETTY_PRINT
export PRETTY_PRINT
