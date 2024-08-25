<h1>System Monitoring Scripts</h1>

This script provides a comprehensive view of your system's performance and network statistics. It can display information about CPU usage, memory usage, network statistics, disk usage, system load, memory usage details, process monitoring, and service status.

FOR SCRIPT 1-

Features
1. CPU Usage: Lists the top 10 processes consuming CPU.
   ```
   ./script.sh -cpu
2. Memory Usage: Lists the top 10 processes consuming memory.
   ```
   ./script.sh -mem
3. Network Monitoring: Shows network connections, packet drops, and traffic statistics.
   ```
   ./script.sh -network
4. Disk Usage: Displays disk space usage and highlights partitions over 80% usage.
   ```
   ./script.sh -disk
5. System Load: Shows the current system load and CPU usage breakdown.
   ```
   ./script.sh -load
6. Memory Usage Details: Provides detailed memory and swap usage statistics.
   ```
   ./script.sh -memusage
7. Process Monitoring: Displays the number of active processes and the top 5 processes by CPU and memory usage.
   ```
   ./script.sh -processes
8. Service Monitoring: Checks the status of specified services (e.g., sshd, nginx, apache2, iptables).
   ```
    ./script.sh -services


  FOR SCRIPT 2 - 
  * This script provides various functionalities for monitoring and managing system security and performance. It can list users and groups, check for non-standard users, validate password security, and monitor system configurations.
1. list_users: Lists all users on the server.
2. list_groups: Lists all groups on the server.
3. check_non_std_users: Checks for users with UID 0 and reports their status.
4. list_users_with_no_pw: Lists users who do not have a password set.
5. check_weak_pw: Checks for weak passwords based on certain criteria.
6. show_world_writable_files: Lists files with world writable permissions.
7. show_world_writable_directories: Lists directories with world writable permissions.
8. check_ssh_permissions: Checks .ssh directories for secure permissions.
9. check_suid_sgid_sets: Checks for files with SUID and SGID bits set.
10. list_services_and_check_authorization: Lists running services and checks if they are authorized.
11. check_services: Checks and configures services like sshd and iptables.
12. check_std_ports: Checks if services are listening on insecure ports.

```
./script.sh [option]
```
Replace [option] with one of the following:

1. -users for listing users.
2. -groups for listing groups.
3. -non-std-users for checking non-standard users.
4. -users-without-pw for listing users with no password.
5. -weak-pw for checking weak passwords.
6. -writable-files for showing world writable files.
7. -writable-directories for showing world writable directories.
8. -ssh-permissions for checking SSH directory permissions.
9. -suid-sgid-sets for checking SUID and SGID bits.
10. -service-authorization for listing services and checking authorization.
11. -services for checking the status of critical services.
12. -std-ports for checking services listening on insecure ports.
