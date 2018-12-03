#!/bin/bash
#######################################################################################################################
#
# This script helps to configure Microsoft System Center Endpoint Protection (SCEP) on macOS
# The idea behind this script comes from the site:
# https://soundmacguy.wordpress.com/2017/09/18/managing-microsoft-system-center-endpoint-protection-scep-part-1/
# If you have many Mac computers on which to configure SCEP, then configure one so scep.cfg is generated.
# Open "/Library/Application Support/Microsoft/scep/etc/scep.cfg" with your test editor of choice
# scep.cfg has [global]  and [fac] blocks
# Set global parameter as follows
# "$SCEP_SET" --section=global '<line from global block>'
# repeat the statement above for each line in the global block
# Set the fac block by repeating in a similar way as with the global block substituting global with fac
# "$SCEP_SET" --section=fac '<line from fac block>'
#
#
# Auth: Jacob Tande, 12/03/2018
# Please use and give credit
#
######################################################################################################################

SCEP_SET="/Applications/System Center Endpoint Protection.app/Contents/MacOS/scep_set"
SCEP_CONFIG="/Library/Application Support/Microsoft/scep/etc/scep.cfg"
#Check for configure file, scep.cfg, if it does not exist, create one
if [[ -e "/Library/Application Support/Microsoft/scep/etc/scep.cfg" ]]; then
    echo "scep.cfg already exist. Writing into it."
else
    echo "scep.cfg does not exit, creating one ..."
    touch "$SCEP_CONFIG"       #create empty file
fi
echo "pausing to unload and load scep_daemon.plist"
sleep 5
launchctl unload -wF /Library/LaunchDaemons/com.microsoft.scep_daemon.plist
launchctl load -wF /Library/LaunchDaemons/com.microsoft.scep_daemon.plist
echo "Setting global parameters"
echo " ">"$SCEP_CONFIG"
echo "[global]">>"$SCEP_CONFIG"
"$SCEP_SET" --section=global 'privileged_users = "root:user"'
"$SCEP_SET" --section=global 'av_scan_app_unwanted = yes'
"$SCEP_SET" --section=global 'syslog_facility = "none"'
"$SCEP_SET" --section=global 'scheduler_tasks = "1;Log maintenance;;0;0 3 * * * *;@logs;3;Startup file check;disabled;0;login;@sscan lowest;4;Startup file check;;0;engine;@sscan lowest;20;Weekly scan;;0;0 2 * * * 0;@uscan scan_deep:/:/Network/Servers:;64;Regular automatic update;disabled;;repeat 60;@update;66;Automatic update after user logon;;;login 60;@update;"'
"$SCEP_SET" --section=global 'samples_send_target = ""'
"$SCEP_SET" --section=global 'av_exclude = "/System/Library/User Template/*.*::/tmp/*.*::"'
echo "Setting fac parameters"
echo " ">>"$SCEP_CONFIG"
echo "[fac]">>"$SCEP_CONFIG"
"$SCEP_SET" --section=fac 'action_av = "scan"'
"$SCEP_SET" --section=fac 'event_mask = "open:exec"'
"$SCEP_SET" --section=fac 'av_scan_ext_exclude = ".log :.cfg:.tmp:.pdf"'
launchctl unload -wF /Library/LaunchDaemons/com.microsoft.scep_daemon.plist
launchctl load -wF /Library/LaunchDaemons/com.microsoft.scep_daemon.plist
echo "SCEP Configuration complete"
exit 0
