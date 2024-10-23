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

    pretty_print -header \
        "\t<<< UPDATE SERVER HOST >>>" \
        "You are using '$host_name' as host for log-server"
}



#
# show the url to access the log-server from browser
#
function app_url
{
    pretty_print -header \
        "\t<<< PUBLIC URL'S >>>" \
        "Log-server: $PUBLIC_URL_LOG_SERVER" \
        "Webclient: $PUBLIC_URL_WEB_CLIENT"
}



#
# list entries, with or without filters (ip, url, month, day, time)
#
function app_view
{
    # verify filters, build query, build pretty string
    handle_filters "$@"

    # request 'log-server/data' with the query, save valid response body in $RESPONSE_TEMP
    request_log_server "/data${QUERY_STRING}"

    # convert json response to formated table with jq and awk (modify $RESPONSE_TEMP)
    entries2table

    # print table
    pretty_print -header -table \
        "\t<<< VIEW MATCHING ENTRIES ($FILTERS) >>>" \
        "$RESPONSE_TEMP"
}



#
# count matches of view command
#
function app_count_view
{
    # verify filters, build query, build pretty string
    handle_filters "$@"

    # request 'log-server/data' with the query, save valid response body in $RESPONSE_TEMP
    request_log_server "/data${QUERY_STRING}"

    # count matching entries
    count_entries

    # print count
    pretty_print -header \
        "\t<<< COUNT MATCHING ENTRIES ($FILTERS) >>>" \
        "COUNT: $COUNT"
}



#
# print usage and help
#
function app_usage
{
    local txt=(
        "\t<<< USAGE AND HELP >>>"
        "Usage: $0 [options] <command> [arguments]"
        ""
        "Options:"
        "   --help, -h              Show help"
        "   --version, -v           Show version"
        "   --count, -c             Show the count of matching entries (e.g. '-c view url <url>')"
        ""
        "Commands:"
        "   use <server>            Set hostname of server to use ('log-server', 'localhost' etc)"
        "   url                     Show url for browser access"
        "   view <filter> <value>   List entries"
        ""
        "Arguments for 'view':"
        "   ip <ip>                 Filter entries on ip (substring, case-insensitive)"
        "   url <url>               Filter entries on url (substring, case-insensitive)"
        "   month <month>           Filter entries on month (case-insensitive)"
        "   day <day>               Filter entries on day (leading zero)"
        "   time <time>             Filter entries on time ('hh' or 'hh:mm' or 'hh:mm:ss')"
        ""
        "Tip: You can use multiple filters with view ( e.g. 'view ip <ip> url <url> time <time>')"
    )

    pretty_print -header "${txt[@]}"
}



#
# print version
#
function app_version
{
    pretty_print -header \
        "\t<<< VERSION >>>" \
        "$SCRIPT version $VERSION"
}
