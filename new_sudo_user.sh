#!/bin/bash

if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -p "Enter password (default random) : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		if [ "$password" = "" ]; then
                	password=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32}`
        	fi

		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		#echo "$password - $pass"
		useradd -m -p $pass $username
		[ $? -eq 0 ] && echo "$username has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system"
	echo "You can run it with sudo command!"
	exit 2
fi


echo -n "Add user to sudo? [Y/n]:"
read tosudo

if [ "$tosudo" = "" ]; then
    tosudo="Y"
fi

if [ "$tosudo" = "Y" ]; then
	echo "adding $username to sudoers"
	sudo usermod -G sudo $user
	echo "added $username to sudoers"
fi

