#!/bin/sh
#################################################################################
# wifi.sh - wifi status
#
# author: brisbin33@forums.archlinux.org
# author: mutantmonkey <mutantmonkey@gmail.com>
################################################################################

dev=eth0

ip4=`ifconfig $dev | awk -F ':' '/inet addr/ {print $2}' | cut -d ' ' -f 1`

iwconfig $dev 2>&1 | grep -q "no wireless extensions." && {
	echo "wired ${ip4}"
	exit 0
}

essid=`iwconfig $dev | awk -F '"' '/ESSID/ {print $2}'`
signal=`iwconfig $dev | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1`

echo $essid $signal $ip4
exit 0

