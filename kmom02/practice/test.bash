#!/usr/bin/env bash
# shellcheck disable=all

#
# An example script comparison operators on integers

val1=5
val2=3

# -gt (greater than)
[[ $val1 -gt $val2 ]] && echo "$val1 is bigger than $val2"

# -lt (less than)
[[ $val1 -lt $val2 ]] && echo "$val1 is smaller than $val2"

# -eq (equal to)
[[ $val1 -eq $val2 ]] && echo "$val1 is equal to $val2"

# -ne (not equal to)
[[ $val1 -ne $val2 ]] && echo "$val1 is not equal to $val2"

# -ge (greater than or equal to)
[[ $val1 -ge $val2 ]] && echo "$val1 is greater than or equal to $val2"

# -le (less than or equal to)
[[ $val1 -le $val2 ]] && echo "$val1 is less than or equal to $val2"

#
# An example script comparison operators on strings

string1="a"
string2="b"

# = (equal to)
[[ "$string1" = "$string2" ]] && echo "$string1 and $string2 are the same!"

# != (not equal to)
[[ "$string1" != "$string2" ]] && echo "$string1 and $string2 are not the same!"

# < (less than, according to the ASCII alphabetical order)
[[ "$string1" < "$string2" ]] && echo "$string1 is less than $string2 !"

# > (greater than, according to the ASCII alphabetical order)
[[ "$string1" > "$string2" ]] && echo "$string1 is greater than $string2!"

# -z (string is null or has zero length)
string1=null
[[ -z "$string1" ]] && echo "String is null or has zero length"

# -n (string is not null)
[[ -n "$string2" ]] && echo "String is not null"

val=5

if [[ $val -gt 5 ]]
then
    echo "$val is gt 5"
elif [[ $val -lt 5 ]]
then
    echo "$val is lt 5"
else
    echo "$val is 5"
fi

[[ $val -ge 5 ]] && res="gt | eq" || res="lt"
echo "$res"


for x in 1 2 3
do
    echo "$x"
done

for x in {0..9..2}
do
    echo "$x"
done

for i in {0..9}
do
    if (( $i % 2 == 1 ))
    # if [[ $i%2 -eq 1 ]]
    then echo "$i is uneven"
    fi
done

counter=0
while [[ $counter -lt 10 ]]
do
    echo "counter is $counter"
    # (( counter++ ))
    let counter++
    # let counter+=1
    # let counter=counter+1
done

counter=0
while true
do
    echo "$counter"
    let counter++
    [[ $counter -ge 10 ]] && echo "done" && break
done

counter=0
while true
do
    let counter++
    [[ $counter -eq 5 ]] && echo "skipping 5" && continue
    [[ $counter -eq 10 ]] && echo "done at 10" && break
    echo "c = $counter"
done

# read input
# case "$input" in
#     hello)
#         echo "hello $USER"
#     ;;
#     42)
#         echo "$input is the meaning!"
#     ;;
#     *)
#         echo "wrong input!"
#     ;;
# esac

# declare -l inp
# read inp
# case "$inp" in
#     (one | two | three)
#         echo "a number! $inp";;
#     (monkey | donkey | horse)
#         echo "an animal";;
#     (*)
#         echo "unknown input: $inp";;
# esac

declare -a rocky_planets

rocky_planets=("Mercury" "Venus")

# or by index
rocky_planets[2]="Earth"

# or by appending
rocky_planets+=("Mars")


rocky_planets=("The Sun" "${rocky_planets[@]}")

echo ${rocky_planets[@]}

rocky_planets=("${rocky_planets[@]:1}")

echo ${rocky_planets[@]}

echo ${rocky_planets[1]}

echo "${rocky_planets[2]:1:2}"

[[ "2" = 2 ]] && echo "that is true" 

for planet in ${rocky_planets[@]}; do
    echo $planet
done


for i in ${!rocky_planets[@]}; do
    echo "i = $i p = ${rocky_planets[$i]}"
done

declare -A all_planets

rocky_planets=("     Mercury     " "Venus" "Earth" "Mars")
gas_planets=("Jupiter" "Saturn")
ice_planets=("Uranus" "Neptune")

all_planets["rocky_planets"]=${rocky_planets[*]}
all_planets["gas_planets"]="${gas_planets[*]}"
all_planets["ice_planets"]="${ice_planets[*]}"

group=${all_planets[rocky_planets]}
declare -p group

for planet in "$group"; do
    echo "$planet"
done

for planet in $group; do
    echo $planet
done

# for planet in "${all_planets["rocky_planets"]}"; do
#     echo $planet
# done


# for planet_group in ${!all_planets[@]}; do
#     echo "The $planet_group are:"

#     for planet in ${all_planets[$planet_group]}; do
#         echo $planet
#     done
# done

# string="This is a simple string"

# for word in $string; do
#   echo "$word"
# done


# for loop - nested loop
# for name in "${!all_planets[@]}"
# do
#     echo "The $name are:"

#     # No quotes here as the point is to use word splitting
#     for planet in ${all_planets[$name]}
#     do
#         echo "$planet"
#     done
# done

function presentation {
    echo "Hello $1!"
}

presentation "$USER"

function arguments {
    echo "first: $1"
    echo "second: $2"
    echo "third: $3"
    echo "alla*: $*"
    echo "alla@: $@"
    echo "antal: $#"

    for arg in "$@"; do
        echo "$arg"
    done
}

arguments "h     e     j" "hopp" "studs"

res=0

function count {
    for val in "$@"; do
        let res+=$val
    done
}

count  1 2 3
echo "res = $res"

function count2 {
    res=0
    for val in "$@"; do
        let res+=$val
    done
    echo "$res"
}

res=$(count2 1 2 3)
echo "res is $res"