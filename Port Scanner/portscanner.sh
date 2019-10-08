#!/bin/bash

# This script uses /dev/tcp/host/port to create a tcp
# socket connection and then


# Get the Bit Netmask
netmask() {
  prefix=$1
  shift=$(( 32 - prefix ))
  mask=""
  for (( i=0; i < 32; i++ ))
  do
    num=0
    if [ $i -lt $prefix ]
    then
      num=1
    fi
    space=
    if [ $(( i % 8 )) -eq 0 ]
    then
      space=" ";
    fi
    mask="${mask}${space}${num}"
  done
  echo $mask
}

# Get the Wildcard net mask
wildcard_mask() {
  mask=$1;
  wildcard_mask=
  for octet in $mask
  do
    wildcard_mask="${wildcard_mask} $(( 255 - 2#$octet ))"
  done
  echo $wildcard_mask;
}

# Take the IP arguments and determine 
# if they are a range, cidr or single
getIPs() {
  iparg=$1
  
  # Indicates a range of IP addresses 
  if [[ $iparg = *-* ]]; 
  then           
    ip=$1
    lo=$(echo $ip | cut -d '-' -f 1)
    hi=$(echo $ip | cut -d '-' -f 2)
    first=$(echo $ip | cut -d '.' -f 1)
    second=$(echo $ip | cut -d '.' -f 2)
    third=$(echo $ip | cut -d '.' -f 3)
    lod=$(echo $lo | cut -d '.' -f 4)
    hid=$(echo $hi | cut -d '.' -f 4)
    seq -f "$first.$second.$third.%g" $lod $hid

  # Specifies CIDR Notation
  elif [[ $iparg = */* ]]; 
  then       
    ip=$1
    net=$(echo $ip | cut -d '/' -f 1)
    prefix=$(echo $ip | cut -d '/' -f 2)
    bit_netmask=$(netmask $prefix)
    wildcard_mask=$(wildcard_mask "$bit_netmask")
    i=1
    str=
    while [ $i -le 4 ]
    do
     range=$(echo $net | cut -d '.' -f $i)
     mask_octet=$(echo $wildcard_mask | cut -d ' ' -f $i)
     if [ $mask_octet -gt 0 ]
     then
      range="{$range..$(( $range | $mask_octet ))}"
     fi
     str="${str} $range"
     $i++
    done
    ips=$(echo $str | sed "s, ,\\.,g") ## replace spaces with periods, a join...
    eval echo $ips | tr ' ' '\n'

  # This is a single IP address
  else
    echo $iparg                    
  fi
}

getportnum() {
  ports=$1
  if [[ $ports = *,* ]]
  then
    ports=`echo $ports | tr ',' ' '`
  fi
  if [[ $ports = *-* ]]
  then
    start=$(echo $ports | cut -d '-' -f 1)
    end=$(echo $ports | cut -d '-' -f 2)
    ports=
    while [ "${start}" -le "${end}" ]
    do
	ports+="${start} "
	start=$(expr "${start}" + 1)
    done

  fi
  echo $ports
}


#check the number of arguments
if [ "$#" != "2" ]
then
    echo "Invalid arguments: Need <IP(s)> <Port(s)>"
    exit 
fi

ips=$(getIPs $1)
ports=$(getportnum $2)

for ip in $ips 
do
  echo "Host: $ip"
  for port in $ports 
  do
        # Uses /dev/tcp/host/port to open tcp socket connection
        timeout 1 bash -c "echo > /dev/tcp/$ip/$port" && echo "Port $port is Open" || echo "Port $port is Closed"
  done
done
