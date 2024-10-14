#!/usr/bin/env awk

### Convert logfile to JSON ###

# write row-data to json object
function dataToObject(ip, day, month, time, url, objects, count) {
    objects[count] = "\t{\n\t\t\"ip\": \"" ip "\",\n\t\t\"day\": \"" day "\",\n\t\t\"month\": \"" month "\",\n\t\t\"time\": \"" time "\",\n\t\t\"url\": \"" url "\"\n\t}"
}

BEGIN {
    # set outputFile from passed variable 'OutputFileName' or default
    outputFile = OutputFileName ? OutputFileName : "default.json"

    # capture matching ip, day, month, time, and url
    regex = "^([0-9.]+).*([0-9]{2})/([[:alpha:]]+)/[0-9]{4}:([0-9]{2}:[0-9]{2}:[0-9]{2}).*(https?://(www[.])?[[:alnum:].]+)"
    IGNORECASE = 1

    count = 0  # initialize the count of objects
}

{
    # get relevant and matching data from each row
    if (match($0, regex, matches)) {
        ip = matches[1]
        day = matches[2]
        month = matches[3]
        time = matches[4]
        url = matches[5]

        # store the object in the array
        dataToObject(ip, day, month, time, url, objects, count)
        count++
    }
}

END {
    print "[" > outputFile  # write opening array bracket

    # write all objects to the file at once
    for (i = 0; i < count; i++) {
        print objects[i] (i < count-1 ? "," : "") >> outputFile
    }

    print "]" >> outputFile  # close array bracket
    close(outputFile)
}
