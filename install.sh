#!/bin/bash

# Checking if the script is runned as root (via sudo or other)
if [[ $(id -u) != 0 ]]
then
	echo "Please run the installation script as root (using sudo for example)"
	exit 1
fi

if [[ $(sudo apt install 2>/dev/null) ]]; then
    echo 'apt is here' && sudo apt -y install libevdev2 python3-libevdev git
elif [[ $(sudo pacman -h 2>/dev/null) ]]; then
    echo 'pacman is here' && sudo pacman --noconfirm -S libevdev python-libevdev git
elif [[ $(sudo dnf install 2>/dev/null) ]]; then
    echo 'dnf is here' && sudo dnf -y install libevdev python-libevdev git
fi

if [[ -d keys_wmi_layouts/__pycache__ ]] ; then
    rm -rf keys_wmi_layouts/__pycache__
fi


echo
echo "Select key WMI layout:"
PS3='Please enter your choice '
options=($(ls keys_wmi_layouts) "Quit")
select selected_opt in "${options[@]}"
do
    if [ "$selected_opt" = "Quit" ]
    then
        exit 0
    fi

    for option in $(ls keys_wmi_layouts);
    do
        if [ "$option" = "$selected_opt" ] ; then
            model=${selected_opt::-3}
            break
        fi
    done

    if [ -z "$model" ] ; then
        echo "invalid option $REPLY"
    else
        break
    fi
done

echo "Add asus WMI hotkeys service in /etc/systemd/system/"
cat asus_wmi_hotkeys.service | LAYOUT=$model envsubst '$LAYOUT' > /etc/systemd/system/asus_wmi_hotkeys.service

mkdir -p /usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts
mkdir -p /var/log/asus_wmi_hotkeys-driver
install asus_wmi_hotkeys.py /usr/share/asus_wmi_hotkeys-driver/
install -t /usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts keys_wmi_layouts/*.py

systemctl enable asus_wmi_hotkeys

if [[ $? != 0 ]]
then
	echo "Something gone wrong while enabling asus_wmi_hotkeys.service"
	exit 1
else
	echo "Asus WMI hotkeys service enabled"
fi

systemctl restart asus_wmi_hotkeys
if [[ $? != 0 ]]
then
	echo "Something gone wrong while enabling asus_wmi_hotkeys.service"
	exit 1
else
	echo "Asus WMI hotkeys service started"
fi

exit 0

