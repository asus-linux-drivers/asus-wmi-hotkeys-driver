#!/usr/bin/env bash

source non_sudo_check.sh

UINPUT_GROUP_NAME="uinput"

sudo groupadd "$UINPUT_GROUP_NAME"

sudo usermod -a -G "$UINPUT_GROUP_NAME" $USER

if [[ $? != 0 ]]; then
    echo "Something went wrong when adding the $UINPUT_GROUP_NAME group to the current user $USER"
    exit 1
else
    echo "Added group $UINPUT_GROUP_NAME to current user $USER"
fi

sudo modprobe uinput

# check if the uinput module is successfully loaded
if [[ $? != 0 ]]; then
    echo "uinput module cannot be loaded"
    exit 1
else
    echo "uinput module loaded"
fi

sudo chown ":$UINPUT_GROUP_NAME" /dev/uinput

echo 'KERNEL=="uinput", GROUP="uinput", MODE="0660"' | sudo tee /usr/lib/udev/rules.d/99-asus-wmi-hotkeys-driver-uinput.rules >/dev/null
echo 'uinput' | sudo tee /etc/modules-load.d/uinput-asus-wmi-hotkeys-driver.conf >/dev/null

if [[ $? != 0 ]]; then
    echo "Something went wrong when adding uinput module to auto loaded modules"
    exit 1
else
    echo "uinput module added to auto loaded modules"
fi

sudo udevadm control --reload-rules && sudo udevadm trigger --sysname-match=uinput

if [[ $? != 0 ]]; then
    echo "Something went wrong when reloading or triggering uinput udev rules"
else
    echo "Udev rules reloaded and triggered"
fi