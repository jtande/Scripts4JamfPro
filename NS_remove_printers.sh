#!/bin/bash
SYNOPSIS="
          ###################################################################
          #
          # This script will uninstall all printers or a specific printer
          # 
          # SYNOPSIS:
          #  ./NS_remove_printers.sh <All>/<PrintersName>
          #			
          #                                                                                                                                                                 
          # Auth: Jacob Fosso Tande. 12/14/2018                                                                                                                             
          #                                                                                                                                                                 
          ###################################################################"

FLAG="$1"

if [[ $FLAG = "All" || $FLAG = "all" || $FLAG = "ALL" ]]; then
    for printer in `/usr/bin/lpstat -p | awk '{print $2}'` 
    do
	/usr/sbin/lpadmin -x $printer
    done
elif [[ $FLAG = "-help" || $FLAG = "-h" || $FLAG = "-H" || $FLAG = "-Help" ]]; then
   echo "    "
    echo " $SYNOPSIS   "
    echo "              "  
else
    /usr/sbin/lpadmin -x $FLAG
fi