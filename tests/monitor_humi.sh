#!/bin/bash

echo "" > log

( while :; do echo "    $(date +"%T")" >> log; echo A;  sleep 15; done ) | netcat 192.168.1.236 5555  >> log 

#while true; do 
    #echo H | netcat 192.168.1.236 5555 
    #echo -e "${OUT}"
    #echo "vykdom"
    #sleep 3; 
#done
