# Asus WMI hotkeys driver
 
The driver has been created for the situation when special keys (even associated LEDS) on laptop do not work (are not supported by kernel modules yet). The driver works as middle-man, is listening for events and when is appropriate key event caught then is optionally toggled LED status and also optionally send another custom key event configured in config file.

[![License: GPLv2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![GitHub commits](https://img.shields.io/github/commits-since/asus-linux-drivers/asus-wmi-hotkeys-driver/v1.0.1.svg)](https://GitHub.com/asus-linux-drivers/asus-wmi-hotkeys-driver/commit/)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fasus-linux-drivers%2Fasus-wmi-hotkeys-driver&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
 
If you find the project useful, do not forget to give project a [![GitHub stars](https://img.shields.io/github/stars/asus-linux-drivers/asus-wmi-hotkeys-driver.svg?style=flat-square)](https://github.com/asus-linux-drivers/asus-wmi-hotkeys-driver/stargazers) People already did!

## Features

- Allowed to fix any special Fn+ key including associated LED
 
## Installation
 
You can get the latest ASUS WMI hotkeys driver for Linux from Git and install it using the following commands.
```
$ git clone https://github.com/asus-linux-drivers/asus-wmi-hotkeys-driver.git
$ cd asus-wmi-hotkeys
$ sudo bash ./install.sh
```
 
To uninstall, just run:
```
$ sudo bash ./uninstall.sh
```
 
## Setup
 
How to discover the key value and bind to something else using this driver.
 
- Find the event ID of `Asus WMI hotkeys` for example like this:
```
$ libinput debug-events`
...
-event4 DEVICE_ADDED Asus WMI hotkeys seat0 default group9 cap:ksudo evemu-record /dev/input/event4
...
```
- Listen for found event number and press the key you want bind to something else for example using `$ sudo evtest /dev/input/event4` (which returns already hex values) or `$ sudo evemu-record /dev/input/event4` (where values has to be converted from decimal to hex):
```
$ sudo evtest
...
/dev/input/event4:	Asus WMI hotkeys
...
Select the device event number [0-24]: 4

Event: time 1695811053.452927, type 4 (EV_MSC), code 4 (MSC_SCAN), value 7c
Event: time 1695811053.452927, type 1 (EV_KEY), code 248 (KEY_MICMUTE), value 1
Event: time 1695811053.452927, -------------- SYN_REPORT ------------
Event: time 1695811053.452938, type 1 (EV_KEY), code 248 (KEY_MICMUTE), value 0
Event: time 1695811053.452938, -------------- SYN_REPORT ------------
Event: time 1695811057.648891, type 4 (EV_MSC), code 4 (MSC_SCAN), value 85
Event: time 1695811057.648891, type 1 (EV_KEY), code 212 (KEY_CAMERA), value 1
Event: time 1695811057.648891, -------------- SYN_REPORT ------------
Event: time 1695811057.648901, type 1 (EV_KEY), code 212 (KEY_CAMERA), value 0
Event: time 1695811057.648901, -------------- SYN_REPORT ------------
Event: time 1695811059.000888, type 4 (EV_MSC), code 4 (MSC_SCAN), value 6b
Event: time 1695811059.000888, type 1 (EV_KEY), code 191 (KEY_F21), value 1
Event: time 1695811059.000888, -------------- SYN_REPORT ------------
Event: time 1695811059.000898, type 1 (EV_KEY), code 191 (KEY_F21), value 0
Event: time 1695811059.000898, -------------- SYN_REPORT ------------

$ sudo evemu-record /dev/input/event4
...
E: 0.000001 0004 0004 0107	# EV_MSC / MSC_SCAN             107
E: 0.000001 0001 00bf 0001	# EV_KEY / KEY_F21              1
E: 0.000001 0000 0000 0000	# ------------ SYN_REPORT (0) ---------- +0ms
E: 0.000024 0001 00bf 0000	# EV_KEY / KEY_F21              0
E: 0.000024 0000 0000 0000	# ------------ SYN_REPORT (0) ---------- +0ms
E: 2.476044 0004 0004 0124	# EV_MSC / MSC_SCAN             124
E: 2.476044 0001 00f8 0001	# EV_KEY / KEY_MICMUTE          1
E: 2.476044 0000 0000 0000	# ------------ SYN_REPORT (0) ---------- +2476ms
E: 2.476066 0001 00f8 0000	# EV_KEY / KEY_MICMUTE          0
E: 2.476066 0000 0000 0000	# ------------ SYN_REPORT (0) ---------- +0ms
E: 2.792149 0004 0004 0133	# EV_MSC / MSC_SCAN             133
E: 2.792149 0001 00d4 0001	# EV_KEY / KEY_CAMERA           1
E: 2.792149 0000 0000 0000	# ------------ SYN_REPORT (0) ---------- +316ms
E: 2.792178 0001 00d4 0000	# EV_KEY / KEY_CAMERA           0
E: 2.792178 0000 0000 0000	# ------------ SYN_REPORT (0) ---------- +0ms
SE: 5.003936 0004 0004 0134	# EV_MSC / MSC_SCAN             134
E: 5.003936 0001 0094 0001	# EV_KEY / KEY_PROG1            1
E: 5.003936 0000 0000 0000	# ------------ SYN_REPORT (0) ---------- +2211ms
E: 5.003972 0001 0094 0000	# EV_KEY / KEY_PROG1            0
E: 5.003972 0000 0000 0000	# ------------ SYN_REPORT (0) ---------- +0ms
```
- Discovered `EV_MSC / MSC_SCAN` value use in hexa format in config aswell as appropriate key to which you want bind that key, for example:

```
from libevdev import EV_KEY

KEY_WMI_TOUCHPAD = 0x6B # 107

key_wmi_touchpad = [
    KEY_WMI_TOUCHPAD,
    EV_KEY.KEY_TOUCHPAD_TOGGLE
]

keys_wmi = [
    key_wmi_touchpad
]
```

How to discover new LED value? Run file `sudo bash tests/test_devid.sh` (but **FIRST!** change range of tested range of ids in script row number `5` for example to `60000..60100`, do not worry, value is tried to set up to 1 hex on 1s (pause between testing each device id) and then is reverted back previously exist value so script changes anything) and during running check by eyes whether is LED activated.

- Discovered keys and associated leds up to this moment that might be equal across models:
 
*Model: UP5401EA*
```
KEY_WMI_TOUCHPAD = 0x6B # 107
KEY_WMI_MICMUTE = 0x7C # 124
KEY_WMI_CAMERA = 0x85 # 133
KEY_WMI_MYASUS = 0x86 # 134

KEY_WMI_MICMUTE_LED = 0x00040017
KEY_WMI_CAMERA_LED = 0x00060079
```
 
*Model: UX8402*
```
KEY_WMI_SCREENPAD = 0x6A #106
KEY_WMI_SWITCHWINDOWS = 0x9C #156
```
 
*Model: UX582X*
```
KEY_WMI_FAN = 0x9D # 157
```

## Configuration
 
For example:

```
# fix only key
key_wmi_camera = [
    KEY_WMI_CAMERA,
    EV_KEY.SOME_KEY
]
# fix only led
key_wmi_camera = [
    KEY_WMI_CAMERA,
    KEY_WMI_CAMERA_LED
]
# fix key and fix led too
key_wmi_camera = [
    KEY_WMI_CAMERA,
    KEY_WMI_CAMERA_LED
    EV_KEY.SOME_KEY
]
```

Back-up of configuration is up to you as repository contains only examples for easy getting started. Config is located here:
 
```
$ cat "/usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts/layout.py"
```
 
## Troubleshooting
 
To activate logger, do in a console:
```
$ LOG=DEBUG sudo -E ./asus_wmi_hotkeys.py
```
 
## Existing similar projects
 
Do not know any.
