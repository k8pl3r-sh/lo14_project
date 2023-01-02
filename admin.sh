#!/bin/bash

echo  -e "\n####### ADMIN #######"
# Variables TODO
user="admin"
machine="hostroot"
i=0

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

	if [[ -z "$1" || -z "$2" ]]; then # It check that user and machine variables are not empty
		echo "Retry by providing option <-a add | -r remove> and <hostname> please"
	fi

	if [ "$1" == "-a" ]; then # ADD HOST
		exist="false"
		for ((i=0; i<=$(jq 'length' env/host.json); i++))
		do
   			hostname=$(jq '.['$i'].name' env/host.json)

   			if [ "${hostname:1:-1}" = "$2" ]; then
   				exist="true"
   				break
   			fi
   		done

   		if [ $exist == "true"]; then
   			echo "$2 host exist already, please choose another name"

   		elif [ $exist == "false" ]; then
   			t=$(jq 'length' env/host.json) # add an item to the lenght -1 position
			jq --arg n "$2" '.['$t']={"name": $n}' env/host.json > env/temp.json && mv env/temp.json env/host.json
			echo "$2 has been created"
			# TODO: add permission for admin to access to the host jq query
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


user () { # -ua/-ud or -ra/-rd
	# user: add/delete user, add/delete droits machines (for $#)
	# -ua/ -ud <user> <*machines>

	if [ "$1" == "-ua" ]; then
		read -p 'User name: ' username
		exist="false"
		for ((i=0; i<=$(jq 'length' env/account.json); i++))
		do
   			usercheck=$(jq '.['$i'].name' env/account.json)

   			if [ "${usercheck:1:-1}" = "$username" ]; then
   				exist="true"
				echo 'Name:'
				jq '.['$i'].name' env/account.json
				echo 'Password:'
				jq '.['$i'].passwd' env/account.json
				echo 'Permissions:'
				jq '.['$i'].permissions' env/account.json

				read -p 'Change password ? (y/n): ' changePasswd
				if [ "$changePasswd" == "y" ]; then
					read -sp 'New password: ' newPasswd1
					echo ""
					read -sp 'New password (again): ' newPasswd2
		  			if [ "$newPasswd1" == "$newPasswd2" ]; then
						jq --arg newPasswd "$(echo "$newPasswd1" | md5sum )" '.['$i'].passwd |= $newPasswd' env/account.json > env/temp.json && mv env/temp.json env/account.json
						echo "Password change successful"
		  			else
						echo "Passwords are not the same"
						break
		  			fi
				else
					echo "Password not changed"
					break
				fi
   			fi
   		done

   		if [ $exist == "false" ]; then
   			echo "$username doesn't exist in this network, we are building one"
   			k=$(jq length env/account.json)
			i=$(($k+1))
   			read -sp 'New password: ' newPasswd1
        	echo ""
        	read -sp 'New password (again): ' newPasswd2
          	if [ "$newPasswd1" == "$newPasswd2" ]; then
            	jq --arg newPasswd "$(echo "$newPasswd1" | md5sum )" '.['$i'].passwd |= $newPasswd' env/account.json > env/temp.json && mv env/temp.json env/account.json
            	echo ""
            	echo "Password change successful"
          	else
            	echo "Passwords are not the same"
            	break
          	fi
   			# TODO: add a user, with $passwd and $username jq query
   			echo "$username has been created"
   		fi

	elif [ "$1" == "-ud" ]; then
		read -p 'User name to delete: ' username
		for ((i=0; i<=$(jq 'length' env/account.json); i++))
		do
   			name=$(jq '.['$i'].name' env/account.json)

   			if [ "${name:1:-1}" = "$username" ]; then
   				jq '. | del(.['$i'])' env/account.json > env/temp.json && mv env/temp.json env/account.json
   				echo "$username host has been deleted"
   				break

   			elif [ "$i" == "$(jq 'length' env/account.json)" ]; then
   				echo "$username doesn't exist in this network"
   			fi
   		done

	elif [ "$1" == "-ra" ]; then
		# TODO: -right-add
		read -p 'User name: ' username
		for ((i=0; i<=$(jq 'length' env/account.json); i++))
		do
   			usercheck=$(jq '.['$i'].name' env/account.json)

   			if [ "${usercheck:1:-1}" = "$username" ]; then
   				exist="true"
   				# TODO: if exist: add permissions
   				jq '.['$i'].permissions' env/account.json
   				IFS=' '
   				read -a 'New host permissions (separated by a space): ' permissions
   				for element in $permissions
   				do
					for ((i=0; i<=$(jq 'length' env/host.json); i++))
					do
			   			host_check=$(jq '.['$i'].name' env/host.json)

			   			if [ "${host_check:1:-1}" = "$element" ]; then
			   				# TODO add right if doesn't exist on the account
			   				# add permissions[0], permissions[1] with jq
			   				echo ""
			   			fi
			   		done
   				done
   				break
   			fi
   		done


   		if [ $exist == "false" ]; then
   			echo "$username doesn't exist in this network"
   		fi


	elif [ "$1" == "-rd" ]; then

		read -p 'User name: ' username
		for ((i=0; i<=$(jq 'length' env/account.json); i++))
		do
   			usercheck=$(jq '.['$i'].name' env/account.json)

   			if [ "${usercheck:1:-1}" = "$username" ]; then
   				exist="true"
   				# TODO: afficher permissions actuelles jq
   				IFS=' '
   				read -a 'Delete host permissions (separated by a space): ' permissions
   				for element in $permissions
   				do
					for ((i=0; i<=$(jq 'length' env/host.json); i++))
					do
			   			host_check=$(jq '.['$i'].name' env/host.json)

			   			if [ "${host_check:1:-1}" = "$element" ]; then
			   				# TODO delete right if exist on the account
			   				# remove permissions[0], permissions[1] with jq
			   				echo ""
			   			fi
			   		done
   				done
   				break
   			fi
   		done

   		if [ $exist == "false" ]; then
   			echo "$username doesn't exist in this network"
   		fi

	else
		echo "Please retry using <-ua | -ud | -ra | -rd> respectively for user add/delete and right add/delete"
	fi
}


wall () {
	echo "DEBUG: wall function"
	if [[ $1 == "-n" ]]; then
		echo ${@:2}
		# TODO: message for all users jq
		


	else
		# TODO: message pr les users connectés jq
		echo ${@:1}
	fi
}

afinger () { # $1 user to edit infos of a user
	read -p 'User: ' userInfo
    info=$(jq '.[] | select(.name == "'$userInfo'")' env/account.json)
    echo $info
    echo "####### EDITION ########"
    read -p 'Phone (enter doesn t edit): ' phone
    read -p 'Job: ' job
    if [[ -z "$phone" || -z "$job" ]]; then
    	# TODO: add "phone": "06" with jq
    	# TODO: add "job": "xxxx" with jq
    	echo "" # line to delete
    else
    	echo "You have specified no info"
    fi
    

}


while true; do
	read -p "root@hostroot > " input
	case $input in
		"host" )
			host
			;;

		"user" )
			user
			;;

		"wall" )
			wall
			;;

		"afinger" )
			afinger
			;;

		"help" )
			help_admin
			;;

		"passwd" )
			passwd
			;;

		"exit")
        	echo "You quit $machine"
      		jq '.[0].isConnected |= false' env/account.json > env/temp.json && mv env/temp.json env/account.json
      		break
      		;;
			
		*)
			# Default : on lance la chaine en bash
      		eval $input
			;;
	esac
done