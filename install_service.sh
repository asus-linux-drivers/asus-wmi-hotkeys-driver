#!/usr/bin/env bash

source non_sudo_check.sh

# INHERIT VARS
if [ -z "$CONFIG_FILE_DIR_PATH" ]; then
    CONFIG_FILE_DIR_PATH="/usr/share/asus-wmi-hotkeys-driver"
fi
if [ -z "$LOGS_DIR_PATH" ]; then
    LOGS_DIR_PATH="/var/log/asus-wmi-hotkeys-driver"
fi

echo "Systemctl service"
echo

read -r -p "Do you want install systemctl service? [y/N]" RESPONSE
case "$RESPONSE" in [yY][eE][sS]|[yY])

    SERVICE_BASE_NAME=asus_wmi_hotkeys_driver
    SERVICE_FILE_PATH=$SERVICE_BASE_NAME.service
    SERVICE_X11_FILE_PATH=$SERVICE_BASE_NAME.x11.service
    SERVICE_INSTALL_FILE_NAME="asus_wmi_hotkeys_driver@.service"
    SERVICE_INSTALL_DIR_PATH="/usr/lib/systemd/user"

    XDG_RUNTIME_DIR=$(echo $XDG_RUNTIME_DIR)
    DBUS_SESSION_BUS_ADDRESS=$(echo $DBUS_SESSION_BUS_ADDRESS)
    XAUTHORITY=$(echo $XAUTHORITY)
    DISPLAY=$(echo $DISPLAY)
    XDG_SESSION_TYPE=$(echo $XDG_SESSION_TYPE)
    ERROR_LOG_FILE_PATH="$LOGS_DIR_PATH/error.log"

    echo
    echo "LAYOUT_NAME: $LAYOUT_NAME"
    echo "CONFIG_FILE_DIR_PATH: $CONFIG_FILE_DIR_PATH"
    echo
    echo "env var DISPLAY: $DISPLAY"
    echo "env var AUTHORITY: $XAUTHORITY"
    echo "env var XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"
    echo "env var DBUS_SESSION_BUS_ADDRESS: $DBUS_SESSION_BUS_ADDRESS"
    echo "env var XDG_SESSION_TYPE: $XDG_SESSION_TYPE"
    echo
    echo "ERROR LOG FILE: $ERROR_LOG_FILE_PATH"
    echo

    if [ "$XDG_SESSION_TYPE" = "x11" ]; then
        cat "$SERVICE_X11_FILE_PATH" | CONFIG_FILE_DIR_PATH="$CONFIG_FILE_DIR_PATH/" DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS ERROR_LOG_FILE_PATH=$ERROR_LOG_FILE_PATH envsubst '$CONFIG_FILE_DIR_PATH $DISPLAY $XAUTHORITY $XDG_RUNTIME_DIR $DBUS_SESSION_BUS_ADDRESS $ERROR_LOG_FILE_PATH' | sudo tee "$SERVICE_INSTALL_DIR_PATH/$SERVICE_INSTALL_FILE_NAME" >/dev/null
    elif [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        cat "$SERVICE_FILE_PATH" | CONFIG_FILE_DIR_PATH="$CONFIG_FILE_DIR_PATH/" DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS ERROR_LOG_FILE_PATH=$ERROR_LOG_FILE_PATH envsubst '$CONFIG_FILE_DIR_PATH $DISPLAY $XAUTHORITY $XDG_RUNTIME_DIR $DBUS_SESSION_BUS_ADDRESS $ERROR_LOG_FILE_PATH' | sudo tee "$SERVICE_INSTALL_DIR_PATH/$SERVICE_INSTALL_FILE_NAME" >/dev/null
    else
        cat "$SERVICE_FILE_PATH" | CONFIG_FILE_DIR_PATH="$CONFIG_FILE_DIR_PATH/" DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS ERROR_LOG_FILE_PATH=$ERROR_LOG_FILE_PATH envsubst '$CONFIG_FILE_DIR_PATH $DISPLAY $XAUTHORITY $XDG_RUNTIME_DIR $DBUS_SESSION_BUS_ADDRESS $ERROR_LOG_FILE_PATH' | sudo tee "$SERVICE_INSTALL_DIR_PATH/$SERVICE_INSTALL_FILE_NAME" >/dev/null
    fi

    systemctl --user daemon-reload

    if [[ $? != 0 ]]; then
        echo "Something went wrong when was called systemctl daemon reload"
        exit 1
    else
        echo "Systemctl daemon reloaded"
    fi

    systemctl enable --user $SERVICE_BASE_NAME@$USER.service

    if [[ $? != 0 ]]; then
        echo "Something went wrong when enabling the $SERVICE_BASE_NAME"
        exit 1
    else
        echo "Service $SERVICE_BASE_NAME enabled"
    fi

    systemctl restart --user $SERVICE_BASE_NAME@$USER.service
    if [[ $? != 0 ]]; then
        echo "Something went wrong when starting the $SERVICE_BASE_NAME"
        exit 1
    else
        echo "Service $SERVICE_BASE_NAME started"
    fi
esac