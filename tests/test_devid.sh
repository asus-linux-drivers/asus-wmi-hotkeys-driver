#!/bin/bash

# Script try read and write range of devids defined in cycle below via /sys/kernel/debug/asus-nb-wmi/

for CURRENT_DEVID in 0x000{60079..60079}
do

	echo "${CURRENT_DEVID}" > "/sys/kernel/debug/asus-nb-wmi/dev_id"

	CURRENT_VALUE=$(cat "/sys/kernel/debug/asus-nb-wmi/dsts")

	# test read value
	if [[ $? != 0 ]]
	then
		echo "-- Current devid: ${CURRENT_DEVID} (no dsts)"
	fi

	# test write value
	echo $(echo "${CURRENT_VALUE}" | rev | cut -d' ' -f1 | rev) > "/sys/kernel/debug/asus-nb-wmi/ctrl_param"
	cat "/sys/kernel/debug/asus-nb-wmi/devs"

	if [[ $? != 0 ]]
	then
		echo "-- Current devid: ${CURRENT_DEVID} (current value ${CURRENT_VALUE} but no devs)"
	else
		echo "0x00000001" > "/sys/kernel/debug/asus-nb-wmi/ctrl_param"
		cat "/sys/kernel/debug/asus-nb-wmi/devs"
		echo "-- Current devid: ${CURRENT_DEVID} (current value ${CURRENT_VALUE} changed on 1s to \"0x00000001\")"
		sleep 1
		echo $(echo "${CURRENT_VALUE}" | rev | cut -d' ' -f1 | rev) > "/sys/kernel/debug/asus-nb-wmi/ctrl_param"
		cat "/sys/kernel/debug/asus-nb-wmi/devs"
	fi

	#exit
done