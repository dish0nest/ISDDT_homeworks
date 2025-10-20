#!/bin/bash

#Отделение логики вычисления статистики
function statistic()
{
 total=$(( $1 + $2 ))
 echo "Hit: $(( $1*100/$total ))% Miss: $(( $2*100/$total ))%"
 echo "========================================================================="
}

# Подсвечивание текста
RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

# Переменные для хранения информации о:
# 1) О шаге
# 2) О количестве удачных попыток
# 3) О количестве неудачных попыток
count=1
all_hits=0
all_misses=0

# Цикл для ввода данных
while true
do
  echo "Step: $count"
  guess=$(( 0 + $RANDOM % 10 ))
  read -p "Enter a number (0-9) or q for quit: " number

  # Case для проверки ввода
  case $number in
    [0-9])
        if [ $number -eq $guess ]
        then
          echo -e "${GREEN}Hit! My number:${RESET} $guess"
          ((++all_hits))
          statistic all_hits all_misses
        else
          echo -e "${RED}Miss! My number:$RESET $guess"
          ((++all_misses))
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