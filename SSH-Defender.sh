#!/bin/bash

# =============================================
# SSH Monitor & Auto-Block Tool
# Author: HodaCloud (hodacloud.com)
# Version: 1.3
# =============================================

# Configuration
SCRIPT_PATH="/root/ssh_monitor.sh"
CRON_CMD="/bin/bash $SCRIPT_PATH --auto"
IP_FILE="/root/ip.txt"

# Colors and Styles
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'
UNDERLINE='\033[4m'

# Box Drawing Characters
TL='\u250C' # Top-Left
TR='\u2510' # Top-Right
BL='\u2514' # Bottom-Left
BR='\u2518' # Bottom-Right
HZ='\u2500' # Horizontal
VR='\u2502' # Vertical
LT='\u251C' # Left-Tee
RT='\u2524' # Right-Tee

# Function to draw header box
draw_header() {
    echo -e "${BLUE}"
    echo -e " ${TL}══════════════════════════════════════════════════════${TR}"
    echo -e " ${VR}   ${BOLD}SSH Monitor & Auto-Block Tool${NC}${BLUE}                      ${VR}"
    echo -e " ${VR}   Powered by ${UNDERLINE}HodaCloud${NC}${BLUE} (hodacloud.com)               ${VR}"
    echo -e " ${BL}══════════════════════════════════════════════════════${BR}${NC}"
    echo
}

# Function to display the main menu
show_menu() {
    clear
    draw_header
    
    echo -e " ${BLUE}${TL}══════════════════════════════════════════════════════${TR}${NC}"
    echo -e " ${BLUE}${VR}${NC}  ${GREEN}1. View failed SSH attempts (last 30 days)          ${BLUE}${VR}${NC}"
    echo -e " ${BLUE}${LT}──────────────────────────────────────────────────────${RT}${NC}"
    echo -e " ${BLUE}${VR}${NC}  ${GREEN}2. Save failed IPs to ${YELLOW}$IP_FILE${GREEN}                  ${BLUE}${VR}${NC}"
    echo -e " ${BLUE}${LT}──────────────────────────────────────────────────────${RT}${NC}"
    echo -e " ${BLUE}${VR}${NC}  ${GREEN}3. Block IPs from ${YELLOW}$IP_FILE${GREEN}                      ${BLUE}${VR}${NC}"
    echo -e " ${BLUE}${LT}──────────────────────────────────────────────────────${RT}${NC}"
    echo -e " ${BLUE}${VR}${NC}  ${GREEN}4. View dropped packets in iptables                 ${BLUE}${VR}${NC}"
    echo -e " ${BLUE}${LT}──────────────────────────────────────────────────────${RT}${NC}"
    echo -e " ${BLUE}${VR}${NC}  ${GREEN}5. Setup automated blocking schedule                ${BLUE}${VR}${NC}"
    echo -e " ${BLUE}${LT}──────────────────────────────────────────────────────${RT}${NC}"
    echo -e " ${BLUE}${VR}${NC}  ${RED}6. Exit${NC}                                             ${BLUE}${VR}${NC}"
    echo -e " ${BLUE}${BL}══════════════════════════════════════════════════════${BR}${NC}"
    echo
    echo -e " ${YELLOW}${BOLD}Enter your choice [1-6]:${NC} \c"
}
# Function to save failed IPs
save_failed_ips() {
    echo -e "\n${BLUE}===[ Saving Failed IPs ]===${NC}"
    
    LOG_FILE="/var/log/auth.log"
    [ -f "$LOG_FILE" ] || LOG_FILE="/var/log/secure"
    
    if [ ! -f "$LOG_FILE" ]; then
        echo -e "${RED}Error: Could not find auth log file!${NC}"
        return 1
    fi
    
    grep "Failed password" "$LOG_FILE" | awk '{print $(NF-3)}' | sort -V | uniq > "$IP_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Operation completed successfully.${NC}"
        echo -e "IPs saved to ${YELLOW}$IP_FILE${NC}"
        echo -e "Unique IPs found: ${YELLOW}$(wc -l < "$IP_FILE")${NC}"
    else
        echo -e "${RED}Operation failed!${NC}"
        return 1
    fi
}

