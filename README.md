# CSEC-Lab3-Scripts

Scripts for Network and System Security Audit Lab 3
____________________________________________________

# DNS Resolution
Language: Powershell

Summary: Takes an input file that contains DNS hostnames and resolves the corresponding IP address if one exists

# OS Detection
Language: Bash

Summary: Determines if IP(s) are either Linux or Windows based on TTL value from ping command

To Run: ./osdetec.sh <file>

# Ping Sweep
Language: Python

Summary: Determines if a host is up from a range of IP addresses or a single IP address

 IPs Acceptable Formats: IP  OR  IP-IP  OR  IP/# 
 Ports Acceptable Format: #,#  OR  #-#  OR  #

# Port Scanner
Language: Bash

Summary: Takes IP(s) and Port(s) and checks to see which ports are open on those hosts

To Run: ./portscanner.sh <IP(s)> <Ports>
  
 IPs Acceptable Formats: IP  OR  IP-IP  OR  IP/# 
 Ports Acceptable Format: #,#  OR  #-#  OR  #

# Extra Tool: DNS Reverse Resolver
Language: Powershell

Summary: Takes an input file that contains IP addresses and resolves the corresponding hostname if one exists

