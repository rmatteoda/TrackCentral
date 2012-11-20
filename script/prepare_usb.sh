#!/bin/bash

#go to app folder
cd "/home/tracktambo"

#start  process
sudo stty 9600 -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke -F /dev/ttyACM0

sleep 3

sudo chmod 0777 /dev/ttyACM0

sleep 3

exit 0