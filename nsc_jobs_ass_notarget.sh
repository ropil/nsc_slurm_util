#!/bin/bash
set -e

if [ -z $3 ]; then
	echo "USAGE: $0 <jobname> <hours> <startnum> <num> [command and parameters]"
	exit
fi

name=$1
hours=$2
snum=$3
let num=$snum+$4-1
cmd=${@:5}
account=`nsc_account_get.sh`

for i in `seq $snum $num`; do
	jobname=${name}_`printf "%03d" $i`
	jobfile=$jobname.job
	target=$jobfile
	finish=$jobname.fin
	echo "#!/bin/bash" > $jobfile
	echo "#SBATCH -N 1" >> $jobfile
	echo "#SBATCH -t $hours:00:00" >> $jobfile
	echo "#SBATCH -A $account" >> $jobfile
	echo "#TARGET $jobfile" >> $jobfile
	echo "#FINISH $finish" >> $jobfile
	echo "set -e" >> $jobfile
	echo "echo Running: $jobfile" >> $jobfile
	echo "echo START: \`date\`" >> $jobfile
	echo "$cmd" >> $jobfile
	echo "if [ \$? -eq 0 ]; then" >> $jobfile
       	echo "	touch $finish" >> $jobfile
	echo "fi" >> $jobfile
	echo "echo DONE: \`date\`" >> $jobfile
	
	echo "Created job: $jobfile"
done
