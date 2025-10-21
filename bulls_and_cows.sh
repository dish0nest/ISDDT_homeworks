#!/bin/bash

function cleanup()
{
  echo ""
  echo "For quit input q or Q"
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

function generate()
{
  while true
  do
    guess=$((1000 + $RANDOM % 9000))
    if checknum "$guess"
    then
      break
    fi
  done

  echo "$guess"
}

function check()
{
  local secret="$1"
  local guess="$2"
  local g=()
  local s=()
  local bulls=0
  local cows=0

  for((i=0; i<4; ++i))
  do
    g[i]=${secret:i:1}
    s[i]=${guess:i:1}
  done

  # Для быков
  for((i=0; i<4; ++i))
  do
    if [ "${g[i]}" = "${s[i]}" ]
    then
      ((++bulls))
      s[i]=@
    fi
  done

  # Для коров
  for((i=0; i<4; ++i))
  do
    for((j=0; j<4; ++j))
    do
      if [ "${g[i]}" = "${s[j]}" -a "${s[j]}" != @ ]
      then
        ((++cows))
        s[j]=@
        break
      else
        continue
      fi
    done
  done

  printf "%s %s" "$cows" "$bulls"
}

function print_history()
{
  local arr=("$@")

  echo ""
  echo "История ходов"
  local IFS=$'\n'
  for value in "${arr[@]}"
  do
    echo "$value"
  done
  echo ""
}

trap cleanup SIGINT

declare -a history
number=''
guess=$(generate)
step=1

while true
do
  read -p "Попытка $step: " number

  case $number in
    [0-9][0-9][0-9][0-9])
        if checknum "$number"
        then
          read -r cows bulls <<< "$(check "$guess" "$number")"
          echo "Коров - $cows Быков - $bulls"

          str="${step}. ${number} (Коров - ${cows} Быков - ${bulls})"
          history+=("${str}")
          print_history "${history[@]}"
          ((++step))

          if [ "$bulls" -eq 4 ]
          then
            echo "Congratulations, you won!!!"
            exit 0
          fi
        else
          echo "Unvalid input, number has same digits. Try again"
          continue
        fi
        ;;
    q)
        echo "Bye :)"
        exit 1
        ;;
    Q)
        echo "Bye :)"
        exit 1
        ;;
    *)
        echo "Unvalid input. Try again"
        continue
        ;;
  esac
done
