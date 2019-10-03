#!/bin/bash

#check the number of arguments
if [ "$#" != "1" ]
then
    echo "Input File not specified..."
    exit 
fi

FILE="$1"
lines=`cat $FILE`
echo "$lines"

# Loop through each of the IP addresses in the file
for item in $lines;
do
    # Perform a ping to get the TTL value
    ttlstr=$(ping -c1 $item | grep -o 'ttl=[0-9][0-9]*') || { 
        continue;}
    ttl="${ttlstr#*=}"
    echo "$ttl"
    
    # TTL for Linux is 64
    if [ $ttl -eq 64 ]
    then
        echo "Host: $item  OS: Linux"
    fi
    
    # TTL for Windows is 128
    if [ $ttl -eq 128 ]
    then
        echo "Host: $item  OS: Windows"
    fi
done
