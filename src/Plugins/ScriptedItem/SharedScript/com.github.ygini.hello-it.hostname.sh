#!/bin/bash

# Display computer identifier as title
# Supported args for label format are:
# %C for computer name
# %H for host name
# %L for local host name (bonjour)
# values are retrived with scutil
#
# due to space handling with bash, this
# script make usage of Base64 encoded plist
# to get the requested format

. "$HELLO_IT_SCRIPT_FOLDER/com.github.ygini.hello-it.scriptlib.sh"

function updateTitleWithArgs {
    hostname=$(scutil --get HostName)
    localhostname=$(scutil --get LocalHostName)
    computername=$(scutil --get ComputerName)

    format=$(/usr/libexec/PlistBuddy -c "print format" "$HELLO_IT_PLIST_PATH")
    
    if [ -z "$format" ]
    then
    	format="%C"
    fi

    title=$(echo "$format" | sed "s/%C/$computername/g" | sed "s/%H/$hostname/g" | sed "s/%L/$localhostname/g")

    updateTitle "$title"
}

function onClickAction {
    updateTitleWithArgs $@
}

function fromCronAction {
    updateTitleWithArgs $@
}

function setTitleAction {
    updateTitleWithArgs $@
}

main $@

exit 0
