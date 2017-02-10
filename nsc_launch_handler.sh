#!/bin/bash

me=`whoami`

for i in $*; do
	jobname=`echo $i|awk -F . '{print $1}'`
	launched=`squeue -u $me |grep $jobname`
	if [ -z "$launched" ]; then
		sbatch -J $jobname $i
	fi
done
