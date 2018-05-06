#!/bin/bash

pkill -9 chromium-browser
pkill -9 ruby
sleep 1
cd /home/pi/coincooler/
bundle exec rails s -e production &
sleep 15
chromium-browser --app=http://localhost:3000 --start-fullscreen &
