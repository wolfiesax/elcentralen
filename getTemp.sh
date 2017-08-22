#!/bin/bash

outTSens="28.003884050000"
inTSens="28.75437C060000"
dir="/home/pi/bin/rrdData/"
dbName="tempMon.1.0.rrd"
pngDir="/home/pi/bin/png/"

# Get temp form OWFS
outT=`cat /mnt/1wire/$outTSens/temperature|sed -e s/" "//g|awk '{$1=$1 + 0.005;printf "%.2f", $1}'`
inT=`cat /mnt/1wire/$inTSens/temperature|sed -e s/" "//g|awk \
'{$1=$1 + 0.005;printf "%.2f", $1}'`

# Copy sensor values to file, to be used for HomeAutomation
cp /mnt/1wire/$inTSens/temperature /home/pi/bin/28.75437C060000
cp /mnt/1wire/$outTSens/temperature /home/pi/bin/28.003884050000

# Update RRD database
rrdtool update $dir$dbName -t outsideTemp:insideTemp N:$outT:$inT

pngName=""
startStr=""
startStrP=""
endStrP=""
shiftStr=""
commentStrUte=""
commentStrGar=""

for k in `seq 1 7`;
do
  case "$k" in
    1)
      pngName="temp-1h.png"
      startStr="-1h"
      ;;
    2)
      pngName="temp-24h.png"
      startStr="-24h"
      ;;
    3)
      pngName="temp-7d.png"
      startStr="-1w"
      ;;
    4)
      pngName="temp-30d.png"
      startStr="-30days"
      ;;
    5)
      pngName="temp-90d.png"
      startStr="-90days"
      ;;
    6)
      pngName="temp-180d.png"
      startStr="-180days"
      ;;
    7)
      pngName="temp-365d.png"
      startStr="-365days"
      ;;
  esac
  echo $pngName
  echo $startStr
  /usr/bin/rrdtool graph $pngDir$pngName \
  -E \
  --imgformat PNG \
  --start $startStr \
  --end now \
  --width 600 \
  --height 200 \
  --title Temperaturmätning \
  --vertical-label '°C' \
  -l 0 \
  DEF:a=$dir$dbName:outsideTemp:AVERAGE \
  DEF:b=$dir$dbName:insideTemp:AVERAGE \
  COMMENT:"\t\t\t     Nu      Medel    Max     Min\\n" \
  HRULE:0#0000FF \
  LINE2:a#00DC00:"Ute\t\t\t" \
  GPRINT:a:LAST:"%6.1lf" \
  GPRINT:a:AVERAGE:"%6.1lf" \
  GPRINT:a:MAX:"%6.1lf" \
  GPRINT:a:MIN:"%6.1lf\\n" \
  LINE2:b#FF79FF:"Garaget\t\t" \
  GPRINT:b:LAST:"%6.1lf" \
  GPRINT:b:AVERAGE:"%6.1lf" \
  GPRINT:b:MAX:"%6.1lf" \
  GPRINT:b:MIN:"%6.1lf\\n"

  if [ "$k" == "2" ]; then
     /usr/bin/rrdtool graph $pngDir$pngName \
     -E \
     --imgformat PNG \
     --start $startStr \
     --end now \
     --width 600 \
     --height 200 \
     --title Temperaturmätning \
     --vertical-label '°C' \
     -l 0 \
     DEF:a=$dir$dbName:outsideTemp:AVERAGE \
     DEF:a2=$dir$dbName:outsideTemp:AVERAGE:start="-48h":end="start + 24h" \
     SHIFT:a2:86400 \
     DEF:b=$dir$dbName:insideTemp:AVERAGE \
     DEF:b2=$dir$dbName:insideTemp:AVERAGE:start="-48h":end="start + 24h" \
     SHIFT:b2:86400 \
     COMMENT:"\t\t\t     Nu      Medel    Max     Min\\n" \
     HRULE:0#0000FF \
     LINE2:a#00DC00:"Ute\t\t\t" \
     GPRINT:a:LAST:"%6.1lf" \
     GPRINT:a:AVERAGE:"%6.1lf" \
     GPRINT:a:MAX:"%6.1lf" \
     GPRINT:a:MIN:"%6.1lf\\n" \
     LINE2:b#FF79FF:"Garaget\t\t" \
     GPRINT:b:LAST:"%6.1lf" \
     GPRINT:b:AVERAGE:"%6.1lf" \
     GPRINT:b:MAX:"%6.1lf" \
     GPRINT:b:MIN:"%6.1lf\\n" \
     LINE2:a2#CCFFCC:"Ute (-24h)\\n" \
     LINE2:b2#FFCCCC:"Garaget (-24h)"
  fi

done
