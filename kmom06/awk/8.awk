#!/usr/bin/env awk

###
### print firstname, lastname, birth date and phone, without headers
### for people where phone contains day of birth
###

BEGIN {
    FS = ","
    start = 1
    finish = -1

    skipFirstRow()
}

NR >= start {
    split($4, birth, "-")
    day = birth[3]
    phone = $5

    if (phone ~ day) {
        linesToPrint[NR] = $0
    }
}

NR == finish { exit 0 }

END {
    print_lines(linesToPrint)
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
