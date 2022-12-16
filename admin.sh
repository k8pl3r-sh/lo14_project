#!/bin/bash

########################## FUNCTIONS #############################

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
		# TODO: -user-add

	elif [ "$1" == "-ur" ]; then
		# TODO: -user-delete
	fi

	elif [ "$1" == "-ur" ]; then
		# TODO: -right-add
	fi

	elif [ "$1" == "-ur" ]; then
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
cmd="" # TODO: input command with options


case $cmd in
	host )
		echo "host"
		# function and arguments
		;;

	user )
		echo "user"
		# function and arguments
		;;

	wall )
		echo "wall"
		# function and arguments
		;;

	afinger )
		echo "afinger"
		# function and arguments
		;;
esac