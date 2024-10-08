#!/usr/bin/env awk'

BEGIN {
    FS=","
    OFS="\t"
    counter=1
}

NR > 1 {
    items[counter++] = $0

}

END {
    for (item in items) {
        len = split(items[item], strings)
        print strings[1], strings[2], strings[3], strings[4]
        print len
    }
}



# function randint(n) {
#     return int(n * rand())
# }

# BEGIN {
#     currency=8.31   # USD -> SEK
#     headerFormat="%-15s%-15s%-15s%-15s\n"
#     contentFormat="%-15s%-15s%-15d%-15.2f\n"
#     FS=","
#     # OFS="\t\t"
#     # print("\n\t--- LAGER ---\n")
#     # print("TILLVERKARE", "MODELL", "ANTAL", "PRIS")
#     srand()

#     # print(srand())
#     print(randint(100))
#     print(randint(100))
#     print(randint(100))


#     printf(headerFormat, "TILLVERKARE", "MODELL", "ANTAL", "PRIS ($)")
# }

# # NR<2 { next }

# # NR > 1 { 
# #     # print($1, $2, $4, "$"int($3/8.31))

# #     if ($4 > 10) {
# #         print $0
# #     }

# # }

# NR > 1 {

#     # if ($4 > 10) {
#     #     split($2, modelArr, " ")
#     #     print modelArr[1]
#     # }

#     res = match($2, /[a-zA-Z]+[0-9]+/)

#     if (res) {
#         print $2
#     }
# }


# # NR>1 { 
# #     # print($1, $2, $4, "$"int($3/8.31))
# #     printf(contentFormat, $1, $2, $4, $3/currency)

# # }



# END {
#     # print("\n\t--- SLUT ---\n")
# }
