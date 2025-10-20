#!/bin/bash

function cleanup() {
  echo ""
  echo "For quit input q"
  echo "Input number: "
}

trap cleanup SIGINT

while true
do
  read -p "Input number: " number
  case $number in
    [0-9])
        echo "Your number: $number"
        ;;
    q)
        echo "Bye :)"
        break;;
  esac
done