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
#if there are accounts to skip, place them in SKIP list. Edit the list to fit your need
SKIP= ["/Users/chem", "/Users/labad", "/Users/imagea", "/Users/jsupport", "/Users/subbat", "/Users/biol", "/Users/comp"] #Argument to be passed in  

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
