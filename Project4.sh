#!/bin/bash

#: Title        : Project 4
#: Draft Date   : Oct 25 2022
#: Modified Date: Nov 04 2022
#: Author       : Amanda Chang
#: Description  : Check if a device or filesystem is mounted

function usage {
        echo "Pass in an argumentn, name of a device or filesystem, to check if it is mounted"
        echo "-h Display this usage message"
        exit 1
}

### Function err ###
# Display an error message if no argument is provided.

function err {
        echo "$*" >&2
}

### 1 option (h) ###
# -h Show the usage message

while getopts "h" opt; do
  case "${opt}" in
        h)
          usage
          ;;
  esac
done

# An argument (filesystem) provided by the user
USERINPUT=$1

# df -h command check if a device or filesystem is mounted
# FSNAME is the name of a device or filesytem, which is provided by user.
# FSUSED is the % that a device or filesystem is used.
# FSFREE is the available quantity of the devive or filesystem.
FSNAME=$(df -h | grep -P "(^|\s)\K${USERINPUT}(?=\s|$)" | awk '{ print $1}')
FSUSED=$(df -h | grep -P "(^|\s)\K${USERINPUT}(?=\s|$)" | awk '{ print $5 }')
FSFREE=$(df -h | grep -P "(^|\s)\K${USERINPUT}(?=\s|$)" | awk '{ print $4 }')

# If no argument is provided, display an error message.
if [ $# -eq 0 ]; then
  err "Error: No arguments provided"
  exit 1
fi

# If a device or filesystem is mounted, display its usage and available quantity.
if [ ${FSNAME} ] ; then
  printf '%s\n' "${FSNAME} is ${FSUSED} used with ${FSFREE}iB free."
else
  err "Error: Filesystem does NOT exist"
  exit 1
fi
