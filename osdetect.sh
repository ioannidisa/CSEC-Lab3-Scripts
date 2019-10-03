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
for item in $lines;
do
    ttlstr=$(ping -c1 $item | grep -o 'ttl=[0-9][0-9]*') || { 
        continue;}
    ttl="${ttlstr#*=}"
    echo "$ttl"
    if [ $ttl -eq 64 ]
    then
        echo "Host: $item  OS: Linux"
    fi
    if [ $ttl -eq 128 ]
    then
        echo "Host: $item  OS: Windows"
    fi
done