#!/bin/bash

# MDiagnostics - Linux Troubleshooting Toolkit

# Function to display basic system information
display_system_info() {
    echo -e "\e[32m"
    cat << "EOF"
 ____    ____   ______     ____  ____     ______  
|_   \  /   _| |_   _ `.  |_  _||_  _|  .' ___  | 
  |   \/   |     | | `. \   \ \  / /   / .'   \_| 
  | |\  /| |     | |  | |    > `' <    | |        
 _| |_\/_| |_   _| |_.' /  _/ /'`\ \_  \ `.___.'\ 
|_____||_____| |______.'  |____||____|  `.____ .' 
                                                     
   
EOF

    echo "----------------------------------------"
    echo "Basic System Information:"
    echo "Hostname: $(hostname)"
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "Kernel Version: $(uname -r)"
    echo "----------------------------------------"
}

# Function to install and run an antivirus
install_run_antivirus() {
    echo "Installing and running antivirus..."
    # Example commands to install and run ClamAV antivirus
    sudo apt update
    sudo apt install clamav
    sudo systemctl start clamav-freshclam
    sudo systemctl start clamav-daemon
}

# Function to clear the cache
clear_cache() {
    echo "Clearing cache..."
    # Example command to clear package cache
    sudo apt clean
}

# Function to detect network problems
detect_network_problems() {
    echo "Detecting network problems..."
    # Example command to check network connectivity
    ping -c 5 google.com
}

# Function to fix repositories or reinstall/remove programs
fix_repositories_or_programs() {
    echo "Fixing repositories or managing programs..."
    # Example commands to update repositories and manage programs
    sudo apt update
    sudo apt upgrade
    sudo apt --fix-missing update
    sudo dpkg --configure -a
}

# Function to detect and handle DDoS attacks
detect_and_handle_ddos() {
    echo "Detecting and handling DDoS attacks..."
    # Example command to monitor network traffic for DDoS attacks
    sudo tcpdump -i eth0 -n -nn -vv -c 10 'udp'
}

# Function to detect packet loss
detect_packet_loss() {
    echo "Detecting packet loss..."
    # Example command to detect packet loss using mtr
    sudo apt install mtr
    mtr google.com
}

# Function to install and run speedtest
install_and_run_speedtest() {
    echo "Installing and running Speedtest..."
    # Example command to install and run speedtest-cli
    sudo apt install speedtest-cli
    speedtest-cli
}

# Function to configure iptables based on user input
configure_iptables() {
    read -p "Enter the ports to allow (comma-separated): " allowed_ports
    IFS=',' read -ra ports_array <<< "$allowed_ports"
    
    # Display iptables rules before applying
    echo "Current iptables rules:"
    sudo iptables -L -n

    # Confirm iptables configuration
    read -p "Are you sure you want to configure iptables? (y/n): " confirm
    if [[ $confirm == "y" ]]; then
        # Flush existing rules
        sudo iptables -F

        # Allow specified ports
        for port in "${ports_array[@]}"; do
            sudo iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
        done

        # Drop all other incoming traffic
        sudo iptables -A INPUT -j DROP

        echo "iptables configured to allow ports: $allowed_ports"
    else
        echo "iptables configuration cancelled."
    fi
}

# Function to uninstall a specified program
uninstall_program() {
    read -p "Enter the name of the program to uninstall: " program_name
    sudo apt remove "$program_name"
}

# Function to view Apache or Nginx logs
view_webserver_logs() {
    echo "Select a web server log to view:"
    echo "1. Apache Access Log"
    echo "2. Apache Error Log"
    echo "3. Nginx Access Log"
    echo "4. Nginx Error Log"

    read -p "Enter your choice (1-4): " log_choice

    case $log_choice in
        1) tail -n 20 /var/log/apache2/access.log ;;
        2) tail -n 20 /var/log/apache2/error.log ;;
        3) tail -n 20 /var/log/nginx/access.log ;;
        4) tail -n 20 /var/log/nginx/error.log ;;
        *) echo "Invalid choice. Exiting." ;;
    esac
}

# Function to check SSH connections and display users and IPs
check_ssh_connections() {
    echo "Checking SSH connections..."
    # Display connected users and their IPs
    who
    echo "----------------------------------------"
    echo "IP addresses connected via SSH:"
    netstat -tn | awk '{print $5}' | grep -E ":[0-9]+" | cut -d':' -f1 | sort -u
}

# Function to grep for a specific pattern in syslog
grep_syslog_pattern() {
    read -p "Enter the pattern to search for in syslog: " pattern
    echo "Searching for pattern '$pattern' in syslog..."
    grep "$pattern" /var/log/syslog
}

# Display basic system information
display_system_info

# Provide options for troubleshooting
echo "Select an option for troubleshooting:"
echo "1. Install and run antivirus"
echo "2. Clear cache"
echo "3. Detect network problems"
echo "4. Fix repositories or manage programs"
echo "5. Detect and handle DDoS attacks"
echo "6. Detect packet loss"
echo "7. Install and run speedtest"
echo "8. Configure iptables for specific ports"
echo "9. Uninstall a program"
echo "10. View Apache or Nginx logs"
echo "11. Check SSH connections"
echo "12. Grep a pattern in syslog"

read -p "Enter your choice (1-12): " choice

case $choice in
    1) install_run_antivirus ;;
    2) clear_cache ;;
    3) detect_network_problems ;;
    4) fix_repositories_or_programs ;;
    5) detect_and_handle_ddos ;;
    6) detect_packet_loss ;;
    7) install_and_run_speedtest ;;
    8) configure_iptables ;;
    9) uninstall_program ;;
    10) view_webserver_logs ;;
    11) check_ssh_connections ;;
    12) grep_syslog_pattern ;;
    *) echo "Invalid choice. Exiting." ;;
esac
