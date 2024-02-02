#!/bin/bash

#: Title        : Project 3 - Backups
#: Draft Date   : Oct 25 2022
#: Modified Date: Nov 04 2022
#: Author       : Amanda Chang
#: Description  : Backup and restore directory

declare -a ARR=()

function usage {
        echo "Options:"
        echo '-d (Mandatory) Path of a directory to backup. (Format: -d "./DIR $HOME/DIR")"'
        echo "   Requires 2 arguments:"
        echo "   1. Relative path of the directory to be backup (Ex: ./DIR)"
        echo "   2. Absolute path to the directory to be backup (Ex: /home/vagrant/DIR"
        echo "-b (Optional) Path to save your backup files."
        echo '   If no path is given, the default path will be $HOME/archive'
        echo "-n Name of your backup directory"
        echo "   If no name is given, the default name will be the current date"
        echo '-R Restore your backup to another location. (Format: -R "$HOME/BACKUP.tar.gz.xz $HOME/bin/NEWDIR)"'
        echo "   Requires 2 arguments:"
        echo "   1. Absolute path of the backup directory you want to decompress"
        echo "   2. Absolute path to store your decompressed files"
        echo "-h Display this usage message"
        exit 1
}

### Function backup ###
# Archive (tar) and compress (xz) files in a directory provided and move (mv) to another location.

# If -b argument (path to store the backup directory) is not provided, check for directory archive.
# If directory archive does not already exist, it will be created in user's home directory.
# If the directory already exist, the archived and compressed files will be stored in archive directory

# If -n argument (name of the compressed and archived directory) is not provided,
# directory name will be default to the current date.

function backup {
        [[ -z ${ARCPATH} ]] && ARCPATH="$HOME/archive/"
        if [[ ! -d ${ARCPATH} ]];then
          mkdir -p "${ARCPATH}"
        fi

        if [[ -n ${FILENAME} ]]; then
           FNAME=${FILENAME}
        else
           FNAME=`date +%d-%m-%y`
        fi

        cd "${PSOURCE}"
        tar -zcvf ${FNAME}.tar.gz "${CSOURCE}" 2> /dev/null
        xz ${FNAME}.tar.gz
        mv ${FNAME}.tar.gz.xz ${ARCPATH}
}

### Function restore ###
# Decompress (xz -d) and extract (tar xz) files in a backup directory provided.

function restore {
        COMSOURCE="${ARR[0]}"
        FINSOURCE="${ARR[1]}"
        xz -d -c "${COMSOURCE}" | tar xz -C "${FINSOURCE}"
}

### Function err ###
# Display error message if user uses -d without any arguments.

function err {
        echo "$*" >&2
}

### 5 options (-d, -b, -n, -R, -h) ###
# -d and -R takes in 2 arguments.
# -b and -n are optional.
# -h does not require an argument. It simply display the usage message.

while getopts ":d:b:n:R:h" opt; do
  case "${opt}" in
        d)
          CSOURCE=$(echo ${OPTARG} | awk '{n=split($1,b," ")} {print $1}' | tr -d './')
          PSOURCE=$(echo ${OPTARG} | awk '{n=split($1,b," ")} {print $2}')
          ;;
        b)
          ARCPATH="${OPTARG}"
          ;;
        n)
          FILENAME="${OPTARG}"
          ;;
        R)
          IFS=" " read -r -a ARR <<< "${OPTARG}"
          ;;
        h)
          usage
          ;;
  esac
done

shift $((OPTIND - 1))

# -d must have 2 arguments to execute the backup function

#if [ -z "${CSOURCE}" ]; then
#   err "No argument is provided"
#elif
#   [ -z "${PSOURCE}" ]; then
#   err "No argument is provided"
#fi

# If -R does not have arguments, which means it is not called.
# Execute backup function if -d is given 2 arguments.

if [[ ${#ARR[@]} -gt 0 ]]; then
    restore
else
    backup
fi
