#!/bin/bash

function cleanup()
{
  echo ""
  echo "For quit input q"
  echo "Input number: "
}

function checknum()
{
  if echo $1 | grep -qE '(.).*\1'
  then
    return 1
  else
    return 0
  fi
}

trap cleanup SIGINT

declare -a history
number=''

while true
do
  read -p "Input number: " number
  case $number in
    [0-9][0-9][0-9][0-9])
        checknum $number
        ;;
    q)
        echo "Bye :)"
        break
        ;;
    *)
        continue
        ;;
  esac
done