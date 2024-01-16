#!/usr/bin/env bash

source non_sudo_check.sh

LOGS_DIR_PATH="/var/log/asus-wmi-hotkeys-driver"

# log output from every uninstalling attempt aswell
LOGS_UNINSTALL_LOG_FILE_NAME=uninstall-"$(date +"%d-%m-%Y-%H-%M-%S")".log
LOGS_UNINSTALL_LOG_FILE_PATH="$LOGS_DIR_PATH/$LOGS_UNINSTALL_LOG_FILE_NAME"

# for `rm` exclude !(xy)
shopt -s extglob

{
    INSTALL_DIR_PATH="/usr/share/asus-wmi-hotkeys-driver"

	LAYOUT_FILE="$INSTALL_DIR_PATH/keys_wmi_layouts/layout.py"

	if test -f $LAYOUT_FILE; then
		read -r -p "Do you want remove installed layout file? If contains your own changes, changes will be permanently lost. [y/N]" RESPONSE
		case "$RESPONSE" in [yY][eE][sS]|[yY])
			sudo rm -rf $INSTALL_DIR_PATH
			if [[ $? != 0 ]]
			then
				echo "Something went wrong when removing files from the $INSTALL_DIR_PATH"
			fi
	        ;;
    	*)
			sudo rm -rf "$INSTALL_DIR_PATH/"!(keys_wmi_layouts)
			if [[ $? != 0 ]]
			then
				echo "Something went wrong when removing files from the $INSTALL_DIR_PATH"
			fi
			echo "Layout file in $LAYOUT_FILE has not been removed and remain in system."
        	;;
	    esac
	else
		sudo rm -rf $INSTALL_DIR_PATH
		if [[ $? != 0 ]]
		then
	    	echo "Something went wrong when removing files from the $INSTALL_DIR_PATH"
		fi
	fi

	echo "Asus WMI hotkeys driver removed"

	echo

	source uninstall_user_groups.sh

	echo

	source uninstall_service.sh

	echo

	echo "Uninstallation finished succesfully"

	echo

	read -r -p "Reboot is required. Do you want reboot now? [y/N]" RESPONSE
    case "$RESPONSE" in [yY][eE][sS]|[yY])
        reboot
        ;;
    *)
        ;;
    esac

	exit 0
} 2>&1 | sudo tee "$LOGS_UNINSTALL_LOG_FILE_PATH"