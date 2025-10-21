#!/bin/bash

function help()
{
  echo "Usage: $0 [directory] [old_suffix] [new_suffix]"
}

function validate_suffix()
{
  local suf="$1"
  if [[ ! "$suf" =~ ^\.[^.]+$ ]]
  then
      echo "Error: suffix '$suf' is invalid."
      exit 1
  fi
}

if [ $# -ne 3 ]
then
    help
    exit 1
fi

dir="$1"
old="$2"
new="$3"

validate_suffix "$old"
validate_suffix "$new"

if [ ! -d "$dir" ]
then
  echo "No such directory"
  exit 1
fi

find "$dir" -type f | while IFS= read -r file
do
  base=$(basename "$file")
  echo "$base"

  if [[ "$base" == *"$old" ]]
  then
    new_file="${file%$old}$new"
    mv "$file" "$new_file"
  fi
done

