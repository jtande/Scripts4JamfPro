#!/bin/bash 

# Accept End User License Agreement (EULA) so there is no prompt                                                                             

if [[ -e "/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild" ]]; then
  "/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild" -license accept
fi
echo "License accepted or already acceptted"

# Just in case the xcodebuild command above fails to accept the EULA, set the license acceptance info                                        
# in /Library/Preferences/com.apple.dt.Xcode.plist. For more details on this, see Tim Sutton's post:                                         
# http://macops.ca/deploying-xcode-the-trick-with-accepting-license-agreements/                                                              

if [[ -e "/Applications/Xcode.app/Contents/Resources/LicenseInfo.plist" ]]; then
	echo "EULA failed! We will now set the license acceptance info"	
   	xcode_version_number=`/usr/bin/defaults read "/Applications/Xcode.app/Contents/"Info CFBundleShortVersionString`
   	xcode_build_number=`/usr/bin/defaults read "/Applications/Xcode.app/Contents/Resources/"LicenseInfo licenseID`
   	xcode_license_type=`/usr/bin/defaults read "/Applications/Xcode.app/Contents/Resources/"LicenseInfo licenseType`
   
   if [[ "${xcode_license_type}" == "GM" ]]; then
       /usr/bin/defaults write "/Library/Preferences/"com.apple.dt.Xcode IDEXcodeVersionForAgreedToGMLicense "$xcode_version_number"
       /usr/bin/defaults write "/Library/Preferences/"com.apple.dt.Xcode IDELastGMLicenseAgreedTo "$xcode_build_number"
    else
       /usr/bin/defaults write "/Library/Preferences/"com.apple.dt.Xcode IDEXcodeVersionForAgreedToBetaLicense "$xcode_version_number"
       /usr/bin/defaults write "/Library/Preferences/"com.apple.dt.Xcode IDELastBetaLicenseAgreedTo "$xcode_build_number"
   fi
	 	echo "License acceptance info setting completed"
fi

# DevToolsSecurity tool to change the authorization policies, such that a user who is a                                                      
# member of either the admin group or the _developer group does not need to enter an additional                                              
# password to use the Apple-code-signed debugger or performance analysis tools.                                                              

/usr/sbin/DevToolsSecurity -enable

# Add all users to developer group, if they're not admins 

 echo "Adding all users to developer group if they're not admins"
 
/usr/sbin/dseditgroup -o edit -a everyone -t group _developer

echo "Done adding users to developer group "

# If you have multiple versions of Xcode installed, specify which one you want to be current.                                                

echo "Setting default Xcode if more than one version is installed"
/usr/bin/xcode-select --switch /Applications/Xcode.app

echo "Default Xcode set"

# Bypass Gatekeeper verification for Xcode, which can take hours.  

echo "Bypassing Gatekeeper"

if [[ -e "/Applications/Xcode.app" ]]; then xattr -dr com.apple.quarantine /Applications/Xcode.app
fi
echo "Gatekeeper Bypassing complete"

# Install Mobile Device Packages so there are no prompts                                                                                     
echo "Installing mobile device packages"
##NB /usr/sbin/installer [options...] -pkg <PathToPackage> -target <device>
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/MobileDevice.pkg" ]]; then
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/MobileDevice.pkg" -target /
fi
echo "Installing mobile device packages complete"

echo "Installing mobile device development packages"
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/MobileDeviceDevelopment.pkg" ]]; then
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/MobileDeviceDevelopment.pkg" -target /
fi

echo "Installing mobile device development packages complete"

# Install XcodeExtensionSupport.pkg                                                                                                          

echo "Installing codeExtensionSupport.pkg packages"
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/XcodeExtensionSupport.pkg" ]]; then
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/XcodeExtensionSupport.pkg" -target /
fi

echo "Installing codeExtensionSupport.pkg packages complete"

# Install XcodeSystemResources.pkg                                                                                                           
echo "Installing XcodeSystemResources.pkg packages"
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/XcodeSystemResources.pkg" ]]; then
  /usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/XcodeSystemResources.pkg" -target /
fi

echo "Installing XcodeSystemResources.pkg packages complete"

# Install Command Line Tools.          
# define variable

# make sure the commanand line package is copied to the target directory in this case root /
# Check that and try to print the SDK path
# A virtual disk could be mounted and install
# move this to target directory
# mount as follows: hdiutil attach <path to  virtual disk>
# detatach virtual disk as follows: hdiutil detach /dev/disk3s2  # make sure this is the correct volume

echo "Installing Xcode CLI tools..."
if [[ -e "/Applications/Xcode.app/Contents/Resources/Packages/CommandLineToosMacOSSierraVersion10-12.pkg" ]]; then
	/usr/sbin/installer -dumplog -verbose -pkg "/Applications/Xcode.app/Contents/Resources/Packages/CommandLineToosMacOSSierraVersion10-12.pkg" -target /
	echo "Xcode CLI tools Installion is complete... cleaning up ..."
	rm "/Applications/Xcode.app/Contents/Resources/Packages/CommandLineToosMacOSSierraVersion10-12.pkg"
fi	


# Allow any member of _developer to install Apple-provided software.                                                                         
# be sure you really want to do this.                                                                                                        

#/usr/bin/security authorizationdb write system.install.apple-software authenticate-developer