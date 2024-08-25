#!/bin/bash
show_cpu(){
        echo "1. Top 10 Most Used Applications: "
        echo "-----------------------------------------------------------------"
        echo "Top 10 processes consuming CPU"
        ps -eo pid,cmd,%cpu --sort=-%cpu | head -n 11
        echo " "


}

show_mem(){
        echo "Top 10 processes consuming CPU"
        ps -eo pid,cmd,%mem --sort=-%cpu | head -n  11
        echo "================================================================="
        echo " "
}

show_network(){
        echo "2. Network Monitoring"
        echo "-----------------------------------------------------------------"
        echo "Number of concurrent connections to the server"
        netstat -an | grep ESTABLISHED
        echo "Count is: "
        netstat -an | grep ESTABLISHED | wc -l
        echo " "
        echo "Packet drops"
        netstat -s | grep 'packets dropped'
        echo " "
                echo "Number of MB in and out"
                for interface in $(ls /sys/class/net/);
                do
                        echo "Interface: $interface"

                        vnstat_output=$(vnstat --oneline -i $interface 2>/dev/null)

                        if [ -n "$vnstat_output" ]; then

                                inbound=$(echo "$vnstat_output" | awk -F ';' '{print $4}')
                                outbound=$(echo "$vnstat_output" | awk -F ';' '{print $6}')
                                echo "Inbound: $inbound, Outbound: $outbound"
                        else
                                echo "No data available for $interface"
                        fi
                        echo " "
                done
        echo "================================================================="
        echo " "
}


show_disk_usage(){
        echo "3. Disk Usage"
        echo "-----------------------------------------------------------------"
        echo "Display the disk space usage by mounted partitions"
        df -h
        echo " "
        echo "hightlight partitions using more than 80% of the space"
        df -h | awk 'NR==1 || $5+0 > 80'
        echo "================================================================="
        echo " "

}

show_load(){
        echo "4. System Load"
        echo "-----------------------------------------------------------------"
        echo "Show the current load average for the system"
        uptime
        echo " "
        echo "Include a breakdown of CPU usage (user, system, idle, etc)"
        mpstat 1 1 | awk '/Average/ {print "User: " $3 "%", "System: " $5 "%", "Idle: " $12 "%", "I/O Wait: " $6 "%"}'
        echo "================================================================="
        echo " "
}

show_mem_usage(){
        echo "5. Memory Usage"
        echo "-----------------------------------------------------------------"
        echo "Display total, used and free memory"
        free -h | awk 'NR==2{print "Total Memory: "$2, "Used Memory: "$3, "Free Memory: "$4}'
        echo " "
        echo "Swap memory usage"
        free -h | awk 'NR==3{print "Total Swap: "$2, "Used Swap: "$3, "Free Swap: "$4}'
        echo "================================================================="
        echo " "
}

show_process_monitoring(){
        echo "6. Display the number of active processes"
        echo "-----------------------------------------------------------------"
        ps -e --no-headers | wc -l
        echo " "
        echo "Show top 5 processes in terms of CPU usage"
        ps -eo pid,cmd,%cpu --sort=%cpu | head -n 6
        echo " "
        echo "Show top 5 processes in terms of Memory usage"
        ps -eo pid,cmd,%mem --sort=%mem | head -n 6
        echo "================================================================="
        echo " "
}

show_service_monitoring(){
        echo "7. Monitor status of services like sshd, ngins/apache, iptables, etc"
        echo "-----------------------------------------------------------------"
        services=("sshd" "nginx" "apache2" "iptables")
        for service in "${services[@]}";
        do
                echo -n "Checking $service status: "
                if systemctl list-units --type=service | grep -q "$service.service";
                then
                        if systemctl is-active --quiet $service;
                        then
                                 echo "$service is Active"
                        else
                                 echo "$service is Inactive"
                        fi
                else
                        echo "Status of $service could not found"
                fi
        echo "================================================================="
                echo " "
        done
}

#show_cpu
#show_mem
#show_network
#show_disk_usage
#show_load
#show_mem_usage
#show_process_monitoring
#show_service_monitoring
#

main() {

    case $1 in
        -cpu)
                show_cpu
                ;;
        -mem)
                show_mem
                ;;
        -network)
                show_network
                ;;
        -disk)
                show_disk_usage
                ;;
        -load)
                show_load
                ;;
        -memusage)
                show_mem_usage
                ;;
        -processes)
                show_process_monitoring
                ;;
        -services)
                show_service_monitoring
                ;;
        *)
                echo "Usage: $0 {-cpu|-mem|-network|-disk|-load|-memusage|-processes|-services}"
                exit 1
                ;;
    esac
}

main "$@"
