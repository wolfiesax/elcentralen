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
# RRA:AVERAGE:0.5:1m:24h \
# - Average data at 1m during 1m for 24h
# RRA:AVERAGE:0.5:30m:1w \
# - Average data at 1m during 30m for 1w
# RRA:AVERAGE:0.5:1h:1M \
# - Average data at 1m during 1h for 1M
# RRA:AVERAGE:0.5:1h:3M \
# - Average data at 1m during 1h for 3M
# RRA:AVERAGE:0.5:1d:6M \
# - Average data at 1m during 1d for 6M
# RRA:AVERAGE:0.5:1d:1y
# - Average data at 1m during 1d for 1y

# Check i file already exists  
if [ ! -f "$directory$filename" ]
then
  # File doesn't exist, create new rrd-file
  echo "Creating RRDtool DB for energy monitoring"
  rrdtool create $directory$filename \
  --step 60 \
DS:eMon:COUNTER:1200:0:U \
RRA:AVERAGE:0.5:1m:24h \
RRA:AVERAGE:0.5:30m:1w \
RRA:AVERAGE:0.5:1h:1M \
RRA:AVERAGE:0.5:1h:3M \
RRA:AVERAGE:0.5:1d:6M \
RRA:AVERAGE:0.5:1d:1y
else
  echo $directory$filename" already exists, delete it first."
fi
