#!/bin/bash

list_users(){
        echo "List Users on server"
        echo "-----------------------------------------------------------------"

        getent passwd | awk -F: '{print $1}'
        echo "================================================================="
}

list_groups(){
        echo "List Groups on server"
        echo "-----------------------------------------------------------------"

        getent group | awk -F: '{print $1}'
        echo "================================================================="
}

check_non_std_users() {
    echo "Check users with UID 0"
    echo "-----------------------------------------------------------------"
    std_users=("root" "bin" "sys" "daemon" "adm" "mail" "www-data")


    getent passwd | awk -F: '$3 == 0 {print $1}' | while read -r username; do

        if [[ " ${std_users[@]} " =~ " $username " ]]; then
            echo "Standard user with UID 0: $username"
        else
            echo "Non-Standard user with UID 0: $username"
        fi
    done

    echo "================================================================="
echo " "
}

list_users_with_no_pw() {
    echo "Check users with no password"
    echo "-----------------------------------------------------------------"

    # Print the entire /etc/shadow file for debugging
    echo "Contents of /etc/shadow:"
    sudo cat /etc/shadow
    echo "-----------------------------------------------------------------"

    # Retrieve users with no password
    echo "Users with no password:"
    getent shadow | awk -F: '($2 == "") {print $1}'

    echo "================================================================="
    echo " "
}

llist_users_with_no_pw(){
        echo "Check users with no password"
        echo "-----------------------------------------------------------------"

        getent shadow | awk -F: '($2 == "") {print $1}'

        echo "================================================================="
        echo " "
}

check_weak_pw(){
        echo "Check users with weak password"
        echo "-----------------------------------------------------------------"

        check_pw(){
                local pw=$1
                if [[ ${#pw} -ge 6 && "$pw" =~ [0-9] && "$pw" =~ [\!\@\#\$\%\&\^\<\>\?\:\;] ]]
                then
                        return 1
                else
                        return 0
                fi
        }

        getent shadow | awk -F: '($2 != "" && $2 != "*" && $2 != "!" && $2 != "!!") {print $1 " " $2}' | while read -r username password;
do
        if ! check_pw "$password"; then
                echo "Weak password for user: $username"
                fi
        done
        echo "================================================================="
        echo " "

}


show_world_writable_files(){
	echo "Scannig world writable files"
	echo "-----------------------------------------------------------------"
    find /home /var /tmp -type f -perm -002 -print 2>/dev/null
	echo "================================================================="
    echo " "
}

show_world_writable_directories(){
	echo "Scannig world writable directories"
    echo "-----------------------------------------------------------------"
	find / -type d -perm -002 -print 2>/dev/null
	echo "================================================================="
    echo " "
}

check_ssh_permissions(){
	echo "Check .ssh directories and permissions"
    echo "-----------------------------------------------------------------"
	
	find / -type d -name ".ssh" 2>/dev/null | while read -r dir; do
    echo "Checking directory: $dir"

    dir_perm=$(stat -c %a "$dir")
    if [ "$dir_perm" -ne 700 ]; then
        echo "Warning: $dir has insecure permissions: $dir_perm"
    else
        echo "Info: $dir has secure permissions: $dir_perm"
    fi
	done
	echo "================================================================="
    echo " "
}

check_suid_sgid_sets(){
	echo "Check files with SUID bit set "
    echo "-----------------------------------------------------------------"
	find / -type f -perm -4000 -exec ls -l {} + 2>/dev/null
	
	echo ""

    echo "Check files with SGID bit set "
    echo "-----------------------------------------------------------------"
	find / -type f -perm -2000 -exec ls -l {} + 2>/dev/null

	echo "================================================================="
    echo " "
}

list_services_and_check_authorization(){
	echo "List running services"
	echo "-----------------------------------------------------------------"
	autorized_services=("ssh" "nginx" "apache2" "mysql" "cron")
	
	if command -v systemctl &> /dev/null; then
		running_services=$(systemctl --type=service --state=running | awk '{print $1}' | sed 's/.services//')
	else
		echo "Not found"
		exit 1
	fi

	echo "Check service is authorized or not"
	echo "-----------------------------------------------------------------"
	autorized_services=("ssh" "nginx" "apache2" "mysql" "cron")

	for service in $running_services;
	do
		if [[ ! " ${autorized_services[@]} " =~ " ${service} " ]]; 
			then
				echo "Unauthorized service found: $service"
		fi
	done

	echo "================================================================="
    echo " "
}

check_services(){
	echo "Checking sshd service"
    echo "-----------------------------------------------------------------"

	if systemctl is-active --quiet sshd; then
		echo "sshd is running."
	else
		echo "ssh is not running...Starting it now."
		sudo systemctl start sshd
		sudo systemctl enable sshd
	fi
	
	echo "Checking iptables service"
	if sudo iptables -L | grep -q "22";
	then 
		echo "Iptables set properly."
		sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
		sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
		sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
		sudo iptables -A INPUT -j DROP
		sudo iptables-save > /etc/iptables/rules.v4
	fi

	echo "================================================================="
    echo " "
}

check_std_ports(){
	echo "Check services listening on insecure ports "
    echo "-----------------------------------------------------------------"

	std_ports=(22 80 443 25 110 143)
	
	listening_ports=$(ss -tuln | awk '/LISTEN/ {print $5}' | cut -d: -f2 | sort -u)
	for port in $listening_ports; do
	if [[ ! " ${std_ports[@]} " =~ " ${port} " ]]; then
		echo "Warning service is listening on insecure port"
	fi
done

	echo "================================================================="
    echo " "
}

show_world_writable_directories(){
	echo "Scannig world writable directories"
    echo "-----------------------------------------------------------------"
	find / -type d -perm -002 -print 2>/dev/null
	echo "================================================================="
    echo " "
}



# list_users
# list_groups
# check_non_std_users
# list_users_with_no_pw
# check_weak_pw
# show_world_writable_files
# show_world_writable_directories
# check_ssh_permissions
# check_suid_sgid_sets
# list_services_and_check_authorization
# check_services
# check_std_ports
# show_world_writable_directories


main() {

    case $1 in
        -users)
                list_users
                ;;
        -groups)
                list_groups
                ;;
        -non-std-users)
                check_non_std_users
                ;;
        -users-without-pw)
                list_users_with_no_pw
                ;;
        -weak-pw)
                check_weak_pw
                ;;
        -writable-files)
                show_world_writable_files
                ;;
        -writable-directories)
                show_world_writable_directories
                ;;
        -ssh-permissions)
                check_ssh_permissions
                ;;
		-suid-sgid-sets)
                check_suid_sgid_sets
                ;;
		-service-authorization)
                list_services_and_check_authorization
                ;;
		-services)
                check_services
                ;;
		-std-ports)
                check_std_ports
                ;;
        *)
                echo "Usage: $0 {-list_users|-list_groups|-check_non_std_users|-list_users_with_no_pw|-show_world_writable_files|-check_weak_pw|-show_world_writable_directories|-check_ssh_permissions|-check_suid_sgid_sets|-list_services_and_check_authorization|-check_services|-check_std_ports}"
                exit 1
                ;;
    esac
}

main "$@"
