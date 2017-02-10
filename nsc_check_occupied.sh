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
set -e

if [ -z $1 ]; then
	occupied=`squeue -t R|awk 'BEGIN{sum=0}{sum=sum+$7}END{print sum}'`
else
	occupied=`squeue -t R|grep $1|awk 'BEGIN{sum=0}{sum=sum+$7}END{print sum}'`
fi

echo "Nodes Occupied: $occupied"
