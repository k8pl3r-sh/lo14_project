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
	# echo "DEBUG: host function"
	if [[ -z "$1" || -z "$2" ]]; then # Check that user and machine variables are not empty
		echo "Retry by providing option <-a add | -r remove> and <hostname> please"
	fi

	if [ "$1" == "-a" ]; then
		# TODO: Test de la fonction, une fois terminée
		# TODO: if $2 existe déjà ?

		t=$(jq 'length' env/host.json) # add an item to the lenght -1 position

		jq --arg n "$2" '.['$t']={"name": $n}' env/host.json > env/temp.json && mv env/temp.json env/host.json

	elif [ "$1" == "-r" ]; then
		# TODO
		echo "$2 host has been deleted"
		# TODO if $2 doesn't exist
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
	echo "DEBUG: afinger function"
}


# TODO: while avec commande exit pour déco

while true; do
	read -p "root@hostroot > " input
	case $input in
		"host" )
			host
			;;

		"user" )
			echo "user"
			# function and arguments
			;;

		"wall" )
			echo "wall"
			# function and arguments
			;;

		"afinger" )
			echo "afinger"
			# function and arguments
			;;

		"help" )
			help_admin
			;;

		*)
			# Default : on lance la chaine en bash
      		eval $input
			;;
		# TODO (aailleurs): commande help + ajouter commandes de user
	esac
done