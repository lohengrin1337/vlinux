#!/usr/bin/env awk

###
### Convert logfile to JSON
###

#
# write row-data to json object
#
function dataToObject(ip, day, month, time, url) {
    objStr = ""

    if (!firstIteration) {
        objStr += "\t},\n"    # closing bracket WITH COMMA for previous object
    }

    # put data in json structure
    objStr += "\t{\n"
    objStr += "\t\t\"ip\": "     "\"" ip "\",\n"
    objStr += "\t\t\"day\": "    "\"" day "\",\n"
    objStr += "\t\t\"month\": "  "\"" month "\",\n"
    objStr += "\t\t\"time\": "   "\"" time "\",\n"
    objStr += "\t\t\"url\": "    "\"" url "\"\n"

    return objStr
}

#
# variables and file creation
#
BEGIN {
    # set outputFile from passed variable 'OutputFileName', else default
    outputFile = OutputFileName ? OutputFileName : "default.json"

    # capture matching ip, day, month, time and url
    regex = "^([0-9.]+).*([0-9]{2})/([[:alpha:]]+)/[0-9]{4}:([0-9]{2}:[0-9]{2}:[0-9]{2}).*(https?://(www[.])?[[:alnum:].]+)"

    objects[1] = ""
    firstIteration = 1                # true until first iteration is done
    count = 0

    test = ""
    test += "a string"
    print test

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
    }

    # write data to json object
    objects[count++] = dataToObject(ip, day, month, time, url)

    if (firstIteration) {
        firstIteration = 0          # first iteration is done
    }

}

#
# close and clean up
#
END {
    # opening square bracket of json (create/replace file with '>')
    print "[" > outputFile

    # all objects
    for (key in objects) {
        print objects[key] >> outputFile
    } 

    print "\t}" >> outputFile         # closing bracket WITHOUT COMMA for last object
    print "]"   >> outputFile         # close array

    close(outputFile)                 # close file stream
}
