#!/bin/bash
# Script to create rrd-file 

# --step 60: 60 s (1 minute)
#
# DS:outsideTemp:GAUGE:180:-50:60
# Data Source (DS), name outsideTemp, gauge type, 
# heartbeat = 180 s, the maximum number of seconds that may pass between 
# two updates of this data source before the value of the data source is 
# assumed to be *UNKNOWN*.
# min value = -50
# max value =  60

# DS:insideTemp:GAUGE:180:-50:60 \
# Data Source (DS), name insideTemp, gauge type,
# heartbeat = 180 s, the maximum number of seconds that may pass between
# two updates of this data source before the value of the data source is
# assumed to be *UNKNOWN*.
#
# 72d with 1m res, 24 * 60 * 72 / 1 = 103680
# RRA:AVERAGE:0.5:1:103680 \
# - Average data at 1m res during 1m for 72h
#
# 28d with 15m res, 24 * 60 * 28 / 1 = 40320
# RRA:AVERAGE:0.5:30:40320 \
# - Average data at 1m during 30m for 28d
#
# 90d with 1m res, 24 * 60 * 90 / 1 = 129600
# RRA:AVERAGE:0.5:60:129600 \
# - Average data at 1m during 1h for 90d
#
# 180d with 1m res, 24 * 60 * 180 / 1 = 259200
# RRA:AVERAGE:0.5:120:259200 \
# - Average data at 1m during 2h for 180d
#
# 360d with 1m res, 24 * 60 * 360 / 1 = 518400
# RRA:AVERAGE:0.5:240:518400 \
# - Average data at 1m during 4h for 360d
#
# 730d with 1m res, 24 * 60 * 730 / 1 = 1051200
# RRA:AVERAGE:0.5:1440:1051200
# - Average data at 1m during 1d for 730d

dir="/home/pi/rrdData/"
dbName="tempMon.1.0.rrd"

# Check i file already exists
if [ ! -f "$dir$dbName" ]
then
    # File doesn't exist, create new rrd-file
    echo "Creating RRDtool DB for outside temp sensor"
    rrdtool create $dir$dbName \
	 --step 60 \
	 DS:outsideTemp:GAUGE:180:-50:60 \
         DS:insideTemp:GAUGE:180:-50:60 \
         RRA:AVERAGE:0.5:1:103680 \
         RRA:AVERAGE:0.5:30:40320 \
         RRA:AVERAGE:0.5:60:129600 \
         RRA:AVERAGE:0.5:60:259200 \
         RRA:AVERAGE:0.5:60:518400 \
         RRA:AVERAGE:0.5:60:1051200 \
         RRA:MAX:0.5:1:103680 \
         RRA:MAX:0.5:30:40320 \
         RRA:MAX:0.5:60:129600 \
         RRA:MAX:0.5:60:259200 \
         RRA:MAX:0.5:60:518400 \
         RRA:MAX:0.5:60:1051200 \
         RRA:MIN:0.5:1:103680 \
         RRA:MIN:0.5:30:40320 \
         RRA:MIN:0.5:60:129600 \
         RRA:MIN:0.5:60:259200 \
         RRA:MIN:0.5:60:518400 \
         RRA:MIN:0.5:60:1051200
    echo "Done!"
else
    echo $dir$dbName" already exists, delete it first."
fi
