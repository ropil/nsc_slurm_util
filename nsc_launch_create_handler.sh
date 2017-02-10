#!/bin/bash

if [ -z $3 ]; then
	echo "USAGE: $0 <hours> <hard|n_cores> <number of handlers> [<from num>]"
	exit 0
fi

workpath=`pwd`
bash=`which bash`

account=`nsc_account_get.sh`

fromnum=1
if [ ! -z $4 ]; then
	fromnum=$4
fi

let tonum=$fromnum-1+$3

for i in `seq $fromnum $tonum`; do
	name=jhand`printf "%03d" $i`.sh
	let sleeptime=10*$i
	echo "#!/bin/bash" > $name
	if [ $2 == hard ]; then
	echo "#SBATCH -N 1" >> $name
	else
	echo "#SBATCH -n $2" >> $name
	fi
	echo "#SBATCH -t $1:00:00" >> $name
	echo "#SBATCH -A $account"  >> $name
	echo "echo Running jobhandler $name" >> $name
	echo "cd $workpath" >> $name
	echo "all_done=0" >> $name
	echo "sleep $sleeptime" >> $name
	echo "while [ \$all_done -eq 0 ]; do" >> $name
	echo "	all_done=1" >> $name
	echo "	for job in \`ls ./*.job\`; do" >> $name
	echo "		targetsdone=1" >> $name
	echo "		for target in \`grep TARGET \$job|awk '{print \$2}'\`; do" >> $name
	echo "			if [ ! -e \$target ]; then" >> $name
	echo "				targetsdone=0" >> $name
	echo "			fi" >> $name
	echo "		done" >> $name
	echo "		if [ \$targetsdone -eq 1 ]; then" >> $name
	echo "			finished=1" >> $name
	echo "			for finish in \`grep FINISH \$job|awk '{print \$2}'\`; do" >> $name
	echo "				if [ ! -e \$finish ]; then" >> $name
	echo "					finished=0" >> $name
	echo "				fi" >> $name
	echo "			done" >> $name
	echo "			if [ \$finished -eq 0 ]; then" >> $name
	echo "				lockfile=\`grep LOCK \$job|awk '{print \$2}'\`" >> $name
	echo "				if [ ! -e \$lockfile ]; then" >> $name
	echo "					touch \$lockfile" >> $name
	echo "					$bash \$job" >> $name
	echo "					if [ ! \$? ]; then" >> $name
	echo "						all_done=0" >> $name
	echo "					fi" >> $name
	echo "					cd $workpath" >> $name
	echo "					rm \$lockfile" >> $name
	echo "				fi" >> $name
	echo "			fi" >> $name
	#if [ $2 == hard ]; then
	#echo "		else" >> $name
	#echo "			all_done=0" >> $name
	#fi
	echo "		fi" >> $name
	echo "	done" >> $name
	echo "done" >> $name
	echo $name
	let num=$num+1
done
