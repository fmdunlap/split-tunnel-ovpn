#!/bin/bash

# Input file containing IP addresses
input_file="/etc/split-tunnel-ovpn/data/ip_addresses.txt"

# Read IP addresses from the input file and add routes
while IFS= read -r ip; do
  ip route add $ip via 10.6.5.1
done < "$input_file"