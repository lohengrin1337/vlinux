#!/usr/bin/env awk

#
# print first- and lastname plus town, from first 100 rows
#

#
# skip header of csv, by incrementing start and finish
#
function skipFirstRow() {
    start++
    finish++
}

#
# print linesToPrint, with header and footer
#
function print_lines(lines) {
    printf()

    for (key in lines) {
        print("key: ", key, "line: ", lines[key])
    }
}

BEGIN {
    FS=","
    start=1
    finish=5

    skipFirstRow()
}

NR >= start {
    linesToPrint[NR] = $1
}

NR == finish { exit 0 }

END {
    print_lines(linesToPrint)
}
