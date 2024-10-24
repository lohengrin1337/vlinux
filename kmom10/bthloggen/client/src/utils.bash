#!/usr/bin/env bash

##
## Print- and parsing functions for log client
##



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

    MULTIPLIED_STR="$res"
}



#
# handle filters for view
# verify, build query, build pretty string
#
function handle_filters
{
    verify_filters "$@"
    build_query "$@"
    stringify_filters "$@"
}



#
# build query string from commmand line arguments (ip 555 day 15 => "?ip=555&day=15")
#
function build_query
{
    local query=""

    while (( $# )); do
        [[ ${#query} -eq 0 ]] && query+="?"
        [[ ${#query} -gt 1 ]] && query+="&"
        query+="$1="
        shift
        query+="$1"
        shift
    done

    QUERY_STRING="$query"
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

    # remove trailing ', '
    filters=${filters%, }

    [[ -z $filters ]] && filters="no filters"

    FILTERS="$filters"
}



#
# count entries with jq
#
function count_entries
{
    COUNT="$(jq '. | length' "$RESPONSE_TEMP")"
}


#
# convert json response to formated table
#
function entries2table
{
    # json to csv with jq (modify $RESPONSE_TEMP)
    entries2csv

    # csv to formated table with awk (modify $RESPONSE_TEMP)
    csv2table
}




#
# convert entries to csv (without header) day, month, time, ip, url
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
    awk -f "$awk_script" "$input_file" > "$temp"
    mv "$temp" "$RESPONSE_TEMP"
}
