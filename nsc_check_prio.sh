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

#max number of users
MAX_USERS=99999
ME=`whoami`

if [ ! -z $1 ]; then
	ME=$1
fi

PRIO=`squeue -t PD -S "-p" -o "%u %p"|grep -v USER|grep -m 1 -B $MAX_USERS $ME|awk '{print $1}'|wc -l`

if [ $PRIO -eq 0 ]; then
	echo "No jobs in queue";
else 
	echo "$PRIO place in queue";
fi;


