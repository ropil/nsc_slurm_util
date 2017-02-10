#!/bin/bash

BLACKLIST="${HOME}/.acc_blacklist";
if [ ! -e $BLACKLIST ]; then
	touch $BLACKLIST
fi

me=`whoami`
account=`nsc_account_check.sh | grep -v -f $BLACKLIST | head -n 1 | gawk '{print $1}'`
echo $account
