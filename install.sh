#!/usr/bin/env bash

# Checking if the script is runned as root (via sudo or other)
if [[ $(id -u) != 0 ]]
then
	echo "Please run the installation script as root (using sudo for example)"
	exit 1
fi

if [[ $(apt install 2>/dev/null) ]]; then
    echo 'apt is here' && sudo apt -y install libevdev2 python3-libevdev
elif [[ $(pacman -h 2>/dev/null) ]]; then
    echo 'pacman is here' && sudo pacman --noconfirm -S libevdev python-libevdev
elif [[ $(dnf help 2>/dev/null) ]]; then
    echo 'dnf is here' && sudo dnf -y install libevdev python-libevdev
fi

if [[ -d keys_wmi_layouts/__pycache__ ]] ; then
    rm -rf keys_wmi_layouts/__pycache__
fi

# selected layout will be installed under this filename
keys_wmi_layout_filename="layout.py"
keys_wmi_layout_installed_file="/usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts/$keys_wmi_layout_filename"

echo
echo "Select layout from users example key WMI layouts (selected layout can be futher modified for your own needs):"
PS3='Please enter your choice '
options=($(ls -I $keys_wmi_layout_filename keys_wmi_layouts) "Quit")
select selected_opt in "${options[@]}"
do
    if [ "$selected_opt" = "Quit" ]
    then
        exit 0
    fi

    for option in $(ls keys_wmi_layouts);
    do
        if [ "$option" = "$selected_opt" ] ; then
            selected_keys_wmi_layout_filename=$selected_opt
            break
        fi
    done

    if [ -z "$selected_keys_wmi_layout_filename" ] ; then
        echo "Invalid option $REPLY"
    else
        break
    fi
done

echo "Add asus WMI hotkeys service in /etc/systemd/system/"
echo "Selected layout $selected_keys_wmi_layout_filename"
echo "Selected key WMI layout can be futher modified here:"
echo $keys_wmi_layout_installed_file

cat asus_wmi_hotkeys.service | LAYOUT=${keys_wmi_layout_filename::-3} envsubst '$LAYOUT' > /etc/systemd/system/asus_wmi_hotkeys.service

mkdir -p /usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts
mkdir -p /var/log/asus_wmi_hotkeys-driver
install asus_wmi_hotkeys.py /usr/share/asus_wmi_hotkeys-driver/
cp keys_wmi_layouts/$selected_keys_wmi_layout_filename keys_wmi_layouts/$keys_wmi_layout_filename

LAYOUT_DIFF=""
if test -f "$keys_wmi_layout_installed_file"; then
    LAYOUT_DIFF=$(diff <(grep -v '^#' keys_wmi_layouts/$keys_wmi_layout_filename) <(grep -v '^#' $keys_wmi_layout_installed_file))
fi

if [ "$LAYOUT_DIFF" != "" ]
then
    read -r -p "Was found layout from previous installation which differs compared to the selected one at this moment. Do you want anyway replace found layout with selected one at this moment? [y/N]" response
    case "$response" in [yY][eE][sS]|[yY])
		install -t /usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts/ keys_wmi_layouts/$keys_wmi_layout_filename
        ;;
    *)
        LAYOUT="/usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts/layout.py"
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
    install -t /usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts/ keys_wmi_layouts/$keys_wmi_layout_filename
fi

systemctl daemon-reload

if [[ $? != 0 ]]; then
    echo "Something went wrong when was called systemctl daemon reload"
    exit 1
else
    echo "Systemctl daemon realod called succesfully"
fi

systemctl enable asus_wmi_hotkeys.service

if [[ $? != 0 ]]
then
	echo "Something gone wrong while enabling asus_wmi_hotkeys.service"
	exit 1
else
	echo "Asus WMI hotkeys service enabled"
fi

systemctl restart asus_wmi_hotkeys.service
if [[ $? != 0 ]]
then
	echo "Something gone wrong while enabling asus_wmi_hotkeys.service"
	exit 1
else
	echo "Asus WMI hotkeys service started"
fi

exit 0