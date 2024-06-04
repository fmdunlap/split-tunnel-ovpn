#!/bin/bash

# domains.txt
domains=()
exclude_ips=()

# Input files of the domains
input_domain_file="/etc/split-tunnel-ovpn/data/target_domains.txt"
input_exclude_ip_file="/etc/split-tunnel-ovpn/data/exclude_ips.txt"

# Read domains from the input file
while IFS= read -r domain; do
  domains+=("$domain")
done < <(grep -vE "^#" "$input_domain_file")

# Read exclude IPs from the input file
while IFS= read -r exclude_ip; do
  exclude_ips+=("$exclude_ip")
done < <(grep -vE "^#" "$input_exclude_ip_file")

echo "Domains: ${domains[@]}"
echo "Exclude IPs: ${exclude_ips[@]}"

# Output file
output_file="/etc/split-tunnel-ovpn/data/ip_addresses.txt"

# Clear the output file
> "$output_file"

# Find subdomains for each domain
for domain in "${domains[@]}"; do
  subdomains=$(split-tunnel-subfinder -d "$domain" -silent)
  subdomains="$domain $subdomains"

  # Resolve IP addresses for each subdomain
  for subdomain in $subdomains; do
    ips=$(dig +short "$subdomain")
    
    # Filter out non-IP strings
    filtered_ips=$(echo "$ips" | tr '\n' '\0' | grep -zoE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | tr '\0' '\n')

    echo "Subdomain: $subdomain"
    echo "IPs: $filtered_ips"
    
    for exclude_ip in "${exclude_ips[@]}"; do
      filtered_ips=$(echo "$filtered_ips" | grep -v "$exclude_ip")
    done

    echo "Filtered IPs: $filtered_ips"

    if [ -n "$filtered_ips" ]; then
      echo "$filtered_ips" >> "$output_file"
    fi
  done
done

sort -u "$output_file" > "${output_file}.tmp" && mv "${output_file}.tmp" "$output_file"

echo "IP addresses written to $output_file"
