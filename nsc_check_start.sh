#!/bin/bash
#just because typing this is faster

ME=`whoami`

if [ ! -z $1 ]; then
	ME=$1
fi

squeue -u $ME --start | grep -v JOBID |sort -k 6
