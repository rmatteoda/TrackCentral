#!/bin/bash
sleep 1
cd "/Users/ramiro/Workspace/workspace_ror/TrackCentral" &&
sleep 2
#sleep 2
passenger start -p 3020 -e development &
#ruby script/rails s -p 3020 &
rake track_system:open_gui &
#'bash'
