#!/bin/bash

#: Title        : Project 1 - Quick Note
#: Draft Date   : Oct 25 2022
#: Modified Date: Nov 04 2022
#: Author       : Amanda Chang
#: Description  : User can write short notes and search notes by title, tags, or date
#: Total Script : 1

function usage {
        echo "Notes are stored inside 'allnotes' directory"
        echo "-f Search notes by name"
        echo "-t Search notes by tag. Type 'n' to specify no tag."
        echo "-d Search notes by date"
        echo "-h Display this usage message"
        exit 1
}

# Directory allnotes stores all the notes
NOTEPATH=$HOME/allnotes

DATE=`date +%d-%m-%Y`

### Function create ###
# Create new notes.
# Before creating a new note, it checks if directory allnotes exist.
# If directory allnotes exists, a new note can be created with a unique title follow by tag (optional) and content.
# To exit the while loop for appending contents, user has to press ctrl + d

function create {
        if [[ ! -d ${NOTEPATH} ]]; then
                mkdir $NOTEPATH
        fi

        read -p "Title: " TITLE

        while [ -f "${NOTEPATH}/${TITLE}" ]; do
                echo "File ${title} already exists, use a different name"
                read -p "Title: " TITLE
        done

        read -p 'Tag (Optional): ' TAG

        if [[ -z ${TAG} ]]; then
           TAG="None"
        fi

        printf "FILENAME: ${TITLE}\n\n" >> ${NOTEPATH}/${TITLE}
        printf "Tag: ${TAG}\n\n" >> ${NOTEPATH}/${TITLE}
        printf "Date: ${DATE}\n\n" >> ${NOTEPATH}/${TITLE}
        printf "Content: \n" >> ${NOTEPATH}/${TITLE}

        echo "Press ctrl+d when you finish writing notes"

        while IFS= read -r content; do
                printf "${content}\n" >> ${NOTEPATH}/${TITLE}
        done
}

### Function searchfile ###
# Search notes by name inside directory allnotes and display the whole note.

function searchfile {
        FPATH=$(find ${NOTEPATH} -type f -iname ${INPUTFILE})
        cat $FPATH
}

### Function searchtag ###
# Search notes by tag inside directory allnotes and display the whole note that matches a given tag.

function searchtag {

        if [ ${INPUTTAG} == "n" ]; then
           INPUTTAG="None"
        fi

        for f in ${NOTEPATH}/*; do
            if grep -E "\bTag: ${INPUTTAG}\b" ${f}; then
                cat ${f}
            fi
        done
}

### Function searchdate ###
# Search notes by date inside directory allnotes and display the whole note that matches a given date.

function searchdate {
        for f in ${NOTEPATH}/*; do
            if grep -q "Date: ${INPUTDATE}" ${f}; then
                cat ${f}
            fi
        done
}

### Function err ###
# Display error message if an option is called without an argument

function err {
        echo "$*" >&2
        exit 1
}

# If no option, executes function create to make a new note.
# If an option is given, executes the corresponding search function.

if [ $# -eq 0 ]; then
    create
else
    while getopts ":f:t:d:h" opt; do
        case "${opt}" in
        f)
          INPUTFILE=${OPTARG}
          searchfile
          ;;
        t)
          INPUTTAG=${OPTARG}
          searchtag
          ;;
        d)
          INPUTDATE=${OPTARG}
          searchdate
          ;;
        h)
          usage
          ;;
        :) # Argument
          err "Error: Missing an Argument"
          ;;
        esac
     done
fi
