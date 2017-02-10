#!/bin/bash
#
#

if [ -z $1 ]; then
  watch -n 20 "snicquota;echo;echo Running jobs:; echo; squeue -u `whoami` |head -n 1;squeue -u `whoami`|grep \" R \"; echo; echo Queued jobs:; echo; squeue -u `whoami`| grep -v \" R \"";
else
  watch -n 20 "snicquota;echo;echo Running jobs:; echo; squeue -u `whoami` |head -n 1;squeue -u `whoami`|grep \" R \"|grep $1; echo; echo Queued jobs:; echo; squeue|head -n 1; squeue -u `whoami`| grep -v \" R \"|grep $1"
fi;
