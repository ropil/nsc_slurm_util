#!/bin/bash

me=`whoami`;

for i in `squeue --state=pending -u $me|grep -v JOBID| gawk '{print $1}'`; do scancel $i ; done
