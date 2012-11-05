#!/usr/bin/env bash

HOME=$HOME
export HOME

PATH=$PATH
export PATH

#set rvm ruby enviroment
source /usr/local/rvm/environments/ruby-1.9.3-p286

#go to app folder
cd "/home/tracktambo/TrackCentral"

#start  process
rake "track_system:start_server"

exit 0