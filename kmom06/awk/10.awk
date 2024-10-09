#!/usr/bin/env awk

###
### print name and formated birth, of people with long emails (> 40 chars)
###

BEGIN {
    FS = ","
}

NR > 1 {
    email=$6
    if (length(email) > 40) {
        linesToPrint[NR] = $0
    }
}

END {
    print_lines(linesToPrint)
}



###
### UTIL FUNCTIONS
###

#
# print linesToPrint in a format
#
# Joseph 2/nov-1997
# Maximiliam 3/jun-2001
# Vilhelm 23/mar-2002
#
function print_lines(lines) {
    for (key in lines) {
        # parse lines
        split(lines[key], line)
        split(line[4], birth, "-")
        name = line[1]
        year=birth[1]
        month=birth[2]
        day=birth[3]

        # format birth
        monthTxt = monthToText(month)
        daySimple = stripLeadingZero(day)

        print(name, daySimple "/" monthTxt "-" year)
    }
}

#
# translate digital month to short text (01 = jan)
#
function monthToText(num) {
    monthStr = "jan feb mar apr maj jun jul aug sep okt nov dec"
    split(monthStr, months, " ")
    num = stripLeadingZero(num)

    return months[num]
}

#
# strip leading zero from number (01 = 1), if it has one
#
function stripLeadingZero(num) {
    if (num ~ /^0/) {
        num = substr(num, 2)
    }

    return num
}
