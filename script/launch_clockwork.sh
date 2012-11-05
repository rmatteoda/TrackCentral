#!/bin/bash

#set rvm ruby enviroment
source /usr/local/rvm/environments/ruby-1.9.3-p286

#go to app folder
cd "/home/tracktambo/TrackCentral"

#start clockwork process
rake "track_system:start_clockwork"
#clockwork "config/clock.rb"

exit 0