# Function to block IPs
block_ips() {
    echo -e "\n${BLUE}===[ Blocking IPs ]===${NC}"
    
    if [[ ! -f "$IP_FILE" ]]; then
        echo -e "${RED}File $IP_FILE not found!${NC}"
        return 1
    fi
    
    while IFS= read -r ip; do
        iptables -C INPUT -s "$ip" -j DROP 2>/dev/null || iptables -A INPUT -s "$ip" -j DROP
        iptables -C OUTPUT -d "$ip" -j DROP 2>/dev/null || iptables -A OUTPUT -d "$ip" -j DROP
    done < "$IP_FILE"
    
    echo -e "${GREEN}All IPs from the file have been blocked.${NC}"
    echo -e "Total IPs blocked: ${YELLOW}$(wc -l < "$IP_FILE")${NC}"
}

# Helper function to get next cron run time
get_next_cron_run() {
    local schedule=$1
    echo "Next run would be at: $(date -d "$(echo "$schedule" | sed 's/*/10/g')" 2>/dev/null || echo "Unable to determine")"
}

# Helper function to add cron job
add_cron_job() {
    local schedule=$1
    local type=$2
    
    # Check if job already exists
    if crontab -l | grep -q "$CRON_CMD"; then
        echo -e "${YELLOW}A schedule already exists. Updating...${NC}"
        remove_cron_jobs silent
    fi
    
    (crontab -l 2>/dev/null; echo "$schedule $CRON_CMD") | crontab -
    echo -e "${GREEN}$type automation has been set successfully.${NC}"
    echo -e "Next run: ${YELLOW}$(get_next_cron_run "$schedule")${NC}"
    pause
}

# Helper function to view cron jobs
view_cron_jobs() {
    echo -e "\n${BLUE}===[ Current Schedules ]===${NC}"
    local jobs=$(crontab -l 2>/dev/null | grep "$CRON_CMD")
    
    if [ -z "$jobs" ]; then
        echo -e "${YELLOW}No active schedules found.${NC}"
    else
        echo -e "${GREEN}Active schedules:${NC}"
        crontab -l | grep "$CRON_CMD" | while read -r line; do
            local schedule=$(echo "$line" | awk '{print $1,$2,$3,$4,$5}')
            echo -e "• Schedule: ${YELLOW}$schedule${NC}"
            echo -e "  Next run: ${YELLOW}$(get_next_cron_run "$schedule")${NC}"
            echo
        done
    fi
    pause
}

