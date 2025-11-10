#!/bin/bash

function help()
{
  echo "Usage: $0 [dirpath]"
}

if [ $# -ne 1 ]
then
  help
  exit 1
fi

dir="$1"

if [ ! -d "$dir" ]
then
  echo "No such directory"
  exit 1
fi

user="$USER"
dt=$(date -I)
text="Approved $user $dt"

for file in "$dir"/*.txt
do
    if [ -f "$file" ]
    then
        tmp=$(mktemp)

        {
            echo "$text"
            cat "$file"
        } > "$tmp"

        mv "$tmp" "$file"
    fi
done