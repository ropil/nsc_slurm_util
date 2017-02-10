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
	echo "USAGE: $0 JOB[ JOB[ ...]]"
	exit
fi

me=`whoami`;
all_launched=`squeue -u $me`;

#for each job specified
for i in $*; do
	jobname=`echo $i|awk -F . '{print $1}'`;
	launched=`grep $jobname <<< $all_launched`;
	fin=`grep "#FINISH" $i|awk '{print $2}'`;
	#if not finished
	if [ ! -e $fin ]; then
		#And not launched
		if [ -z "$launched" ]; then
			#Launch
			sbatch --reservation=devel -J $jobname $i;
		fi;
	fi;
done;
