#!/bin/bash

function help()
{
  echo "Usage:"
  echo "  -d [dir]: Choose dir, which should be archived"
  echo "  -n [name]: Choose name of script"
}

function unpack()
{
  local archive_name="$1"
  local ARG1
  local script="./$ARG2.sh"
  local TEXT=$(cat << EOF
#!/bin/bash

function help()
{
  echo "Usage:"
  echo "  -o: Choose dir, where archive should be unpacked"
  echo " no flag: Unpack archive in directory, where script is running"
}

while getopts "o:h" option
do
  case \$option in
  o)
    ARG1="\$OPTARG"
    ;;
  h)
    help
    exit 0
    ;;
  *)
    help
    exit 1
    ;;
  esac
done

if [ -z "\$ARG1" ]
then
  ARG1="\$(pwd)"
fi

if [ ! -d "\$ARG1" ]
then
  echo "No such directory"
  exit 1
fi

if [ ! -f "$archive_name" ]
then
  echo "Archive was not created"
  exit 1
fi

tar -xzvf "$archive_name" -C "\$ARG1"
EOF
)

  touch $script
  if [ -f $script ]
  then
    echo "$TEXT" > "$script"
    chmod o+x $script
  else
    echo "File was not generated"
  fi
}

while getopts "d:n:h" option
do
  case $option in
  d)
    ARG1="$OPTARG"
    ;;
  n)
    ARG2="$OPTARG"
    ;;
  h)
    help
    exit 0
    ;;
  *)
    help
    exit 1
    ;;
  esac
done

if [ -z "$ARG1" ] || [ -z "$ARG2" ]
then
  help
  exit 1
fi

if [ ! -d "$ARG1" ]
then
  echo "No such directory"
  exit 1
fi

archive="./$(basename "$ARG1").tar.gz"
tar -czvf "$archive" -C "$(dirname "$ARG1")" "$(basename "$ARG1")"
unpack $archive