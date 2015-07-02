#!/bin/bash
##########################################################################
# Deads Mans Switch
# by Andrew Taylor <ataylor> @ [phr3ak] :dot: (com)
# Based on idea proposed by Viktor Petersson - http://bit.ly/1CkN4by
# To be used on a system with full disk encryption
##########################################################################
#                       PROOF OF CONCEPT ONLY
##########################################################################
# OVERVIEW:
#  1. A file is created with random data.
#     $ cd; dd if=/dev/random of=.deadmansswitch bs=100k count=1
#  2. The generated file is copied to the usb device (dead mans switch)
#     $ cp .deadmansswitch /Volumes/disk/file
#  3. Edit the WATCHFILE variable in the script below.
#  4. Run this script when you need the protection of a Deads Mans Switch.
##########################################################################

###### File Locations
# USB Drive on OSX Example: /Volumes/disk/file
# GNU/Linux Example: /media/disk/file
WATCHFILE="/Volumes/NO NAME/dmsfile"
LOCAL_VERIFY_FILE=".dmsfile"

#Software used to determine checksum.
CHECKSUMSOFT = "shasum"

if [ ! -f $LOCAL_VERIFY_FILE ]; then
    echo "DMS has not been configured!"
    echo "Generating random data..."
    cd; dd if=/dev/random of=$LOCAL_VERIFY_FILE bs=100k count=1
fi

if [ ! -f $WATCHFILE ]; then
    echo "Copying random data file to external Dead Mans Switch..."
    cp .dmsfile $WATCHFILE
fi

# Determine checksum of local verification file on device
CHECKSUM="$($CHECKSUMSOFT "$LOCAL_VERIFY_FILE" | awk '{print $1}')"

echo "DMS ENABLED"

while true; do
    if [ -f "$WATCHFILE" ]; then
    	# obtain checksum from dead mans switch (usb storage)
    	CHECKSUM_VERIFY="$($CHECKSUMSOFT "$WATCHFILE" | awk '{print $1}')"
        #compare checksums and if they match up
        if [ "$CHECKSUM" == "$CHECKSUM_VERIFY" ]; then
            sleep 2
        # If the checksums are not equal  
        else
            # Supend the computer - OS X
            /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
    		# Power off the computer - OS X or GNU/Linux
    		# Shutdown is slower than a suspend. But safer in regards to clearing RAM contents.
    		# To use shutdown, script should be executed by a root user or made suid.
    		#shutdown now
    	fi
	fi
done
