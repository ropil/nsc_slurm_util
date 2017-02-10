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
	echo "USAGE: $0 <file.job> [<file.job> [...] ]"
	exit
fi

for i in $*; do
	cat $i |sed -e 's/\#!\/bin\/bash/\#!\/bin\/bash\n\#SBATCH -C fat/' > $i.temp
	mv $i.temp $i
done
