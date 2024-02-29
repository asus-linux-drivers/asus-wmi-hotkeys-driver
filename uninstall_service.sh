#!/usr/bin/env bash

source non_sudo_check.sh

SERVICE_INSTALL_FILE_NAME="asus_wmi_hotkeys_driver.service"
SERVICE_INSTANCE_FILE_NAME="asus_wmi_hotkeys_driver.service"
SERVICE_INSTALL_DIR_PATH="/lib/systemd/system"

sudo systemctl stop "$SERVICE_INSTANCE_FILE_NAME"
if [[ $? != 0 ]]
then
    echo "Something went wrong when stopping the $SERVICE_INSTANCE_FILE_NAME"
else
    echo "Service $SERVICE_INSTANCE_FILE_NAME stopped"
fi

sudo systemctl disable "$SERVICE_INSTANCE_FILE_NAME"
if [[ $? != 0 ]]
then
    echo "Something went wrong when disabling the $SERVICE_INSTANCE_FILE_NAME"
else
    echo "Service $SERVICE_INSTANCE_FILE_NAME disabled"
fi

sudo rm -f "$SERVICE_INSTALL_DIR_PATH/$SERVICE_INSTALL_FILE_NAME"
if [[ $? != 0 ]]
then
    echo "Something went wrong when removing the $SERVICE_INSTALL_DIR_PATH/$SERVICE_INSTALL_FILE_NAME"
else
    echo "Service $SERVICE_INSTALL_DIR_PATH/$SERVICE_INSTALL_FILE_NAME removed"
fi

sudo systemctl daemon-reload

if [[ $? != 0 ]]; then
    echo "Something went wrong when was called systemctl daemon reload"
else
    echo "Systemctl daemon reloaded"
fi