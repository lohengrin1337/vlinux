#!/usr/bin/env awk

#
# print first- and lastname plus town, from first 100 rows
#

function skipFirstRow() {
    start++
    finish++
}

BEGIN {
    FS=","
    start=507
    finish=515

    skipFirstRow()
}

NR >= start {
    print($1, $2 ",", $3)
}

NR == finish { exit 0 }
