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

if [ -z $1 ]; then
  echo "USAGE: $0 <job1> [<job2> [...]]";
  echo "";
  echo "  if TIMEEXTEND is set; extend number of hours \$TIMEEXTEND times";
  exit;
fi

extend=${TIMEEXTEND}
jobfiles=$*;
me=`whoami`
all_launched=`squeue -u $me`;

for job in ${jobfiles[@]}; do
  name=`basename $job .job`;
  launched=`grep $name <<< $all_launched`;
  finished=`grep "#FINISH" $job|awk '{print $2}'`;
  if [ ! -e $finished ]; then
    if [ -z "$launched" ]; then
      slurm=`grep $name slurm*.out|awk -F : '{print $1}'|tail -n 1`;
      timelimit=0;
      if [ ! -z $slurm ]; then
        timelimit=`grep "TIME LIMIT" $slurm|wc|awk '{print $1}'`;
      fi;
      # If the time limit killed the job
      if [ $timelimit -gt 0 ]; then
        # And we want to extend the job
        if [ ! -z $extend ]; then
          mv $job $job.tmp;
          time=`grep "#SBATCH -t" $job.tmp|awk '{print $NF}'|awk -F : '{print $1}'`;
          # Then extend $extend-times
          let newtime=${time}*${extend};
          sed 's/#SBATCH -t .*/#SBATCH -t '$newtime':00:00/' $job.tmp \
            > $job;
          rm $job.tmp;
          echo "$job $slurm (time limit extended ${extend}x)";
        else
          # Otherwise just indicate that this one died of time limit
          echo "$job $slurm (time limit)";
        fi;
      else
        # Other, unknown, reason for death; check log
        echo "$job $slurm";
      fi;
    fi;
  fi;
done;
