#!/bin/bash

LOCAL_DIR="/home/pi/bin/png/"
BIN_DIR="/home/pi/bin/png/"
REMOTE_DIR="/var/www/html/"
cd $LOCAL_DIR
scp *.png pi@192.168.1.19:$REMOTE_DIR

# Copy sensor values to file, to be used for HomeAutomation
REMOTE_DIR_1WIRE_TIN="/mnt/1wire/28.75437C060000"
REMOTE_DIR_1WIRE_TOUT="/mnt/1wire/28.003884050000"
scp /home/pi/bin/28.75437C060000/temperature pi@192.168.1.19:$REMOTE_DIR_1WIRE_TIN
scp /home/pi/bin/28.003884050000/temperature pi@192.168.1.19:$REMOTE_DIR_1WIRE_TOUT
