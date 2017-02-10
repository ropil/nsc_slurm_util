#!/bin/bash

if [ -z $1 ]; then
	echo "USAGE: $0 JOB[ JOB[ ...]]"
	exit
fi

me=`whoami`
all_launched=`squeue -u $me`;

#for each job specified
for i in $*; do
	#jobname=`echo $i|awk -F . '{print $1}'`
	ending=`awk -F . '{print $NF}' <<< $i`
	jobname=`basename $i .$ending`
	launched=`grep $jobname <<< $all_launched`;
	fin=`grep "#FINISH" $i|awk '{print $2}'`
	#if not finished
	if [ ! -e $fin ]; then
		#And not launched
		if [ -z "$launched" ]; then
			#Launch
			sbatch -J $jobname $i
		fi
	fi
done
