#!/bin/bash


########################## MAIN #############################

# User connection
if [ "$1" == "-connect" ]; then
	machine=$2
	user=$3
	if [[ -z "$2" || -z "$3" ]]; then # Check that user and machine variables are not empty
		echo "Retry by providing <machine_name> and <username> please"
	fi

	for ((i=0; i<=$(jq 'length' env/account.json); i++))  # Search in all available users
	do
   		userQuoted=$(jq '.['$i'].name' env/account.json)
   		userCheck="${userQuoted:1:-1}"
   		if [ "$userCheck" = "$user" ]; then # if user exists ...
      		for ((j=0; j<=$(jq '.['$i'].permissions | length' env/account.json); j++))
      		do
         		permQuoted=$(jq '.['$i'].permissions['$j']' env/account.json)
         		permCheck="${permQuoted:1:-1}"
         		if [ "$permCheck" = "$machine" ]; then # specific user permission check
            		echo "Hello $user" 
            		read -sp 'Password : ' passvar
            		passQuoted=$(jq '.['$i'].passwd' env/account.json)
            		passCheck="${passQuoted:1:-1}"
               			if [ "$(echo "$passvar" | md5sum )" == "$passCheck" ]; then
                  			echo "Login success"
                  			./user.sh $user $machine $i
               			else
                  			echo "Invalid password, please retry"
							continue
               			fi
         		fi
      		done
   		fi
	done

# Admin connection
elif [ "$1" == "-admin" ]; then
	echo "Hello admin" 
    read -sp 'Password : ' passvar
    passQuoted=$(jq '.['0'].passwd' env/account.json)
    passCheck="${passQuoted:1:-1}"

    if [ "$(echo "$passvar" | md5sum )" == "$passCheck" ]; then
        echo "Login success"
        ./admin.sh 
    else
        echo "Invalid password, please retry"
    fi

else
	echo "Please retry and specify a command: '-admin' or '-connect'"

fi


