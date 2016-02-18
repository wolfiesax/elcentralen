#!/bin/bash

directory="/home/pi/rrdData/"
filename="energyMon.1.0.rrd"
pngDir="/home/pi/png/"

# Energy monitor with 1000 pulses per kWh.
SCALE_FACTOR=1.0
COUNT=`cat /mnt/1wire/1D.01F80C000000/counters.A|sed -e s/" "//g`
echo $COUNT

# Floating point operations in bash
VALUE=`echo "$SCALE_FACTOR $COUNT" |awk '{printf "%.0f", ($1 * $2)}'`
echo $VALUE
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

