import sys
import os
import ipaddress
import struct
import socket
import argparse

# get input
parser = argparse.ArgumentParser(description='Input IP/Subnet or IP range')
parser.add_argument('IPs', type=str, help='Input IP')


def createint(strings):
    x = 0
    while x < len(strings):
        strings[x] = int(strings[x])
        x += 1
    return strings


def sort_ip(octets):
    ip = ""
    for octet in octets:
        ip += str(octet) + "."
    ip = ip[:-1]
    return ip

def main():
    args = parser.parse_args()
    useri = args.IPs
    up = []

    if '-' in useri:
        start = useri.split('-')[0]
        end = useri.split('-')[1]
        start_octets_strings = start.split('.')
        end_octets_strings = end.split('.')
        start_octets = createint(start_octets_strings)
        end_octets = createint(end_octets_strings)

        ipstruct = struct.Struct('>I')
        x, = ipstruct.unpack(socket.inet_aton(start))
        y, = ipstruct.unpack(socket.inet_aton(end))
        for i in range(x, y + 1):
            response = os.system("ping -c 1 " + socket.inet_ntoa(ipstruct.pack(i)) + " > /dev/null")
            if response == 0:
                print("Host is up:", str(socket.inet_ntoa(ipstruct.pack(i))))
                up.append(socket.inet_ntoa(ipstruct.pack(i)))

    elif '/' in useri:
        network = ipaddress.ip_network(useri)
        for address in network:
            response = os.system("ping -c 1 " + str(address) + " > /dev/null")
            if response == 0:
                print("Host is up:", str(address))
                up.append(str(address))
    else:
        print("Invalid formatting: " + useri)
        sys.exit(1)

        
    print("Hosts that are up:")
    for host in up:
        print("\t" + host)
    return up

if __name__ == "__main__":
    main()
