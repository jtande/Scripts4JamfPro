#! /bin/bash
#################################################################################################
#
# This script is used to reconfigure computername, hostname and localhostname
# $1 is the new computername e.g NewImac 
# $2 is the hostname e.g Imac.college.edu
# $3 is the localhostname e.g NewImac
# if using in Jamf Pro, omit sudo
# synopsis ./ChangeCompName.sh YournewComputerName YourHostName YourLocalHostname
#
# By Jacob Fosso 11/30/2018
#
###############################################################################################

sudo scutil --set ComputerName "$1"
sudo scutil --set HostName "$2"
sudo scutil --set LocalHostterName "$3"
