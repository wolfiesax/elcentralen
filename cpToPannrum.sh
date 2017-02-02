#!/bin/bash

LOCAL_DIR="/home/pi/bin/png/"
REMOTE_DIR="/var/www/html/"

cd $LOCAL_DIR
scp *.png pi@192.168.1.19:$REMOTE_DIR

# Copy sensor values to file, to be used for HomeAutomation
REMOTE_DIR_1WIRE="/mnt/1wire/1D.01F80C000000"
scp /home/pi/bin/1D.01F80C000000/counters.A pi@192.168.1.19:$REMOTE_DIR_1WIRE
