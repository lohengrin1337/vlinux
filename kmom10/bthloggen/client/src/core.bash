#!/usr/bin/env bash

##
## Core functions for log client
##



#
# set hostname of server to use
#
function app_use
{
    local host_name="$1"

    echo -e "CUSTOM_HOST=\"$host_name\"" >> "$CONFIG_FILE"

    pretty_print "You are using '$host_name' as server host"
}



#
# show the url to access the log-server from browser
#
function app_url
{
    pretty_print "URL to access log-server from browser:" "$PUBLIC_URL"
}



#
# list entries, with or without filters (ip, url, month, day, time)
#
function app_view
{
    # build a query string (filters) from the arguments
    build_query "$@"

    # request 'log-server/data' with the query
    request_log_server "/data${QUERY_STRING}"

    # convert json response to csv with jq
    entries2csv

    # convert csv to formated table with awk
    csv2table

    # build pretty version of filters
    stringify_filters "$@"

    # print table
    pretty_print -header -table \
        "\t<<< VIEW MATCHING ENTRIES ($FILTERS) >>>" \
        $RESPONSE_TEMP
}



#
# count matches of view command
#
function app_count_view
{
    local filters

    # build a query string (filters) from the arguments
    build_query "$@"

    # request 'log-server/data' with the query
    request_log_server "/data${QUERY_STRING}"

    # count matching entries
    count_entries

    # build pretty version of filters
    stringify_filters "$@"

    # print count
    pretty_print -header \
        "\t<<< COUNT MATCHING ENTRIES ($FILTERS) >>>" \
        "COUNT: $COUNT"
}
