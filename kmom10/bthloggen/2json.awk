#!/usr/bin/env awk

###
### Convert logfile to JSON
###

#
# write row-data to json object
#
function dataToObject(ip, day, month, time, url) {
    if (!firstIteration) {
        print "\t}," >> outputFile    # closing bracket WITH COMMA for previous object (skip first time)
    }

    print "\t{"                                 >> outputFile # opening bracket for current object
    print "\t\t\"ip\": "     "\"" ip "\","      >> outputFile
    print "\t\t\"day\": "    "\"" day "\","     >> outputFile
    print "\t\t\"month\": "  "\"" month "\","   >> outputFile
    print "\t\t\"time\": "   "\"" time "\","    >> outputFile
    print "\t\t\"url\": "    "\"" url "\""      >> outputFile # no trailing comma
}

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
        month = matches[3]
        time = matches[4]
        url = matches[5]

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
