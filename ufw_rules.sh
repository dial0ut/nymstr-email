#!/bin/bash
#
# Run with root priveleges
# Define the standard ports for the email protocols
smtp_ports=(25 465 587)
pop_ports=(110 995)
imap_ports=(143 993)

# Allow all incoming and outgoing email traffic on these ports
for port in "${smtp_ports[@]}"; do
    ufw allow in proto tcp from any to any port $port
    ufw allow out proto tcp from any to any port $port
done

for port in "${pop_ports[@]}"; do
    ufw allow in proto tcp from any to any port $port
    ufw allow out proto tcp from any to any port $port
done

for port in "${imap_ports[@]}"; do
    ufw allow in proto tcp from any to any port $port
    ufw allow out proto tcp from any to any port $port
done

