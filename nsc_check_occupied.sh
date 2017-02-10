#!/bin/bash
set -e

if [ -z $1 ]; then
	occupied=`squeue -t R|awk 'BEGIN{sum=0}{sum=sum+$7}END{print sum}'`
else
	occupied=`squeue -t R|grep $1|awk 'BEGIN{sum=0}{sum=sum+$7}END{print sum}'`
fi

echo "Nodes Occupied: $occupied"
