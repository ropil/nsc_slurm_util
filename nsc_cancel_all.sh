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

me=`whoami`;

if [ ! -z $1 ]; then
	for i in `squeue -u $me|grep -v JOBID| grep $1 |gawk '{print $1}'`; do scancel $i ; done
else
	for i in `squeue -u $me|grep -v JOBID| gawk '{print $1}'`; do scancel $i ; done
fi;
