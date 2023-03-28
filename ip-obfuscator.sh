#!/bin/bash

interfaces=$(ifconfig -s | awk '{print $1}' | tail -n +2)
echo -e "AVAILABLE NETWORK INTERFACES AND ITS IPv4 ADDRESSES\n"
for interface in $interfaces; do
    ipv4_address=$(ifconfig $interface | grep -oP '(?<=inet\s)\d+\.\d+\.\d+\.\d+' | head -n1)
        echo "$interface: $ipv4_address"  
    if [ ! -z "$ipv4_address" ]; then
				if ! echo "$ipv4_address" | grep -Pq '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'; then
						echo "Invalid IP address: $ipv4_address"
						exit 1
				fi
				IFS='.' read -ra ipmod <<< "$ipv4_address"
				first=${ipmod[0]}
				hex=$(printf '%x' $first)
				decimal=0
				for ((i=1; i<4; i++)); do
						decimal=$((decimal + ipmod[$i] * 256 ** (3 - $i) ))
				done
				final="0x$hex.$decimal"
				echo -e "Your obfuscated IP address:"
				echo -e "\033[1;33m$final\033[0m\n"          
    else
        echo -e "$interface does not have an IP address.\n"
    fi   
done
