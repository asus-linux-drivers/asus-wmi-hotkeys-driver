#!/bin/bash

# Checking if the script is runned as root (via sudo or other)
if [[ $(id -u) != 0 ]]
then
	echo "Please run the installation script as root (using sudo for example)"
	exit 1
fi

if [[ $(sudo apt install 2>/dev/null) ]]; then
    echo 'apt is here' && sudo apt -y install libevdev2 python3-libevdev i2c-tools git
elif [[ $(sudo pacman -h 2>/dev/null) ]]; then
    echo 'pacman is here' && sudo pacman --noconfirm -S libevdev python-libevdev i2c-tools git
elif [[ $(sudo dnf install 2>/dev/null) ]]; then
    echo 'dnf is here' && sudo dnf -y install libevdev python-libevdev i2c-tools git
fi

modprobe i2c-dev

# Checking if the i2c-dev module is successfuly loaded
if [[ $? != 0 ]]
then
	echo "i2c-dev module cannot be loaded correctly. Make sur you have installed i2c-tools package"
	exit 1
fi

interfaces=$(for i in $(i2cdetect -l | grep DesignWare | sed -r "s/^(i2c\-[0-9]+).*/\1/"); do echo $i; done)
if [ -z "$interfaces" ]
then
    echo "No interface i2c found. Make sure you have installed libevdev packages"
    exit 1
fi

if [[ -d keys_wmi_layouts/__pycache__ ]] ; then
    rm -rf keys_wmi_layouts/__pycache__
fi


echo
echo "Select key WMI layout:"
PS3='Please enter your choice '
options=($(ls keys_wmi_layouts) "Quit")
select opt in "${options[@]}"
do
    opt=${opt::-3}
    case $opt in
        "up541ea" )
            layout=up541ea
            break
            ;;
        "Q")
            exit 0
            ;;
        *)
            echo "invalid option $REPLY";;
    esac
done

echo "Add asus WMI hotkeys service in /etc/systemd/system/"
cat asus_wmi_hotkeys.service > /etc/systemd/system/asus_wmi_hotkeys.service

mkdir -p /usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts
mkdir -p /var/log/asus_wmi_hotkeys-driver
install asus_wmi_hotkeys.py /usr/share/asus_wmi_hotkeys-driver/
install -t /usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts keys_wmi_layouts/*.py

echo "i2c-dev" | tee /etc/modules-load.d/i2c-dev.conf >/dev/null

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

