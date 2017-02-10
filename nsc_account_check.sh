#!/bin/bash
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
