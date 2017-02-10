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
# Good for crontab, updates all queued jobs
# to account with best priority
# -- RP

#path to your nsc_account_check script

me=`whoami`
CHECKACCOUNTS="/home/$me/bin/nsc_account_check.sh"
BLACKLIST="/home/$me/.blacklist";
touch -a $BLACKLIST

account=`$CHECKACCOUNTS | grep -v -f $BLACKLIST | head -n 1 | gawk '{print $1}'`
echo $account
for i in `squeue -u $me -t PD|grep -v JOBID|gawk '{print $1}'`; do
 #   echo $i
 #   squeue -o %a -j $i|tail -n 1
#    echo "account $account"
	if [ `squeue -o %a -j $i|tail -n 1` != $account ]; then
		if [ ! -z $1 ]; then
			echo scontrol update Jobid=$i Account=$account
		fi
		echo "Switching to $account for $i "
		scontrol update Jobid=$i Account=$account
	fi
done
