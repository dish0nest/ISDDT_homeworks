#!/bin/bash

function help()
{
  echo "Usage: $0 [OPTIONS] command"
  echo "  --path[dirpath]: Choose dir for executing command (default: working directory)"
  echo "  --mask[mask]: Choose pattern for matching files, on which command would be executed (default: *)"
  echo "  --number[number]: Select count of maximum executed process at once (default: $(nproc))"
}

path=$(pwd)
mask='*'
number=$(nproc)

OPTIONS=$(getopt -o '' --long path:,mask:,number:,help -n "$0" -- "$@")

if [ $? -ne 0 ]
then
  echo "Failed to parse options" >&2
  exit 1
fi

eval set -- "$OPTIONS"

while true
do
  case "$1" in
    --help)
      help
      exit 0
      ;;
    --path)
      path="$2";
      shift 2
      ;;
    --mask)
      mask="$2";
      shift 2
      ;;
    --number)
      number="$2";
      shift 2
      ;;
    --)
      shift;
      break;;
    *)
      echo "Unknown argument: $1">&2
      help
      exit 1
      ;;
  esac
done

if [ $# -lt 1 ]; then
  echo "Error: command is required!" >&2
  help
  exit 1
fi

command="$1"

if [ ! -d $path ]
then
  echo "No such directory"
  exit 1
fi

if ! executable=$(command -v "$command")
then
  echo "Command '$command' not found"
  exit 1
fi

if [ ! -x "$executable" ]
then
  echo "No permission for execute '$command'"
  exit 1
fi

files=()
while IFS= read -r -d $'\0' file
do
  files+=("$file")
done < <(find "$path" -maxdepth 1 -type f -name "$mask" -print0)

if [ ${#files[@]} -eq 0 ]
then
    echo "No files were found"
    exit 0
fi

running=0

echo "Path: $path"
echo "Mask: $mask"
echo "Number: $number"

for file in "${files[@]}"
do
  echo "Running: $command \"$file\" &"
  (
    "$command" "$file"
    sleep 5
  ) &
  ((++running))

  if [ "$running" -ge "$number" ]
  then
    wait -n
    ((--running))
  fi
done