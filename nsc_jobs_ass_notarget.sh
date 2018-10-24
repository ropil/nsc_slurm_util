#!/bin/bash
# Copyright (C) 2017  Robert Pilstål
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
set -e

if [ -z $3 ]; then
	echo "USAGE: $0 <jobname> <hours> <startnum> <num> [command and parameters]"
  echo ""
	echo " If \$NUMCORES is set (currently \"$NUMCORES\") the scripts will"
        echo "   be sent to cores (-n <num>) and not to nodes (-N)."

	exit
fi

name=$1
hours=$2
snum=$3
let num=$snum+$4-1
cmd=${@:5}
account=`nsc_account_get.sh`
cores=${NUMCORES}

for i in `seq $snum $num`; do
	jobname=${name}_`printf "%03d" $i`
	jobfile=$jobname.job
	target=$jobfile
	finish=$jobname.fin
  echo "#!/bin/bash" > $jobfile
	if [ -z ${cores} ]; then
		echo "#SBATCH -N 1" >> $jobfile
        else
		echo "#SBATCH -n ${cores}" >> $jobfile
	fi;
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
