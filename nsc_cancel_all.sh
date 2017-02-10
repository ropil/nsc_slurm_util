#!/bin/bash

me=`whoami`;

if [ ! -z $1 ]; then
	for i in `squeue -u $me|grep -v JOBID| grep $1 |gawk '{print $1}'`; do scancel $i ; done
else
	for i in `squeue -u $me|grep -v JOBID| gawk '{print $1}'`; do scancel $i ; done
fi;
