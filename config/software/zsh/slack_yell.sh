#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "Please provide a string as an argument"
    exit 1
fi

text="$1"

declare -A digitToName
digitToName[0]="zero"
digitToName[1]="one"
digitToName[2]="two"
digitToName[3]="three"
digitToName[4]="four"
digitToName[5]="five"
digitToName[6]="six"
digitToName[7]="seven"
digitToName[8]="eight"
digitToName[9]="nine"

result=""
for (( i=0; i<${#text}; i++ )); do
    char="${text:$i:1}"

    if [ "$char" = " " ]; then
        result+="   "
    elif [ "$char" = "?" ]; then
        result+=":question:"
    elif [ "$char" = "!" ]; then
        result+=":exclamation:"
    elif [[ "$char" =~ [0-9] ]]; then
        result+=":${digitToName[$char]}:"
    elif [[ "$char" =~ [A-Za-z] ]]; then
        lower_char=$(echo "$char" | tr '[:upper:]' '[:lower:]')
        result+=":alphabet-white-$lower_char:"
    else
        result+="$char"
    fi
done

echo "$result"
