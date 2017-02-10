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
#
# prints accounts and priority ordered by priority
#  -- RP

	#who are you
me=`whoami`
host=`hostname`
grantfile="/etc/beowulf/grantfile"

	#find accounts
accounts=()
for i in `grep $me $grantfile | gawk -F , '{print $1}'`; do
	accounts+=($i)
done;

	#get account vector length
acclen=${#accounts[*]}

accinfo=""

	#iterate over all accounts
	#parsing out the account priority
for ((i=0; i<acclen; i++)); do
    if [[ `hostname` == "triolith" ]]; then
	accinfo=${accinfo}`echo ${accounts[$i]} \`sshare -A ${accounts[$i]} 2> /dev/null|head -n 3 |tail -n 1|gawk '{print $6}'\``;
    else
	accinfo=${accinfo}`echo ${accounts[$i]} \`sshare -A ${accounts[$i]} 2> /dev/null|head -n 4 |tail -n 1|gawk '{print $7}'\``;
    fi
	if [ $((i+1-acclen)) != 0 ]; then
		accinfo=${accinfo}"\n"
	fi
done;

	#sort and print
echo -e $accinfo | sort -rk 2
