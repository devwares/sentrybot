#!/bin/bash

if [ -z "$1" ]; 
then
  echo Syntax : $0 [template file] [attached file]
  exit
fi

#mailbodyfile="/usr/local/bin/motiondetectedmail.body"
#mailattachfile="/tmp/example_flower.jpg"
mailbodyfile="$1"
mailattachfile="$2"
tempfile="/tmp/mailbodyfile.tmp"
hostname="`hostname`"
mailto="%%mailto%%"
mailsubject="Alert on $hostname"
url="%%motionstreamurl%%"

# Function to replace strings in sample files
strreplace() {
    # Loop the config array
    for i in "${!confs[@]}"
    do
        search=$i
        replace=${confs[$i]}
        sed -i "s^${search}^${replace}^g" $tempfile
    done
}

cp -f $mailbodyfile $tempfile
declare -A confs
confs=(
    [%%custom01%%]=$hostname
    [%%custom02%%]=$url
    [%%custom03%%]=""
    [%%custom04%%]=""
    [%%custom05%%]=""
    [%%custom06%%]=""
)
strreplace

# Add attached file if specified
if [ -z "$2" ];
then
  mutt -s "$mailsubject" $mailto < $tempfile
else
  mutt -s "$mailsubject" $mailto -a "$2" < $tempfile
fi

# Delete temporary body file
rm -f $tempfile
