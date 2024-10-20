#!/usr/bin/env bash

##
## Validation for log client
##


#
# validate filters
#
function verify_filters
{
    local -a invalid_filters
    local regex

    # get list of valid filters from log-server
    request_log_server "/filters"
    VALID_FILTERS="$( jq -r '.[]' "$RESPONSE_TEMP")"

    # check every second argument (the filters)
    while (( $# )); do
        regex="\b$1\b"
        [[ ! $VALID_FILTERS =~ $regex ]] && invalid_filters+=("'$1'")
        shift && shift
    done

    # exit with message if any invalid filters
    [[ ${#invalid_filters[@]} -ne 0 ]] && \
        badUsage "" "Invalid filters for view: ${invalid_filters[*]}" 
}



#
# check if response is OK (code 200 = 0 = true)
#
function response_is_ok
{
    # use grep to match '200' in top line of header
    head -n 1 "$RESPONSE_TEMP" | grep -E "\b200\b" &> "/dev/null"
}
