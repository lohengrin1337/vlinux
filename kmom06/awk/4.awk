#!/usr/bin/env awk

#
# print all first- and lastname plus phone, with headers
#

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
    format = "\n  " multiplyStr("%-20s", cols) "\n"
    printf(format, header[1], header[2], header[3])

    print(multiplyStr("-", 20 * cols) "--")

    for (key in lines) {
        split(lines[key], line)
        format = "  " multiplyStr("%-20s", cols) "\n"

        printf(format, line[1], line[2], line[5])
    }

    print(multiplyStr("-", 20 * cols) "--\n")
}

BEGIN {
    FS = ","
    start = 1
    finish = -1

    header[1] = "Förnamn"
    header[2] = "Efternamn"
    header[3] = "Telefonnummer"

    cols = length(header)

    skipFirstRow()
}

NR >= start {
    linesToPrint[NR] = $0
}

NR == finish { exit 0 }

END {
    print_lines(linesToPrint)
}
