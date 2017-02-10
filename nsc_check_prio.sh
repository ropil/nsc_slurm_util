#!/bin/bash

#max number of users
MAX_USERS=99999
ME=`whoami`

if [ ! -z $1 ]; then
	ME=$1
fi

PRIO=`squeue -t PD -S "-p" -o "%u %p"|grep -v USER|grep -m 1 -B $MAX_USERS $ME|awk '{print $1}'|wc -l`

if [ $PRIO -eq 0 ]; then
	echo "No jobs in queue";
else 
	echo "$PRIO place in queue";
fi;


