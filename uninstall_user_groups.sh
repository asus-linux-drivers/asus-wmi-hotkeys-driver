#!/usr/bin/env bash

source non_sudo_check.sh

sudo rm -f /usr/lib/udev/rules.d/99-asus-wmi-hotkeys-driver-uinput.rules

if [[ $? != 0 ]]; then
    echo "Something went wrong when removing the uinput udev rule"
fi

sudo rm -f /etc/modules-load.d/uinput-asus-wmi-hotkeys-driver.conf
if [[ $? != 0 ]]; then
    echo "Something went wrong when removing the uinput conf"
fi

sudo udevadm control --reload-rules && sudo udevadm trigger --sysname-match=uinput

if [[ $? != 0 ]]; then
    echo "Something went wrong when reloading or triggering uinput udev rules"
else
    echo "Udev rules reloaded and triggered"
fi