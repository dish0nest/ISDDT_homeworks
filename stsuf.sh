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

declare -A suffixes

while IFS= read -r -d '' file
do
  base=$(basename "$file")

  if [[ "$base" == .* && "$base" != *.* ]]
  then
    suffix="no suffix"
  elif [[ "$base" =~ ^\.[^.]+$ ]]
  then
    suffix="no suffix"
  elif [[ "$base" == *.* ]]
  then
    suf="${base##*.}"
    suffix=".$suf"
  else
    suffix="no suffix"
  fi
  ((++suffixes["$suffix"]))
done < <(find "$dir" -maxdepth 1 -type f -print0)

if [ ${#suffixes[@]} -eq 0 ]
then
    echo "No files in $dir"
    exit 0
fi

for key in "${!suffixes[@]}"; do
    echo -e "${suffixes[$key]}\t$key"
done | sort -rn | while IFS=$'\t' read -r count key;
do
    echo "$key: $count"
done