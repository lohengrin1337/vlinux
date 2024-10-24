#!/usr/bin/env awk

###
### Convert logfile to JSON
###



#
# variables and file creation
#
BEGIN {
    # set outputFile from passed variable 'OutputFileName', else default
    outputFile = OutputFileName ? OutputFileName : "default.json"

    # capture matching ip, day, month, time and url (case-insensitive), from each line of log-file
    regex = "^([0-9.]+).*([0-9]{2})/([[:alpha:]]+)/[0-9]{4}:([0-9]{2}:[0-9]{2}:[0-9]{2}).*(https?://(www[.])?[[:alnum:].]+)"
    IGNORECASE = 1

    firstIteration = 1                # true until first iteration is done

    print "[" > outputFile            # opening square bracket of json (create/replace file with '>')
}

#
# body - iterate all rows of the file
#
{
    # get relevant and matching data from each row
    if (match($0, regex, matches)) {
        ip = matches[1]
        day = matches[2]
        month = tolower(matches[3]) # lower case
        time = matches[4]
        url = tolower(matches[5])   # lower case

        # write data to json object
        dataToObject(ip, day, month, time, url)

        if (firstIteration) {
            firstIteration = 0          # first iteration is done
        }
    }
}

#
# close and clean up
#
END {
    print "\t}" >> outputFile         # closing bracket WITHOUT COMMA for last object
    print "]"   >> outputFile         # close array
    close(outputFile)                 # close file stream
}



#
# build json-string from row-data, and write to file
#
function dataToObject(ip, day, month, time, url) {
    jsonStr = ""

    if (!firstIteration) {
        jsonStr = jsonStr "\t},\n"      # closing bracket WITH COMMA for previous object (skip first time)
    }

    jsonStr = jsonStr "\t{\n"                               # opening bracket for current object
    jsonStr = jsonStr "\t\t\"ip\": "     "\"" ip "\",\n"   
    jsonStr = jsonStr "\t\t\"day\": "    "\"" day "\",\n"  
    jsonStr = jsonStr "\t\t\"month\": "  "\"" month "\",\n"
    jsonStr = jsonStr "\t\t\"time\": "   "\"" time "\",\n" 
    jsonStr = jsonStr "\t\t\"url\": "    "\"" url "\""      # no trailing comma

    # write to file
    print jsonStr >> outputFile         # newline added by default
}
