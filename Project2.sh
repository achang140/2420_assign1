#!/bin/bash

#: Title        : Project 2 - System Info
#: Draft Date   : Oct 25 2022
#: Modified Date: Nov 04 2022
#: Author       : Amanda Chang
#: Description  : Display system info
#: Total Script : 1

function usage {
        echo "Choose an option listed below:"
        echo '-a Display an ASCII image with system info'
        echo '-s Only display system info'
        echo '-h Display this usage message'
}

### Function err ###
# Display error message if no option is provided (The condition is check by an If statement at the bottom of the script)

function err {
        echo "$*" >&2
        usage
        exit 1
}

### Variables with all the system info commands ###

HOSTNAME=$(hostname)
WHOAMI=$(whoami)
UPTIME=$(awk '{printf("%d:%02d:%02d:%02d\n",($1/60/60/24),($1/60/60%24),($1/60%60),($1%60))}' /proc/uptime)
OS=$(hostnamectl | grep "Operating System" | awk '{ print $3, $4}')
KERNEL=$(hostnamectl | grep "Kernel" | awk '{ print $2, $3}')
BASHSHELL=$(echo $SHELL)
PACKAGE=$(dpkg-query -f '${binary:Package}\n' -W | wc -l)
MEMAVA=$(free -hg | awk 'NR==2 { print $4 }')
MEMUSED=$(free -hg | awk 'NR==2 { print $3 }')

### Function img_sysinf ###
# Display a penguin ASCII graphic and system info

function img_sysinf {
        clear
        printf "            \e[1;31m Host:                      \e[m ${HOSTNAME} \n"
        printf "    .--.    \e[1;35m User:                      \e[m ${WHOAMI} \n"
        printf "   |o_o |   \e[1;31m Uptime (Day:Hour:Min:Sec): \e[m ${UPTIME} \n"
        printf "   |:_/ |   \e[1;35m Distro:                    \e[m ${OS} \n"
        printf "  //   \ \  \e[1;31m Kernel:                    \e[m ${KERNEL} \n"
        printf " (|     | ) \e[1;35m Shell:                     \e[m ${BASHSHELL} \n"
        printf "/'\_   _/'\ \e[1;31m Packages:                  \e[m ${PACKAGE} rpm \n"
        printf "\___)=(___/ \e[1;35m Mem Available:             \e[m ${MEMAVA} \n"
        printf "            \e[1;31m Mem Used:                  \e[m ${MEMUSED} \n"
}

### Function sysinf ###
# Display system info

function sysinf {
        clear
        printf "\e[1;31m Host:                          \e[m ${HOSTNAME} \n"
        printf "\e[1;35m User:                          \e[m ${WHOAMI} \n"
        printf "\e[1;31m Uptime (Day:Hour:Min:Sec):     \e[m ${UPTIME} \n"
        printf "\e[1;35m Distro:                        \e[m ${OS} \n"
        printf "\e[1;31m Kernel:                        \e[m ${KERNEL} \n"
        printf "\e[1;35m Shell:                         \e[m ${BASHSHELL} \n"
        printf "\e[1;31m Packages:                      \e[m ${PACKAGE} rpm \n"
        printf "\e[1;35m Mem Available:                 \e[m ${MEMAVA} \n"
        printf "\e[1;31m Mem Used:                      \e[m ${MEMUSED} \n"
}

### 3 options (-a, -s, and -h) ###
# -a Display ACSII image with system info
# -s Only display system info
# -h Show the usage message

while getopts "ash" opt; do
  case "${opt}" in
        a)
          img_sysinf
          ;;
        s)
          sysinf
          ;;
        h)
          clear
          usage
          ;;
  esac
done

# If no option is provided, display an error message.

if [ $# -eq 0 ]; then
  err "Error: No arguments provided"
fi
