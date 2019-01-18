#!/usr/bin/python                                                                                                                                                       
###############################################################################
#                                                                                                                                                                 
# Script will remove all but specified user account on a computer.                                                                                                   
# We will run, this especially, at the beginning of the semester                                                                    
# The user accounts to be ommitted are those known to the Natural Sciences
# There is no argument to be passed in. All the informations is internal to
# the script 
#                                                                                                                                                                 
# Auth: Jacob Fosso Tande. 01/18/2018                                                                                                                             
#                                                                                                                                                                 
###############################################################################
import subprocess as sp
import glob as gb

SKIP= ["/Users/chemadmin", "/Users/labadmin", "/Users/imageaccount", "/Users/Shared", "/Users/jamfsupport", "/Users/support", "/Users/biolabadmin", "/Users/shupfadmin"] #Argument to be passed in  

#Function to find and remove accounts
def FindRemoveAccounts():
    USERSDIR=gb.glob("/Users/*") # Read entire content of /Users directory
    for account in USERSDIR:
        #print("Debug Account Path:", account)
        if account not in SKIP:
            print("Debug Account to delete:", account)
            sp.call("rm -rf %s"%account, shell=True)  # execute shell command
    return

#Driving functions

def main():
    FindRemoveAccounts()
    return

if __name__=="__main__":
     main()
exit(0)
