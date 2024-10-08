#!/usr/bin/env awk

###
### print year and amount of people for each year, with headers
###

BEGIN {
    FS = ","
    start = 1
    finish = -1

    header[1] = "Årtal"
    header[2] = "Antal"
    cols = length(header)
    width = 8

    skipFirstRow()
}

NR >= start {
    split($4, birth, "-")
    year = birth[1]
    linesToPrint[year] = linesToPrint[year] + 1
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
# print linesToPrint, with header and footer
#
function print_lines(lines) {
    format = "\n  %-" width "s%" width "s\n"
    printf(format, header[1], header[2])

    print(multiplyStr("-", width * cols) "----")

    for (year in lines) {
        amount = lines[year]
        format = "  %-" width "s%" width "s\n"
        printf(format, year, amount)
    }

    print(multiplyStr("-", width * cols) "----\n")
}
