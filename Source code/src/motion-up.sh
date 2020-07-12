#!/bin/bash

motionup="0"

# Loop to test ppp connection
while [ "$motionup" -eq "0" ]
do

  export testppp=`/sbin/ip link show | grep ppp | grep -c UP`
  if [ "0" -ne "$testppp" ]; 
  then

	# Run motion
	/usr/bin/motion

	# Test errorlevel  
	if [ $? -eq 0 ]
	then
	  motionup="1"
	fi

  fi

done

# infinite loop
while true ; do continue ; done
