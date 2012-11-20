#!/bin/bash

#prepare usb 
sudo stty 9600 -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke -F /dev/ttyACM0

sleep 3

sudo chmod 0777 /dev/ttyACM0

sleep 3

#go to app folder
cd "/home/tracktambo/TrackCentral/vendor/client/perl"

#start  process
perl SerialReader.pl

exit 0