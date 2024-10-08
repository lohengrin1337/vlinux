#!/usr/bin/env awk

#
# write row-data to json object
#
function rowToObject(brand, model, price, units) {
    if (!firstIteration) {
        print "\t}," >> filename    # closing bracket with comma for previous object
    }

    print "\t{" >> filename         # opening bracket for current object 
    print "\t\t\"brand\": " "\"" brand "\"," >> filename
    print "\t\t\"model\": " "\"" model "\"," >> filename
    print "\t\t\"price\": " "\"" price "\"," >> filename
    print "\t\t\"units\": " "\"" units "\""  >> filename    # no trailing comma
}

#
# variables and file creation
#
BEGIN {
    FS=","                          # to parse csv
    skipFirstRow=1                  # flag to exclude first row (1) or include (0)
    regex=""                        # update to create a filter or leave empty for no filter
    filename="phones.json"          # choose a suitable name for export file
    firstIteration=1                # true until first iteration is done

    print "[" > filename            # opening square bracket of json (create/replace file with '>')
}

#
# body excluding/including first row, and rows matching a regex pattern
#
NR > skipFirstRow && $0 ~ regex {
    rowToObject($1, $2, $3, $4)     # write csv row to json object

    if (firstIteration) {
        firstIteration = 0          # first iteration is done
    }
}

#
# close and clean up
#
END {
    print "\t}" >> filename         # closing bracket without comma for last object
    print "]" >> filename           # close array
    close(filename)                 # close file stream
}
