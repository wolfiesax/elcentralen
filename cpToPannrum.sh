#!/bin/bash

LOCAL_DIR="/home/pi/png/"
REMOTE_DIR="/var/www/html/"

cd $LOCAL_DIR
scp *.png pi@10.0.1.19:$REMOTE_DIR
