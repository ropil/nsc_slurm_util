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

me=`whoami`;

if [ -z $6 ]; then
	echo "USAGE: $0 <jobname> <hours> <startnum> <num> <target,target,target> [command and parameters]"
	echo ""
	echo " If \$NUMCORES is set (currently \"$NUMCORES\") the scripts will"
        echo "   be sent to cores (-n <num>) and not to nodes (-N)."
	echo ""
	echo "EXAMPLES:"
	echo "-- pconsc2 prepred --"
	echo 'num=1; for i in ????.fasta; do nsc_jobs_ass.sh pc2 24 $num 1 $i seqcov_pconsc2_prepred.sh 16 /nobackup/global/$me/db/uniprot20_2012_10/uniprot20_2012_10_klust20_dc_2012_12_10 /nobackup/global/$me/db/uniprot_trembl.fasta $i; let num=num+1; done'
	echo "-- plmdca nofrob --"
	echo 'num=1; for i in *.trimmed; do nsc_jobs_ass.sh plm 72 $num 1 $i seqcov_plmdca_nofrob.sh 8 $i; let num=num+1; done'
	echo "-- rosetta cm --"
	echo 'num=1; for i in `ls -d ./*/`; do name=`echo $i|awk -F / '\''{print $2}'\''`; for j in `ls $name/${name}*.filtered`; do fname=`echo $j|awk -F / '\''{print $NF}'\''|awk -F . '\''{print $1}'\''`; nsc_jobs_ass.sh hom 5 $num 1 $j homodock_run_rosettacm.sh 4 ${fname}*.fasta ${fname}*.filtered $name; let num=num+1; done; done'
	exit
fi

name=$1
hours=$2
snum=$3
let num=$snum+$4-1
targets=$5
cmd=${@:6}
cores=${NUMCORES}
account=`nsc_account_get.sh`

for i in `seq $snum $num`; do
	jobname=${name}_`printf "%03d" $i`
	jobfile=$jobname.job
	finish=$jobname.fin
	lock=$jobname.lck
	echo "#!/bin/bash" > $jobfile
        if [ -z ${cores} ]; then
		echo "#SBATCH -N 1" >> $jobfile
        else
		echo "#SBATCH -n ${cores}" >> $jobfile
	fi
	echo "#SBATCH -t $hours:00:00" >> $jobfile
	echo "#SBATCH -A $account" >> $jobfile
	for target in `echo $targets|awk -F , '{for (i=1;i<=NF;i++) printf "%s\n", $i;}'`; do
		echo "#TARGET $target" >> $jobfile
	done
	echo "#FINISH $finish" >> $jobfile
	echo "#LOCK $lock" >> $jobfile
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
