#!/usr/bin/env awk

###
### use '8.awk' and add amount born before 2000
###

BEGIN {
    FS = ","
    inputFile = ARGV[1]
    cmd = "awk -f 8.awk " inputFile
    count = 0

    # get result of cmd, one line at a time
    while (( cmd | getline result ) > 0) {
        print(result)

        # parse year from each line
        split(result, fields)
        split(fields[2], birth, "-")
        year = birth[1]

        # count people born before 2000
        if (year < 2000) {
            count++
        }
    }

    # close stream
    close(cmd)

    print(multiplyStr("-", 50))
    print(count " stycken är födda innan år 2000.")
}



###
### UTIL FUNCTIONS
###

#
# skip header of csv, by incrementing start and finish
#
function skipFirstRow() {
    start++
    finish++
}

#
# multiply a string n times
#
function multiplyStr(str, n) {
    res=""
    for (i = 0; i < n; i++) {
        res = res str
    }
    return res
}

#
# print linesToPrint
#
function print_lines(lines) {
    # format = "\n  %-" width "s%" width "s\n"
    # printf(format, header[1], header[2])

    # print(multiplyStr("-", width * cols) "----")

    for (key in lines) {
        split(lines[key], line)

        format = "%s %s, %s, %s\n"
        printf(format, line[1], line[2], line[4], line[5])

    }

    # print(multiplyStr("-", width * cols) "----\n")
}
