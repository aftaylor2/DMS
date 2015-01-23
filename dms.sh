#!/bin/bash
##########################################################################
# Deads Mans Switch
# by Andrew Taylor <ataylor> @ [phr3ak] :dot: (com)
# Based on idea proposed by Viktor Petersson - http://bit.ly/1CkN4by
# To be used on a system with full disk encryption
##########################################################################
#                       PROOF OF CONCEPT ONLY
##########################################################################
# INSTRUCTIONS:
#  1. Generate the random file.
#     $ cd; dd if=/dev/random of=.deadmansswitch bs=100k count=1
#  2. Copy the file to the usb device to be used as a dead mans switch
#     $ cp .deadmansswitch /Volumes/<disk label>/<file name>
#  3. Edit the WATCHFILE variable in the script below.
#  4. Run this script when you need the protection of a Deads Mans Switch.
##########################################################################


# Where is the file located?
# Should be something like "/Volumes/<disk label>/<file name> on OS X.
# or "/media/<disk>/<file>" on GNU/Linux systems
WATCHFILE="/Volumes/NO NAME/file"

LOCAL_VERIFY_FILE="~.deadmanswitch"

#Software used to determine checksum.
CHECKSUMSOFT = "shasum"

# Determine checksum of local verification file on device
CHECKSUM="$($CHECKSUMSOFT "$LOCAL_VERIFY_FILE" | awk '{print $1}')"


while true; do
    if [ -f "$WATCHFILE" ]; then
    	# obtain checksum from dead mans switch (usb storage)
    	CHECKSUM_VERIFY = "$($CHECKSUMSOFT "$WATCHFILE" | awk '{print $1}')"
        #compare checksums and if they match up
        if [ "$CHECKSUM" == "$CHECKSUM_VERIFY" ]; then
            sleep 2
        #if they don't match up    
        else
			# Force Secure delete of entire directory - OS X
			# Could be slow when deleting large amounts of data. Might be safer to rely on encryption?
        	#srm -rf /path/to/directory
            
            # Supend the computer - OS X
            /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
    		
    		# Power off the computer - OS X or GNU/Linux
    		# Shutdown is slower than a suspend. But safer in regards to clearing RAM contents.
    		# To use shutdown, script should be executed by a root user or made suid.
    		#shutdown now
    	fi
	fi
done