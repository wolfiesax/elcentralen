#!/bin/bash
# Script to create rrd-file for energy monitoring

directory="/home/pi/rrdData/"
filename="energyMon.rrd"

# --step 60: 60 s (1 minute) 
# DS:energy:COUNTER:1200:0:U
# Data Source (DS), name eMon, counter type,  
# Heartbeat = 1200 s (20 min), the maximum number of seconds that may pass 
# between two updates of this data source before the value of the data source is
# assumed to be *UNKNOWN*.
# min value = 0
# max value = (U)ndefined

# 30 days with 1 min resolution, 24 * 60 * 30 / 1 = 43200
#
# 7d with 1 min res, 24 * 60 * 7 / 1 = 10080
# 10080 * 5 = 50400, # of samples to save
# 
# 30d (~1 month) with 1 min res, 24 * 60 * 30 / 1 = 43200
# 43200 * 5 = 216000
# 
# 3 months (90 days) with 1 min resolution, 24 * 60 * 90 / 1 = 129600
# 6 months (180 days) with 1 min resolution, 24 * 60 * 180 / 1 = 259200
# 1 year with 1 min resolution, 24 * 60 * 365 / 1 = 525600

# RRA:AVERAGE:0.5:30:175200
# Yields average over 10 years with 30 min resolution, 
# 24 * 60 * 365 * 10 / 30 = 175200

# Check i file already exists  
if [ ! -f "$directory$filename" ]
then
  # File doesn't exist, create new rrd-file
  echo "Creating RRDtool DB for energy monitoring"
  rrdtool create $directory$filename \
  --step 60 \
DS:eMon:COUNTER:1200:0:U \
RRA:AVERAGE:0.5:1:43200 \
RRA:AVERAGE:0.5:15:50400 \
RRA:AVERAGE:0.5:15:216000 \
RRA:AVERAGE:0.5:30:129600 \
RRA:AVERAGE:0.5:30:259200 \
RRA:AVERAGE:0.5:60:525600
else
  echo $directory$filename" already exists, delete it first."
fi
