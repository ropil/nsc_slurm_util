#!/bin/bash
set -e

if [ -z $1 ]; then
	echo "USAGE: $0 <file.job> [<file.job> [...] ]"
	exit
fi

for i in $*; do
	cat $i |sed -e 's/\#!\/bin\/bash/\#!\/bin\/bash\n\#SBATCH -C fat/' > $i.temp
	mv $i.temp $i
done
