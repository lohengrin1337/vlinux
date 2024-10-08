#!/usr/bin/env awk

###
### print first- and lastname plus town, with headers,
### where town has 'stad' in it, and person is born in jan or okt
###

BEGIN {
    FS = ","
    start = 1
    finish = -1
    regex1 = "stad"
    regex2 = "-01-|-10-"

    header[1] = "Förnamn"
    header[2] = "Efternamn"
    header[3] = "Stad"

    cols = length(header)

    skipFirstRow()
}

NR >= start && $3 ~ regex1 && $4 ~ regex2{
    linesToPrint[NR] = $0
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
    format = "\n  %-20s%-20s%20s\n"
    printf(format, header[1], header[2], header[3])

    print(multiplyStr("-", 20 * cols) "----")

    for (key in lines) {
        split(lines[key], line)
        format = "  %-20s%-20s%20s\n"
        printf(format, line[1], line[2], line[3])
    }

    print(multiplyStr("-", 20 * cols) "----\n")
}
