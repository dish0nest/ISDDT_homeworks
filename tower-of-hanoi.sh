#!/usr/bin/env bash

function cleanup()
{
  echo ""
  echo "Чтобы выйти, введите q или Q."
}

function stacks()
{
    local max_height=8
    local i valA valB valC

    for ((i=max_height-1; i>=0; i--))
    do
        valA="${A[i]:- }"
        valB="${B[i]:- }"
        valC="${C[i]:- }"
        printf "|%s|  |%s|  |%s|\n" "$valA" "$valB" "$valC"
    done
    echo "+-+  +-+  +-+"
    echo " A    B    C"
}


function move_disk()
{
    local from=$1
    local to=$2
    local disk top

    case $from in
        A)
          src_arr=("${A[@]}")
          ;;
        B)
          src_arr=("${B[@]}")
          ;;
        C)
          src_arr=("${C[@]}")
          ;;
        *)
          echo "Ошибка: неизвестный стек $from"
          return 1
          ;;
    esac

    case $to in
        A)
          dst_arr=("${A[@]}")
          ;;
        B)
          dst_arr=("${B[@]}")
          ;;
        C)
          dst_arr=("${C[@]}")
          ;;
        *)
          echo "Ошибка: неизвестный стек $to"
          return 1
          ;;
    esac

    if ((${#src_arr[@]} == 0))
    then
        echo "Стек $from пуст. Повторите ввод."
        return 1
    fi

    disk=${src_arr[-1]}

    if ((${#dst_arr[@]} > 0))
    then
        top=${dst_arr[-1]}
        if ((disk > top))
        then
            echo "Такое перемещение запрещено!"
            return 1
        fi
    fi

    unset 'src_arr[-1]'
    dst_arr+=("$disk")

    case $from in
        A)
          A=("${src_arr[@]}")
          ;;
        B)
          B=("${src_arr[@]}")
          ;;
        C)
          C=("${src_arr[@]}")
          ;;
    esac

    case $to in
        A)
          A=("${dst_arr[@]}")
          ;;
        B)
          B=("${dst_arr[@]}")
          ;;
        C)
          C=("${dst_arr[@]}")
          ;;
    esac

    return 0
}

function win() {
    local stack_name=$1
    local expected=(3 2 1)
    local -a current=()

    case $stack_name in
        A)
          current=("${A[@]}")
          ;;
        B)
          current=("${B[@]}")
          ;;
        C)
          current=("${C[@]}")
          ;;
        *)
          echo "Ошибка: неизвестный стек $stack_name" >&2
          return 1
          ;;
    esac

    if [[ ${current[@]} == "${expected[@]}" ]]
    then
        echo "Поздравляем! Вы победили!"
        stacks
        exit 0
    fi
}

declare -a A=(3 2 1)
declare -a B=()
declare -a C=()
moves=1

trap cleanup SIGINT

while true
do
    stacks
    read -p "Ход № $moves (откуда, куда): " move

    move=$(echo "$move" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')

    if [[ "$move" == "q" ]]
    then
        echo "До свидания :)"
        exit 1
    fi

    if [[ ${#move} -ne 2 ]]
    then
        echo "Некорректный ввод. Повторите."
        continue
    fi

    from=${move:0:1}
    to=${move:1:1}

    if [[ ! "$from" =~ [abc] ]] || [[ ! "$to" =~ [abc] ]]
    then
        echo "Некорректные имена стеков. Используйте A, B, C."
        continue
    fi

    if [[ "$from" == "$to" ]]
    then
        echo "Нельзя перемещать в тот же стек."
        continue
    fi

    if move_disk "${from^^}" "${to^^}"
    then
        ((++moves))
        win B
        win C
    fi
done