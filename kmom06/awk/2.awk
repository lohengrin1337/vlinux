#!/usr/bin/env awk

#
# print first- and lastname plus town, from first 100 rows
#

BEGIN {
    FS=","
    start=2
    finish=101
}

NR >= start {
    print($1, $2 ",", $3)
}

NR == finish { exit 0 }
