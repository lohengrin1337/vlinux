#!/usr/bin/env awk

#
# print all first- and lastnames
#

BEGIN {
    FS=","
}

NR > 1 {
    print($1, $2)
}
