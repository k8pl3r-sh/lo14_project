#!/bin/bash

echo  -e "\n####### ADMIN #######"
# Variables TODO
user="admin"
machine="hostroot"
i=$3

source functions.sh # to use user functions stored in the script

########################## FUNCTIONS #############################
help_admin () {
	help_user
	echo -e "\n###################################### ADMIN ##########################################"
	echo "'host' command allows you to     : add/remove host of the network"
	echo "'user' command allows you to     : add/remove a user, or a access right to hosts"
	echo "'wall' command allows you to     : send a message to all users on the network"
	echo "'afinger' command allows you to  : add complementary informations for users"
	echo "###################################### ADMIN ##########################################"

}


host () { # $1 = -a or -r and $2 is machine name

	if [[ -z "$1" || -z "$2" ]]; then # Check that user and machine variables are not empty
		echo "Retry by providing option <-a add | -r remove> and <hostname> please"
	fi

	if [ "$1" == "-a" ]; then # ADD HOST
		exist=false
		for ((i=0; i<=$(jq 'length' env/host.json); i++))
		do
   			hostname=$(jq '.['$i'].name' env/host.json)

   			if [ "${hostname:1:-1}" = "$2" ]; then
   				exist=true
   				break
   			fi
   		done

   		if [ $exist ]; then
   			echo "$2 host exist already, please choose another name"

   		elif [ !$exist ]; then
   			t=$(jq 'length' env/host.json) # add an item to the lenght -1 position
			jq --arg n "$2" '.['$t']={"name": $n}' env/host.json > env/temp.json && mv env/temp.json env/host.json
			echo "$2 has been created"
			# TODO: add permission for admin to access to the host
		fi

		

	elif [ "$1" == "-r" ]; then # REMOVE HOST
		for ((i=0; i<=$(jq 'length' env/host.json); i++))
		do
   			hostname=$(jq '.['$i'].name' env/host.json)

   			if [ "${hostname:1:-1}" = "$2" ]; then
   				jq '. | del(.['$i'])' env/host.json > env/temp.json && mv env/temp.json env/host.json
   				echo "$2 host has been deleted"
   				break

   			elif [ "$i" == "$(jq 'length' env/host.json)" ]; then
   				echo "$2 doesn't exist in this network"
   			fi
   		done 
	fi
}


user () { # $1 = -ua/-ud or -ra/-rd and $2 is username, $3, boucle pls args hosts
	# user: add/delete user, droits machines (for $#)
	# -ua/ -ud <user> <*machines>

	echo "DEBUG: user function"
	if [ "$1" == "-ua" ]; then
		echo "DEBUG: user add"
		# TODO: -user-add

	elif [ "$1" == "-ur" ]; then
		echo "DEBUG: user delete"
		# TODO: -user-delete

	elif [ "$1" == "-ur" ]; then
		echo "DEBUG: right add"
		# TODO: -right-add
		# jq '.access.allowed_users += ["test32"]'
		# jq '.[] | select(.name == "'$2'") | '

	elif [ "$1" == "-ur" ]; then
		echo "DEBUG: right delete"
		# TODO: -right-delete
	fi
}


wall () {
	# syntax: wall message: for connected users
	# wall -n message: for all users
	echo "DEBUG: wall function"
}

afinger () { # $1 user to edit infos of a user
	read -p 'User: ' userInfo
    info=$(jq '.[] | select(.name == "'$userInfo'")' env/account.json)
    echo $info
    echo "####### EDITION ########"
    read -p 'Phone (enter doesn t edit): ' phone
    read -p 'Job: ' job
    # TODO check if not empty
    # TODO: add "phone": "06"
    # TODO: add "job": "xxxx"

}


# TODO: while avec commande exit pour déco

while true; do
	read -p "root@hostroot > " input
	case $input in
		"host" )
			host
			;;

		"user" )
			user # ONGOING
			;;

		"wall" )
			echo "wall"
			# TODO
			;;

		"afinger" )
			echo "afinger"
			# TODO
			;;

		"help" )
			help_admin
			;;

		*)
			# Default : on lance la chaine en bash
      		eval $input
			;;
	esac
done