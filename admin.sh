#!/bin/bash

echo  -e "\n####### ADMIN #######"
# Variables TODO
#user=$1
#machine=$2
#i=$3

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
	echo "DEBUG: host function"
	if [ "$1" == "-a" ]; then
		touch ./env/"$2"
		# TODO: build json template with informations of admin (for first time)

	elif [ "$1" == "-r" ]; then
		rm ./env/"$2"
		echo "$2 host has been deleted"
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