#!/bin/bash

#set rvm ruby enviroment
source /usr/local/rvm/environments/ruby-1.9.3-p286

#go to app folder
cd "/home/tracktambo/TrackCentral"

#call rake task to stop system
rake "track_system:close_gui"

exit 0