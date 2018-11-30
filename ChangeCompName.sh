#! /usr/bin/bash
#This script is used to reconfigure computername, hostname and localhostname
# $1 is the new computername
# $2 is the hostname
# $3 is the localhostname
# synopsis ./ChangeCompName.sh YournewComputerName YourHostName YourLocalHostname

sudo scutil --set ComputerName "$1"
sudo scutil --set HostName "$2"
sudo scutil --set LocalHostterName "$3"