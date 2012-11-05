#!/bin/bash

DISPLAY=:0
export DISPLAY

#set rvm ruby enviroment
source /usr/local/rvm/environments/ruby-1.9.3-p286

#go to app folder
cd "/home/tracktambo/TrackCentral"

#start  process
rake "track_system:open_gui"

exit 0