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
"  lower <n n n...>             Print any positive integers below 42."
"  reverse <random sentence>    Print argument in reverse."
"  all                          Run all commands with default args."
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
    cal
}



#
# print uptime (runtime of system)
#
function app-uptime
{
    uptime -p
}



#
# print greeting to user. change phrase depenfing on time
#
function app-greet
{
    # current hour 0-23 (integer)
    declare -i current_hour
    current_hour="$(date +%k)"

    # test
    # current_hour="$(date -d '05:59' +%k)"
    # declare -p current_hour

    # morning 6-12am
    greeting="Good morning"

    # afternoon 12-18pm
    [[ $current_hour -ge 12 && $current_hour -le 17 ]] && greeting="Good afternoon"

    # evening 18-24pm
    [[ $current_hour -ge 18 && $current_hour -le 23 ]] && greeting="Good evening"

    # night 0-6am
    [[ $current_hour -ge 0 && $current_hour -le 5 ]] && greeting="Good night"

    [[ -n "$USER" ]] && user="$USER" || user="Anonymous"

    echo "$greeting $user!"
}



#
# print integers of interval specified
#
function app-loop
{
    declare -i min="$1"
    declare -i max="$2"

    # declare -p min
    # declare -p max

    for num in $(seq "$min" "$max"); do
        echo "$num"
    done

    # for (( i=$min; i<=$max; i++ )); do
    #     echo $i
    # done
}



#
# print any integers lower than 42
#
function app-lower
{
    declare -a integers_below_42    # below 42
    regex="^-?[0-9]+$"              # only (+/-) integers, at least one digit

    for val in "$@"; do
        [[ $val =~ $regex && $val -lt 42 ]] && integers_below_42+=("$val")
    done

    echo "Numbers below 42 are: ${integers_below_42[*]}"
}



#
# print argument reverse
#
function app-reverse
{
    scentence="$*"
    rev_scentence=$(echo "$scentence" | rev)

    echo "$rev_scentence"
}



#
# print all commands with hard coded args
#
function app-all
{
    echo -e "<<< RUNNING ALL COMMANDS >>>"

    local info=(
        "Print calendar:"
        "Print uptime:"
        "Print greeting:"
        "Print loop (1-10):"
        "Print integers below 42 (100 4 41 42 -44):"
        "Print 'was I tac a ro rac a ti saw' reverse:"
    )

    local funcs=(
        cal
        uptime
        greet
        loop
        lower
        reverse
    )

    local args=(
        ""
        ""
        ""
        "1 10"
        "100 4 41 42 -44"
        "was I tac a ro rac a ti saw"
    )


    # loop through funcs
    for i in "${!funcs[@]}"; do
        echo -e "\n${info[$i]^^}"           # newline + info in uppercase

        # shellcheck disable=SC2086
        app-"${funcs[$i]}" ${args[$i]}      # function plus arg(s)
    done
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
