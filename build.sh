#!/bin/bash

ISOFILE=$1
KERNEL=$2
KERNELVERSION=$3

# KERNELARGS=" -u "
KERNELARGS=""

# Parse ARGS
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -k|--kernel)
    echo "Using latest mainline kernel..."
    KERNELVERSION="$2"
    KERNELARGS=" --kernel $KERNELVERSION "
    shift # past argument
    shift # past value
    ;;
    -l|--latest)
    echo "Setting latest kernel version..."
    KERNELARGS=" -u "
    shift # past argument
    # shift # past value
    ;;
    -c|--compatibility)
    echo "Setting compatibility..."
    COMPATIBILITY="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
# End args parsing

# If missing, download latest version of the script that will respin the ISO
if [ ! -f isorespin.sh ]; then
	echo "Isorespin script not found. Downloading it..."
	wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

installpackages="gnome-tweak-tool guake "
# Packages that will be installed:
# Thermal management stuff and packages
installpackages+="thermald "
installpackages+="tlp "
installpackages+="tlp-rdw  "
installpackages+="powertop "
# Nvidia
installpackages+="nvidia-390 "
installpackages+="nvidia-prime "
# Streaming and codecs for correct video encoding/play
installpackages+="va-driver-all "
installpackages+="vainfo "
if [ -n "$COMPATIBILITY" ]; then
	if [ "$COMPATIBILITY" == "bionicbeaver" ]; then
		installpackages+="libva2 "
	else
		installpackages+="libva1 "
	fi
else
	installpackages+="libva1 "
fi
installpackages+="gstreamer1.0-libav "
installpackages+="gstreamer1.0-vaapi "
# Useful music/video player with large set of codecs
installpackages+="vlc "

# Packages that will be removed:
#removepackages=""

chmod +x isorespin.sh

echo "Kernel arguments used: $KERNELARGS"

./isorespin.sh -i $ISOFILE \
	$KERNELARGS \
	-r "ppa:graphics-drivers/ppa" \
	-p "$installpackages" \
	-f wrapper-network.sh \
	-f wrapper-nvidia.sh \
	-f gnome-extensions.txt \
	-f wrapper-gnome-extensions.sh \
	-c wrapper-network.sh \
	-c wrapper-nvidia.sh \
	-g "" \
	-g "quiet splash acpi_rev_override=1"
