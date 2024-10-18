#!/usr/bin/env bash

##
## Print- and parsing functions for mazerunner cli
##



#
# multiply a string n times
#
function multiply_str
{
    local str n res
    str="$1"
    n=$2
    res=""

    for ((i = 0; i < n; i++)) {
        res="$res$str"
    }

    export MULTIPLIED_STR="$res"
}



#
# print each argument with frame, color and spacing, or print a table from file
#
function pretty_print
{
    local color top bottom header table file_to_print

    color="$GREEN"
    [[ $1 = "-red" ]] && color="$RED" && shift

    header="false"
    [[ $1 = "-header" ]] && header="true" && shift

    table="false"
    [[ $1 = "-table" ]] && table="true" && shift

    multiply_str "=" 85

    top="${color}${MULTIPLIED_STR}${NO_COLOR}\n"
    bottom="${color}${MULTIPLIED_STR}${NO_COLOR}"

    echo -e "$top"
    [[ $header = "true" ]] && echo -e "${color}${1}${NO_COLOR}\n" && shift

    if [[ $table = "true" ]]; then
        file_to_print="$1"
        cat "$file_to_print"
        echo -e "\n$bottom"
    else
        printf "\t%s\n\n" "$@"
        echo -e "$bottom"
    fi
}



#
# Message to display for usage and help.
#
function usage
{
    local txt=(
        "<<< HELP >>>"
        "Usage: $0 [options] <command> [arguments]"
        "Tip: You can use multiple filters with view ( e.g. 'view ip <ip> url <url> time <time>')"
        ""
        "Commands:"
        "   use <server>            Set hostname of server to use ('log-server', 'localhost' etc)"
        "   url                     Show url for browser access"
        "   view                    List all entries"
        "   view ip <ip>            Filter entries on ip (substring, case-insensitive)"
        "   view url <url>          Filter entries on url (substring, case-insensitive)"
        "   view month <month>      Filter entries on month (case-insensitive)"
        "   view day <day>          Filter entries on day (leading zero)"
        "   view time <time>        Filter entries on time ('hh' or 'hh:mm' or 'hh:mm:ss')"
        ""
        "Options:"
        "   --help, -h              Show help"
        "   --version, -v           Show version"
        "   --count, -c             Show the count of matching entries (e.g. '-c view url <url>')"
    )

    pretty_print -header "${txt[@]}"
}



#
# print version
#
function version
{
    pretty_print -header "<<< VERSION >>>" "$SCRIPT version $VERSION"
}



#
# build query string from commmand line arguments (ip 555 -> ip=555 etc)
#
function build_query
{
    local query=""

    while (( $# )); do
        [[ ${#query} = 0 ]] && query+="?"
        [[ ${#query} > 1 ]] && query+="&"
        query+="$1="
        shift
        query+="$1"
        shift
    done

    export QUERY_STRING="$query"
}



#
# count entries with jq
#
function count_entries
{
    COUNT="$(jq '. | length' "$RESPONSE_TEMP")"
    export COUNT
}



#
# convert entries to csv (without header) ip, url, month, day, time
#
function entries2csv
{
    temp=$(mktemp)
    jq -r '.[] | "\(.day), \(.month), \(.time), \(.ip), \(.url)"' "$RESPONSE_TEMP" > "$temp"
    mv "$temp" "$RESPONSE_TEMP"
}



#
# convert csv to printable table format
#
function csv2table
{
    awk_script="src/csv2table.awk"
    input_file="$RESPONSE_TEMP"

    temp=$(mktemp)
    awk -f $awk_script $input_file > $temp
    mv $temp $RESPONSE_TEMP
}



#
# convert one-line json string to valid formated json
#
function entries2json
{
    temp=$(mktemp)
    jq -r . "$RESPONSE_TEMP" > "$temp"
    mv "$temp" "$RESPONSE_TEMP"
}



#
# stringify filter arguments (url www.xxx.xx ip 555 => "url:www.xxx.xx, ip:555")
#
function stringify_filters
{
    local filters

    while (( $# )); do
        filters+="$1: '$2', "
        shift
        shift
    done

    filters=${filters%, }

    [[ -z $filters ]] && filters="no filters"

    export FILTERS="$filters"
}