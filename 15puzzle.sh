#!/bin/bash

function initialize()
{
  numbers=($(seq 1 15))
  numbers+=('_')
  numbers=($(shuf -e "${numbers[@]}"))

  count=0
  for((i=0;i<SIZE;++i))
  do
    for((j=0;j<SIZE;++j))
    do
      fields[$i,$j]=${numbers[$count]}
      ((++count))
    done
  done
}

function gameboard()
{
  echo ""
  echo "+----+----+----+----+"
  for((i=0;i<SIZE;++i))
  do
    for((j=0;j<SIZE;++j))
    do
      field="${fields[$i,$j]}"
      if [ "$field" == "_" ]
      then
        printf "|    "
      else
        printf "| %2s " "$field"
      fi
    done
    echo "|"
    echo "+----+----+----+----+"
  done
  echo ""
}

function empty_cell()
{
  for((i=0;i<SIZE;++i))
  do
    for((j=0;j<SIZE;++j))
    do
      if [ "${fields[$i,$j]}" == "_" ]
      then
        empty_i=$i
        empty_j=$j
        return
      fi
    done
  done
}

function win()
{
  num=1
  for((i=0;i<SIZE;++i))
  do
    for((j=0;j<SIZE;++j))
    do
      if [[ $i -eq SIZE-1 && $j -eq SIZE-1 ]]
      then
        [ "${fields[$i,$j]}" == "_" ] && return 0
      else
        [ "${fields[$i,$j]}" != "$num" ] && return 1
        ((++num))
      fi
    done
  done
}

SIZE=4
moves=0
declare -A fields
declare -a numbers

initialize
while true
do
  ((++moves))
  echo "Ход № $moves"
  gameboard
  empty_cell

  possible_moves=()
  for di in -1 0 1
  do
    for dj in -1 0 1
    do
      if [ $((di*di + dj*dj)) -eq 1 ]
      then
        ni=$((empty_i + di))
        nj=$((empty_j + dj))
        if (( ni >= 0 && ni < SIZE && nj >=0 && nj < SIZE ))
        then
          possible_moves+=("${fields[$ni,$nj]}")
        fi
      fi
    done
  done

  read -p "Ваш ход (q - выход): " move
  if [ "$move" == 'q' ]
  then
    echo "Игра завершена"
    echo "До свидания :)"
    exit 0
  fi

  if [[ ! " ${possible_moves[@]} " =~ " $move " ]]
  then
    echo "Неверный ход!"
    echo "Невозможно костяшку $move передвинуть на пустую ячейку."
    echo -n "Можно выбрать: "
    IFS=', '; echo "${possible_moves[*]}"
    ((--moves))
    continue
  fi

  for ((i=0;i<SIZE;i++)); do
    for ((j=0;j<SIZE;j++)); do
        if [[ "${fields[$i,$j]}" == "$move" ]]
        then
            sel_i=$i
            sel_j=$j
            break 2
        fi
    done
  done

  temp=${fields[$sel_i,$sel_j]}
  fields[$sel_i,$sel_j]=${fields[$empty_i,$empty_j]}
  fields[$empty_i,$empty_j]=$temp

  if win
  then
    echo "Вы собрали головоломку за $moves ходов."
    gameboard
    exit 0
  fi
done