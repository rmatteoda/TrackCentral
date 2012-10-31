#!/usr/bin/env bash

#set rvm ruby enviroment
source /usr/local/rvm/environments/ruby-1.9.3-p286

#go to app folder
cd "/home/tracktambo/TrackCentral"

#call rake task to start system
rake "track_system:start_system"




