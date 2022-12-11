#!/bin/bash


########################## MAIN #############################

passwd='63a9f0ea7bb98050796b649e85481845' # root hashed in md5


if [ "$1" == "-connect" ]; then
	./user.sh $2 $3

elif [ "$1" == "-admin" ]; then
	echo "####### ADMINISTRATION #######"
	read -p 'Username: ' uservar
	read -sp 'Password: ' passvar

	if [[ "$uservar"=="admin" && "$(echo "$passvar" | md5sum )"=="$passwd" ]]; then
		./admin.sh
	fi
fi
