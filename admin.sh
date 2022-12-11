#!/bin/bash

########################## FUNCTIONS #############################

host () { # $1 = -a or -r and $2 is machine name
	if [ "$1" == "-a" ]; then
		touch ./env/"$2"
		# TODO: build json template with informations

	elif [ "$1" == "-r" ]; then
		rm ./env/"$2"
		echo "$2 host has been deleted"
	fi

}


user () {
	echo "user function"
}


wall () {
	echo "wall function"
}

afinger () {
	echo "afinger function"
}


# TODO: while avec commande exit pour déco
cmd="" # TODO: input command with options


case $cmd in
	host )
		echo "host"
		;;

	user )
		echo "user"
		;;

	wall )
		echo "wall"
		;;

	afinger )
		echo "afinger"
		;;
esac