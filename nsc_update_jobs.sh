#!/bin/bash
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
