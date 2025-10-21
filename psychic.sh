#!/bin/bash

#Отделение логики вычисления статистики
function statistic()
{
 local total=$(( $1 + $2 ))
 local arr=("")
 echo "Hit: $(( $1*100/$total ))% Miss: $(( $2*100/$total ))%"

 local arr_len=${#history[@]}
 local start=$(( arr_len > 10 ? arr_len - 10 : 0 ))
 local last=("${history[@]:$start}")

 echo -n "Numbers: "
 for num in "${last[@]}"
 do
  echo -ne "$num "               # -n чтобы не переводить строку, -e чтобы интерпретировать цвета
 done
 echo ""
 echo "========================================================================="
}

RED=$'\033[31m'
GREEN=$'\033[32m'
RESET=$'\033[0m'

count=1
all_hits=0
all_misses=0
declare -a history

while true
do
  echo "Step: $count"
  guess=$(( 0 + $RANDOM % 10 ))
  read -p "Enter a number (0-9) or q for quit: " number

  case $number in
    [0-9])
        if [ $number -eq $guess ]
        then
          echo -e "${GREEN}Hit! My number:${RESET} $guess"
          ((++all_hits))
          str="${GREEN}$guess${RESET}"
          history+=("${str}")
          statistic all_hits all_misses
        else
          echo -e "${RED}Miss! My number:$RESET $guess"
          ((++all_misses))
          str="${RED}$guess${RESET}"
          history+=("${str}")
          statistic all_hits all_misses
        fi
        ((++count))
        ;;
    q)
        statistic all_hits all_misses
        echo "Bye :)"
        break
        ;;
    *)
        echo -e "${RED}Not valid input. Try again${RESET}"
        echo "========================================================================="
        continue
        ;;
  esac
done