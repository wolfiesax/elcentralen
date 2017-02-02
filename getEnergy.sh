#!/bin/bash

# Copy sensor values to file, to be used for HomeAutomation
#W=`/usr/bin/rrdtool fetch /home/pi/bin/rrdData/energyMon.1.0.rrd AVERAGE | /usr/bin/head -4 | /usr/bin/tail -1 | /bin/sed 's/.*: //' | /usr/bin/awk {' printf "%5.9f",$1 '}`
#W_NOW=`echo "$W 3600" | /usr/bin/awk '{printf "%.0f", ($1 * $2)}'`
#W_NOW=`echo "$W 1" | /usr/bin/awk '{printf "%.0f", ($1 * $2)}'`
#/bin/echo ${W_NOW} > /home/pi/bin/1D.01F80C000000/counters.A

directory="/home/pi/bin/rrdData/"
filename="energyMon.1.0.rrd"
pngDir="/home/pi/bin/png/"

# Energy monitor with 1000 pulses per kWh.
SCALE_FACTOR=1.0
COUNT=`cat /mnt/1wire/1D.01F80C000000/counters.A|sed -e s/" "//g`
echo $COUNT

# Floating point operations in bash
VALUE=`echo "$SCALE_FACTOR $COUNT" |awk '{printf "%.0f", ($1 * $2)}'`

# Read previous counter value
CNT_PREV=`cat /home/pi/bin/counters/energy_meter`
# Update with new counter value
/bin/echo ${VALUE} > /home/pi/bin/counters/energy_meter
# Calculate delta: Number of W consumed during last minute, Wmin
CNT_DELTA=`echo "$VALUE $CNT_PREV" | /usr/bin/awk '{printf "%.0f", ($1 - $2)}'`
/bin/echo ${CNT_DELTA} > /home/pi/bin/1D.01F80C000000/counters.A

# Scale to Wh
CNT_DELTA=`echo "60 $CNT_DELTA" | /usr/bin/awk '{printf "%.0f", ($1 * $2)}'`
/bin/echo ${CNT_DELTA} > /home/pi/bin/1D.01F80C000000/counters.B

#echo $VALUE
/usr/bin/rrdtool update $directory$filename N:$VALUE

pngName=""
startStr=""

for k in `seq 1 6`;
  do
    case "$k" in
      1)
        pngName="energy-24h.png"
        startStr="-24h"
        ;;
      2)
        pngName="energy-7d.png"
        startStr="-1w"
        ;;
      3)
        pngName="energy-30d.png"
        startStr="-30days"
        ;;
      4)
        pngName="energy-90d.png"
        startStr="-90days"
        ;;
      5)
        pngName="energy-180d.png"
        startStr="-180days"
        ;;
      6)
        pngName="energy-365d.png"
        startStr="-365days"
        ;;
    esac
    /usr/bin/rrdtool graph $pngDir$pngName \
      -E \
      --imgformat PNG \
      --start $startStr \
      --end now \
      --width 600 \
      --height 150 \
      --title Elförbrukning \
      --vertical-label 'W' \
      -l 0 \
      DEF:energi=$directory$filename:eMon:AVERAGE \
      CDEF:W=energi,3600,* \
      AREA:W#AAAAee \
      LINE3:W#000000 \
      CDEF:energiK=energi,1000,/ \
      VDEF:value_sum=energiK,TOTAL \
      GPRINT:value_sum:"Förbrukad mängd\: %0.2lfkWh\n" \
      GPRINT:W:MIN:"Momentanförbrukning\: Min\: %0.2lf%sW" \
      GPRINT:W:AVERAGE:"Medel\: %0.2lf%sW" \
      GPRINT:W:MAX:"Max\: %0.2lf%sW" \
      GPRINT:W:LAST:"Just nu\: %0.2lf%sW\n" \
      COMMENT:"Terrängvägen 23, 17760, Järfälla"
done
