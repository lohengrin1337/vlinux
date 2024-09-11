#!/usr/bin/env bash
#
# A template for creating command line scripts taking options, commands
# and arguments.
#
# Exit values:
#  0 on success
#  1 on failure
#


# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"



#
# Message to display for usage and help.
#
function usage
{
    local txt=(
"Utility $SCRIPT for printing some simple things."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Commands:"
"  cal                          Print calendar."
"  uptime                       Print uptime (runtime of system)."
"  greet                        Greet user."
"  loop <min> <max>             Print integers of interval."
"  lower <n n n...>             Print any nums lower than 42."
"  reverse <random sentence>    Print reverse (quote the string)."
"  all                          Print all commands with default args."
""
"Options:"
"  --help, -h     Print help."
"  --version, -h  Print version."
    )

    printf "%s\\n" "${txt[@]}"
}



#
# message to display when bad usage.
#
function badUsage
{
    local message="$1"
    local txt=(
"For an overview of the commands, execute:"
"$SCRIPT --help"
    )

    [[ -n $message ]] && printf "%s\\n" "$message"

    printf "%s\\n" "${txt[@]}"
}



#
# print version.
#
function version
{
    local txt=(
"$SCRIPT version $VERSION"
    )

    printf "%s\\n" "${txt[@]}"
}



#
# print calendar
#
function app-cal
{
    echo "This is output from cal."

    cal
}



#
# print uptime (runtime of system)
#
function app-uptime
{
    echo "This is output from uptime"

    uptime -p
}



#
# print greeting to user. change phrase depenfing on time
#
function app-greet
{
    echo "This is output from greet"

    # current hour 0-23
    current_hour="$(date +%k)"

    # test
    # current_hour="$(date -d '00:59' +%k)"

    # morning 6-12am
    greeting="Good morning"

    # afternoon 12-18pm
    [[ $current_hour -ge 12 && $current_hour -le 17 ]] && greeting="Good afternoon"

    # evening 18-24pm
    [[ $current_hour -ge 18 && $current_hour -le 23 ]] && greeting="Good evening"

    # night 0-6am
    [[ $current_hour -ge 0 && $current_hour -le 5 ]] && greeting="Good night"

    echo "$greeting $USER!"
}



#
# print integers of interval specified
#
function app-loop
{
    echo -e "This is output from loop.\nArg1: $1 \nArg2: $2 \nNr of args: $#"

    declare -i min=$1
    declare -i max=$2

    for i in {$min..$max}; do
        echo "$i"
    done
}



#
# print any integers lower than 42
#
function app-lower
{
    echo -e "This is output from lower.\nArgs: $*"
}



#
# print argument reverse
#
function app-reverse
{
    echo -e "This is output from reverse.\nArg1: $1\nAll Args: $*"
}



#
# print all commands with hard coded args
#
function app-all
{
    echo "This is output from all."
}



#
# Process options
#
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

        ( cal | uptime | greet | loop | lower | reverse | all )
            command=$1
            shift
            app-"$command" "$@"
            exit 0
        ;;

        ( * )
            badUsage "Option/command not recognized."
            exit 1
        ;;

    esac
done

badUsage
exit 1
