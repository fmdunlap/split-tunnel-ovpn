#!/bin/bash

# Prompt for CA certificate
read -p "Enter the path to your CA certificate: " ca_cert
cp "$ca_cert" /etc/split-tunnel-ovpn/creds/ca.cert

# Prompt for TA key
read -p "Enter the path to your TA key: " ta_key
cp "$ta_key" /etc/split-tunnel-ovpn/creds/ta.key

# Prompt for userpass file
read -p "Enter the path to your userpass file: " userpass_file
cp "$userpass_file" /etc/split-tunnel-ovpn/creds/userpass.txt

# Prompt for exclude IPs file
read -p "Enter the path to your exclude IPs file (optional): " exclude_ips_file
if [ -z "$exclude_ips_file" ]; then
  exclude_ips_file="/dev/null"
fi
cp "$exclude_ips_file" /etc/split-tunnel-ovpn/data/exclude_ips.txt

# Prompt for target domains file
read -p "Enter the path to your target domains file (optional): " target_domains_file
if [ -z "$target_domains_file" ]; then
  target_domains_file="/dev/null"
fi
cp "$target_domains_file" /etc/split-tunnel-ovpn/data/target_domains.txt

# Prompt for VPN IP address
read -p "Enter the IP address of your VPN server: " vpn_ip

# Prompt for VPN port
read -p "Enter the port of your VPN server: " vpn_port

# Replace placeholders in the OpenVPN configuration file
sed -i "s/REMOTE_ADDR/$vpn_ip/g" /etc/split-tunnel-ovpn/config.ovpn
sed -i "s/REMOTE_PORT/$vpn_port/g" /etc/split-tunnel-ovpn/config.ovpn

# Reload systemd daemon
systemctl daemon-reload

# Enable and start the timer
systemctl enable split-tunnel-ovpn-subdomains.timer
systemctl start split-tunnel-ovpn-subdomains.timer

echo "split-tunnel-ovpn installation completed successfully."