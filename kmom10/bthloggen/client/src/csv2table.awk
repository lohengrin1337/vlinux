#!/usr/bin/env awk

###
### convert csv to table
###


BEGIN {
    FS = ","

    COLS = 5
    HEADER_FORMAT = "\t%-23s%-21s%s\n"
    DATA_FORMAT = "\t%-2s%-4s%-16s%-21s%s\n"
    LINE = multiplyStr("-", 81) "----"

    # print header
    printf(HEADER_FORMAT, "DATETIME","IP", "URL")
    print(LINE)
}

{
    # print formated table data
    printf(DATA_FORMAT, $1, $2, $3, $4, $5)
}

END {
    print(LINE)
}


#
# util, multiply a string n times
#
function multiplyStr(str, n) {
    res=""
    for (i = 0; i < n; i++) {
        res = res str
    }
    return res
}
