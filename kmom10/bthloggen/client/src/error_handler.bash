#!/usr/bin/env bash

##
## Error handling for mazerunner cli
##



#
# message to display when bad usage.
#
function badUsage
{
    local message="${2:-"Option/command/argument '$1' was not recognized"}"
    local txt=(
        "$message"
        "For an overview of the commands, execute:"
        "$0 --help"
    )

    pretty_print -red "${txt[@]}"
    exit 1
}



#
# handle error from curl
#
function curl_error
{
    # local txt=(
    #     "Curl failed when requesting '$1'"
    #     "Message from curl: $RESPONSE"
    # )


    local txt=(
        "Curl failed when requesting '$1'"
        "Message from curl: $(cat "$RESPONSE_TEMP")"
    )

    pretty_print -red "${txt[@]}"
    exit 1
}



#
# handle response error
#
function response_error
{
    local code url detail txt

    url="$1"

    # parse code from header, and detail from body
    # code="$(head -n 1 <<<"$RESPONSE" | grep -Eo "[0-9]{3}")"
    # detail="$( tail -n 1 <<<"$RESPONSE" | jq -r '.detail')"

    code="$(head -n 1 "$RESPONSE_TEMP" | grep -Eo "[0-9]{3}")"
    detail="$( tail -n 1 "$RESPONSE_TEMP" | jq -r '.detail')"

    case "$detail" in
        ( "Not Found" )
            txt+=(
                "Log-server: Page Not Found"
                "Requested resource: '$url'"
            )
        ;;

        ( * )
            txt+=(
                "Something went wrong!"
                "Log-server: Response code: $code"
                "Log-server: Detail: $detail"
                "Requested resource: '$url'"
            )
    esac

    txt+=("Print help with '$SCRIPT --help'")

    pretty_print -red "${txt[@]}"
    exit 1
}
