# Asus WMI hotkeys driver

**Tested only on laptop Asus ZenBook UP5401EA** and system Elementary OS 6.1 Loki.

## TODO:

- [x] (Configurable support of key mapping)
- [x] (Solved by the way: somehow is KEY_MICMUTE of value 248 changed to 240 https://elementaryos.stackexchange.com/questions/29784/asus-zenbook-alias-for-fnf9-microphone-mute-unmute)

<br/>

Install required packages

- Debian / Ubuntu / Linux Mint / Pop!_OS / Zorin OS:
```
sudo apt install libevdev2 python3-libevdev git
```

- Arch Linux / Manjaro:
```
sudo pacman -S libevdev python-libevdev git
```

- Fedora:
```
sudo dnf install libevdev python-libevdev git
```

Now you can get the latest ASUS WMI hotkeys driver for Linux from Git and install it using the following commands.
```
git clone https://github.com/ldrahnik/asus-wmi-hotkeys-driver
cd asus-wmi-hotkeys
sudo ./install.sh
```

To uninstall, just run:
```
sudo ./uninstall.sh
```

**Troubleshooting**

To activate logger, do in a console:
```
LOG=DEBUG sudo -E ./asus_wmi_hotkeys.py
```

For some operating systems with boot failure (Pop!OS, Mint, ElementaryOS, SolusOS), before installing, please uncomment in the asus_touchpad.service file, this following property and adjust its value:
```
# ExecStartPre=/bin/sleep 2
```

## Credits

Thank you very much [github.com/mohamed-badaoui](github.com/mohamed-badaoui) and all the contributors of [asus-touchpad-numpad-driver](https://github.com/mohamed-badaoui/asus-touchpad-numpad-driver) for your work.

## Existing similar projects

- [python service] https://github.com/danahynes/Asus_L410M_WMI_Keys
- [python service] This project as inspiration for work [python service, configurable, the most spread repository of numpad driver] https://github.com/mohamed-badaoui/asus-touchpad-numpad-driver

Why was this project created? As repository where i can implement ```Configurable support of key mapping```