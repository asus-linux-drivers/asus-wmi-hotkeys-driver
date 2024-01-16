#!/usr/bin/env bash

source non_sudo_check.sh

GROUP_NAME=asuswmihotkeysdriver

# INHERIT
if [ -z "$LOGS_DIR_PATH" ]; then
    LOGS_DIR_PATH="/var/log/asus-wmi-hotkeys-driver"
fi

sudo groupadd "asuswmihotkeysdriver"

sudo usermod -a -G "$GROUP_NAME" "$USER"

if [[ $? != 0 ]]; then
    echo "Something went wrong when adding the group $GROUP_NAME to current user"
    exit 1
else
    echo "Added group $GROUP_NAME to current user"
fi

sudo mkdir -p "$LOGS_DIR_PATH"
sudo chown -R ":$GROUP_NAME" "$LOGS_DIR_PATH"
sudo chmod -R g+w "$LOGS_DIR_PATH"