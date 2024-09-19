#!/bin/bash


check_even_or_odd() {
  num=$1

  if [ $((num%2)) -eq 0 ];
    then
        echo "The $user_id of $email is even number."
    else
        echo "The $user_id of $email is odd number."
    fi
}


validate_users() {
    
	tail -n +2 "$1" |  while IFS=',' read -r name email user_id rest ; do

	    name=$(echo "$name" | xargs)
        email=$(echo "$email" | xargs)
        user_id=$(echo "$user_id" | xargs)
		
        last_value=$(echo "$rest" | awk -F, '{print $NF}' | xargs)
        
        if [[ ! -z $last_value ]]; then
            user_id=$last_value
        fi
       
	   if [[ -z $name ]]; then
			echo "Warning: User has an Empty name."
			continue
        fi
        
        if [[ ! -z $user_id && ! -z $email ]];  then
            
            if [[ $user_id =~ ^[0-9]+$ ]]; then

                if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then

                    #echo "The $user_id of $email is $(check_even_or_odd $user_id) number."
					check_even_or_odd $user_id
                else
                    echo "Warning: User $name has an invalid email."
                fi
            else
                echo "Warning: User $name has an invalid user ID."
            fi
        elif [[ -z $email ]]; then
            echo "Warning: User $name has an Empty email."
        else
            echo "Warning: User $name has an Empty user ID."
        fi
        
    done
}

if [[ ! -z $1 ]]; then
   validate_users "$1"
else
  echo "Usage : t1.sh <user_file.txt>"
fi

