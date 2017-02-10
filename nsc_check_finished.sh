#!/bin/bash

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
