#!/usr/bin/env awk

###
### convert csv to table
###


BEGIN {
    FS = ","

    COLS = 5
    HEADER_FORMAT = "\n    " multiplyStr("%20s", COLS) "\n"
    DATA_FORMAT = "    " multiplyStr("%20s", COLS) "\n"
    LINE = multiplyStr("-", 20 * COLS) "----"

    # print header
    printf(HEADER_FORMAT, "IP", "URL", "MONTH", "DAY", "TIME")
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
# multiply a string n times
#
function multiplyStr(str, n) {
    res=""
    for (i = 0; i < n; i++) {
        res = res str
    }
    return res
}
