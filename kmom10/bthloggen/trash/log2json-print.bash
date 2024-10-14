#!/usr/bin/env bash

###
### Convert server log-file 'access-50k.log' to JSON, using awk script '2json.awk'
###
### Get the following data from each (matching) line of the log-file:
###
### ip-adress (1.111.11.111)
### day (01),
### month (Jan),
### time (01:01:01),
### url (https://www.example.com)
###
### export to '/data/log.json' in following format:
### 
### [
###     {
###         "ip": "1.111.11.111",
###         "day": "01",
###         "month": "Jan",
###         "time": "01:01:01",
###         "url": "https://www.example.com"
###     }, ...
### ]
###

# LOG_FILE="small.log"
LOG_FILE="access-50k.log"
AWK_SCRIPT="2json-print.awk"
# AWK_SCRIPT="2json-improve.awk"
DESTINATION="data/log.json"

echo -e "\n  Converting '$LOG_FILE' to '$DESTINATION'\n"

# capture start time
start_ms=$(date +%s%3N)

# run AWK_SCRIPT with LOG_FILE to DESTINATION
awk -f "$AWK_SCRIPT" "$LOG_FILE" > "$DESTINATION"

# calc and convert duration
end_ms=$(date +%s%3N)
duration_ms=$(( $end_ms - $start_ms ))
duration_s=$(bc <<<"scale=2; $duration_ms / 1000")

echo -e "  Finished in $duration_s seconds\n"
