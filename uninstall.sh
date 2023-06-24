#!/bin/bash

if [[ $(id -u) != 0 ]]
then
	echo "Please, run this script as root (using sudo for example)"
	exit 1
fi

# for `rm` exclude !(xy)
shopt -s extglob

systemctl stop asus_wmi_hotkeys.service
if [[ $? != 0 ]]
then
	echo "asus_wmi_hotkeys.service cannot be stopped correctly..."
	exit 1
fi

systemctl disable asus_wmi_hotkeys.service
if [[ $? != 0 ]]
then
	echo "asus_wmi_hotkeys.service cannot be disabled correctly..."
	exit 1
fi

rm -f /etc/systemd/system/asus_wmi_hotkeys.service
if [[ $? != 0 ]]
then
	echo "/etc/systemd/system/asus_wmi_hotkeys.service cannot be removed correctly..."
	exit 1
fi

LAYOUT_FILE="/usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts/layout.py"

if test -f $LAYOUT_FILE; then
	read -r -p "Do you want remove installed layout file? If contains your own changes, changes will be permanently lost. [y/N]" response
	case "$response" in [yY][eE][sS]|[yY])
		rm -rf /usr/share/asus_wmi_hotkeys-driver/
		if [[ $? != 0 ]]
		then
			echo "/usr/share/asus_wmi_hotkeys-driver cannot be removed correctly..."
			exit 1
		fi
        ;;
    *)
		rm -rf "/usr/share/asus_wmi_hotkeys-driver/"!(keys_wmi_layouts)
		if [[ $? != 0 ]]
		then
			echo "/usr/share/asus_wmi_hotkeys-driver cannot be removed correctly..."
			exit 1
		fi
		echo "Layout file in $LAYOUT_FILE has not been removed and remain in system."
        ;;
    esac
else
	rm -rf /usr/share/asus_wmi_hotkeys-driver
	if [[ $? != 0 ]]
	then
		echo "/usr/share/asus_wmi_hotkeys-driver cannot be removed correctly..."
		exit 1
	fi
fi

rm -rf /var/log/asus_wmi_hotkeys-driver
if [[ $? != 0 ]]
then
	echo "/var/log/asus_wmi_hotkeys-driver cannot be removed correctly..."
	exit 1
fi

systemctl daemon-reload

if [[ $? != 0 ]]; then
    echo "Something went wrong when was called systemctl daemon reload"
    exit 1
else
    echo "Systemctl daemon realod called succesfully"
fi

echo "Asus WMI hotkeys python driver uninstalled"
exit 0