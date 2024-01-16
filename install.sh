#!/usr/bin/env bash

source non_sudo_check.sh

LOGS_DIR_PATH="/var/log/asus-wmi-hotkeys-driver"

source install_logs.sh

echo

# log output from every installing attempt aswell
LOGS_INSTALL_LOG_FILE_NAME=install-"$(date +"%d-%m-%Y-%H-%M-%S")".log
LOGS_INSTALL_LOG_FILE_PATH="$LOGS_DIR_PATH/$LOGS_INSTALL_LOG_FILE_NAME"

{
    if [[ $(sudo apt-get install 2>/dev/null) ]]; then
        sudo apt-get -y install libevdev2 python3-dev python3-libevdev
    elif [[ $(sudo pacman -h 2>/dev/null) ]]; then
        # arch does not have header packages (python3-dev), headers are shipped with base? python package should contains almost latest version python3.*
        sudo pacman --noconfirm --needed -S libevdev python python-libevdev
    elif [[ $(sudo dnf help 2>/dev/null) ]]; then
        sudo dnf -y install libevdev python3-devel python3-libevdev
    elif [[ $(sudo yum help 2>/dev/null) ]]; then
        # yum was replaced with newer dnf above
        sudo yum --y install libevdev python3-devel python3-libevdev
    elif [[ $(sudo zypper help 2>/dev/null) ]]; then
        sudo zypper --non-interactive install libevdev2 python3-devel python3-libevdev
    else
        echo "Not detected package manager. Driver may not work properly because required packages have not been installed. Please create an issue (https://github.com/asus-linux-drivers/asus-wmi-hotkeys-driver/issues)."
    fi

    echo

    # do not install __pycache__
    if [[ -d keys_wmi_layouts/__pycache__ ]]; then
        sudo rm -rf keys_wmi_layouts/__pycache__
    fi

    source install_layout_select.sh

    echo

    INSTALL_DIR_PATH="/usr/share/asus-wmi-hotkeys-driver"

    # selected layout will be installed under this filename
    LAYOUT_INSTALLED_FILE_NAME="layout.py"
    LAYOUT_INSTALLED_FILE="$INSTALL_DIR_PATH/keys_wmi_layouts/$LAYOUT_INSTALLED_FILE_NAME"

    LAYOUT_DIFF=""
    if test -f "$LAYOUT_INSTALLED_FILE"; then
        LAYOUT_DIFF=$(diff <(grep -v '^#' keys_wmi_layouts/$LAYOUT_NAME.py) <(grep -v '^#' $LAYOUT_INSTALLED_FILE))
    fi

    if [ "$LAYOUT_DIFF" != "" ]
    then
        read -r -p "Was found layout from previous installation which differs compared to the selected one at this moment. Do you want replace already installed layout with selected one? [y/N]" response
        case "$response" in [yY][eE][sS]|[yY])
            sudo cp keys_wmi_layouts/$LAYOUT_NAME.py keys_wmi_layouts/$LAYOUT_INSTALLED_FILE_NAME
            sudo install -t $INSTALL_DIR_PATH/keys_wmi_layouts/ keys_wmi_layouts/$LAYOUT_INSTALLED_FILE_NAME
            ;;
        *)
            LAYOUT="$INSTALL_DIR_PATH/keys_wmi_layouts/layout.py"
            echo "Is used layout from previous installation with content:"
            echo "\`"
            cat $LAYOUT
            echo
            echo "\`"
            echo
            echo "For futher modifications is located here:"
            echo $LAYOUT
            ;;
        esac
    else
        sudo cp keys_wmi_layouts/$LAYOUT_NAME.py keys_wmi_layouts/$LAYOUT_INSTALLED_FILE_NAME
        sudo install -t $INSTALL_DIR_PATH/keys_wmi_layouts/ keys_wmi_layouts/$LAYOUT_INSTALLED_FILE_NAME
    fi

    echo

    echo "Selected layout can be futher modified here: $LAYOUT_INSTALLED_FILE"

    echo

    sudo mkdir -p "$INSTALL_DIR_PATH/keys_wmi_layouts"
    sudo chown -R $USER "$INSTALL_DIR_PATH"
    sudo install asus_wmi_hotkeys.py "$INSTALL_DIR_PATH"

    echo

    source install_user_groups.sh

    echo

    source install_service.sh

    echo

    echo "Installation finished succesfully"

    echo

    read -r -p "Reboot is required. Do you want reboot now? [y/N]" response
    case "$response" in [yY][eE][sS]|[yY])
        reboot
        ;;
    *)
        ;;
    esac

    echo

    exit 0
} 2>&1 | sudo tee "$LOGS_INSTALL_LOG_FILE_PATH"