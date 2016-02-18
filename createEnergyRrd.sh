#!/bin/bash
# Script to create rrd-file for energy monitoring

directory="/home/pi/rrdData/"
filename="energyMon.1.0.rrd"

# --step 60: 60 s (1 minute) 
# DS:energy:COUNTER:1200:0:U
# Data Source (DS), name eMon, counter type,  
# Heartbeat = 1200 s (20 min), the maximum number of seconds that may pass 
# between two updates of this data source before the value of the data source 
# is assumed to be *UNKNOWN*.
# min value = 0
# max value = (U)ndefined
#
# RRA:AVERAGE:0.5:1m:48h \
# - Average data at 1m during 1m for 48h
# RRA:AVERAGE:0.5:30m:14d \
# - Average data at 1m during 30m for 14d
# RRA:AVERAGE:0.5:1h:60d \
# - Average data at 1m during 1h for 60d
# RRA:AVERAGE:0.5:1h:180d \
# - Average data at 1m during 1h for 180d
# RRA:AVERAGE:0.5:1d:360d \
# - Average data at 1m during 1d for 360d
# RRA:AVERAGE:0.5:1d:720d
# - Average data at 1m during 1d for 720d

# Check i file already exists  
if [ ! -f "$directory$filename" ]
then
  # File doesn't exist, create new rrd-file
  echo "Creating RRDtool DB for energy monitoring"
  rrdtool create $directory$filename \
  --step 60 \
DS:eMon:COUNTER:1200:0:U \
RRA:AVERAGE:0.5:1m:48h \
RRA:AVERAGE:0.5:30m:14d \
RRA:AVERAGE:0.5:1h:60d \
RRA:AVERAGE:0.5:1h:180d \
RRA:AVERAGE:0.5:1d:360d \
RRA:AVERAGE:0.5:1d:720d
else
  echo $directory$filename" already exists, delete it first."
fi