# Helper function to remove cron jobs
remove_cron_jobs() {
    local silent=$1
    
    crontab -l 2>/dev/null | grep -v "$CRON_CMD" | crontab -
    
    if [ -z "$silent" ]; then
        echo -e "${GREEN}All automation schedules have been removed.${NC}"
        pause
    fi
}
## Function to display failed SSH attempts
show_failed_attempts() {
    echo -e "\n${BLUE}"
    echo -e " ${TL}══════════════════════════════════════════════════════${TR}"
    echo -e " ${VR}          ${BOLD}Failed SSH Attempts (Last 30 Days)${NC}${BLUE}          ${VR}"
    echo -e " ${BL}══════════════════════════════════════════════════════${BR}${NC}"
    
    journalctl _COMM=sshd --since "30 days ago" | grep 'Failed password'
    
    echo -e "\n${BLUE}"
    echo -e " ${TL}══════════════════════════════════════════════════════${TR}"
    echo -e " ${VR}                 ${BOLD}Top 10 Attacking IPs${NC}${BLUE}                 ${VR}"
    echo -e " ${BL}══════════════════════════════════════════════════════${BR}${NC}"
    
    journalctl _COMM=sshd --since "30 days ago" | grep 'Failed password' | \
    awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -10 | \
    while read count ip; do
        echo -e " ${YELLOW}• ${count} attempts from: ${GREEN}${ip}${NC}"
    done
    
    pause
}
# Function to setup cron jobs
setup_cron() {
    while true; do
        clear
        echo -e "${BLUE}"
        echo -e " ${TL}══════════════════════════════════════════════════════${TR}"
        echo -e " ${VR}   ${BOLD}Automated Blocking Schedule${NC}${BLUE}                        ${VR}"
        echo -e " ${BL}══════════════════════════════════════════════════════${BR}${NC}"
        
        echo -e " ${BLUE}${TL}══════════════════════════════════════════════════════${TR}${NC}"
        echo -e " ${BLUE}${VR}${NC}  ${GREEN}1. Daily (runs at midnight)${NC}                         ${BLUE}${VR}${NC}"
        echo -e " ${BLUE}${LT}──────────────────────────────────────────────────────${RT}${NC}"
        echo -e " ${BLUE}${VR}${NC}  ${GREEN}2. Weekly (runs Sunday at midnight)${NC}                 ${BLUE}${VR}${NC}"
        echo -e " ${BLUE}${LT}──────────────────────────────────────────────────────${RT}${NC}"
        echo -e " ${BLUE}${VR}${NC}  ${GREEN}3. Monthly (runs 1st of each month)${NC}                 ${BLUE}${VR}${NC}"
        echo -e " ${BLUE}${LT}──────────────────────────────────────────────────────${RT}${NC}"
        echo -e " ${BLUE}${VR}${NC}  ${GREEN}4. View current schedules${NC}                           ${BLUE}${VR}${NC}"
        echo -e " ${BLUE}${LT}──────────────────────────────────────────────────────${RT}${NC}"
        echo -e " ${BLUE}${VR}${NC}  ${GREEN}5. Remove all schedules${NC}                             ${BLUE}${VR}${NC}"
        echo -e " ${BLUE}${LT}──────────────────────────────────────────────────────${RT}${NC}"
        echo -e " ${BLUE}${VR}${NC}  ${RED}6. Return to main menu${NC}                              ${BLUE}${VR}${NC}"
        echo -e " ${BLUE}${BL}══════════════════════════════════════════════════════${BR}${NC}"
        echo
        echo -e " ${YELLOW}${BOLD}Enter your choice [1-6]:${NC} \c"
        
        read cron_choice
        case $cron_choice in
            1)
                add_cron_job "0 0 * * *" "Daily"
                ;;
            2)
                add_cron_job "0 0 * * 0" "Weekly"
                ;;
            3)
                add_cron_job "0 0 1 * *" "Monthly"
                ;;
            4)
                view_cron_jobs
                ;;
            5)
                remove_cron_jobs
                ;;
            6)
                return
                ;;
            *)
                echo -e "\n${RED}Invalid option!${NC}"
                sleep 1
                ;;
        esac
    done
}
# Function to pause
pause() {
    echo
    read -p "Press [Enter] to continue..."
}

# Handle Ctrl+C
ctrl_c() {
    echo -e "\n${RED}To exit, please use option 6 from the menu.${NC}"
    show_menu
}

trap ctrl_c SIGINT

# Auto mode for cron execution
if [ "$1" == "--auto" ]; then
    save_failed_ips
    block_ips
    exit 0
fi

# Main loop
while true; do
    show_menu
    read choice
    
    case $choice in
        1)
            show_failed_attempts
            ;;
        2)
            save_failed_ips
            pause
            ;;
        3)
            block_ips
            pause
            ;;
        4)
            echo -e "\n${BLUE}===[ Dropped Packets in iptables ]===${NC}"
            iptables -L INPUT -v -n
            pause
            ;;
        5)
            setup_cron
            ;;
        6)
            echo -e "\n${GREEN}Thank you for using HodaCloud SSH Monitor!${NC}"
            echo -e "Visit us at ${BLUE}hodacloud.com${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}Invalid option! Please try again.${NC}"
            sleep 1
            ;;
    esac
done
