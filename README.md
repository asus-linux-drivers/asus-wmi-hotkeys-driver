# Asus WMI hotkeys driver

The driver works as middle-man and can be especially handy when events are not supported by kernel module / distro code, is listening for events of added devices by default (e.g. `Asus keyboard` and `Asus WMI hotkeys`) or added devices in configuration (e.g. `Lid Switch` and `Asus WMI accel tablet mode)`) and when is appropriate event caught then is handled by custom configuration. For example can be toggled LED status or changed control file (e.g. fan mode), send another key event or executed custom command (e.g. reaction to `switch lid state`). More [here](#Configuration).

[![License: GPLv2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![GitHub commits](https://img.shields.io/github/commits-since/asus-linux-drivers/asus-wmi-hotkeys-driver/v1.2.2.svg)](https://GitHub.com/asus-linux-drivers/asus-wmi-hotkeys-driver/commit/)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fasus-linux-drivers%2Fasus-wmi-hotkeys-driver&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
 
If you find the project useful, do not forget to give project a [![GitHub stars](https://img.shields.io/github/stars/asus-linux-drivers/asus-wmi-hotkeys-driver.svg?style=flat-square)](https://github.com/asus-linux-drivers/asus-wmi-hotkeys-driver/stargazers) People already did!

## Changelog

[CHANGELOG.md](CHANGELOG.md)

## Features

- Driver installed for the current user (does not run under `$ sudo`)
- Allowed to send custom commands (e.g. `xinput enable 19`)
- Allowed to fix any stateful binary switches (e.g. `switch lid state`, `switch tablet-mode state`)
- Allowed to fix any special Fn+ key including associated LED (directly via `debugfs` or kernel modules brightness files) or control files with multiple possible `int` values (e.g. kernel modules files `throttle_thermal_policy` - `[0,1,2]`)

## Requirements

- (Optionally for LEDs without kernel modules yet) have mounted `debugfs` to `/sys/kernel/debug/asus-nb-wmi` from kernel modules `asus-wmi, asus-nb-wmi`

## Installation

Get latest dev version using `git`

```bash
$ git clone https://github.com/asus-linux-drivers/asus-wmi-hotkeys-driver
$ cd asus-wmi-hotkeys-driver
```

and install

```bash
$ bash install.sh
```

or run separately parts of the install script

- run notifier every time when the user log in (do NOT run as `$ sudo`, works via `systemctl --user`)

```bash
$ bash install_service.sh
```

## Uninstallation

To uninstall run

```bash
$ bash uninstall.sh
```

or run separately parts of the uninstall script

```bash
$ bash uninstall_service.sh
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
$ sudo apt install evtest
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

How to discover new LED value? Run file `sudo bash tests/test_devid.sh` (but **FIRST!** change range of tested range of ids in script row number `5` for example to `60000..60100`, do not worry, value is tried to set up to 1 hex on 1s (pause between testing each device id) and then is reverted back previously exist value so script changes nothing) and during running check by eyes whether is LED activated.

- Discovered keys and associated leds up to this moment that might be equal across models:
 
*Model: UP5401EA*
```
KEY_WMI_TOUCHPAD = 0x6B # 107
KEY_WMI_MICMUTE = 0x7C # 124
KEY_WMI_CAMERA = 0x85 # 133
KEY_WMI_MYASUS = 0x86 # 134

KEY_WMI_MICMUTE_LED = '/sys/class/leds/platform::micmute/brightness' # or 0x00040017
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

*Model: GU603ZI*
```
KEY_WMI_FAN = -13565778 # ff3100ae

KEY_WMI_FAN_THROTTLE_THERNAL_POLICY = '/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy'
KEY_WMI_FAN_THROTTLE_THERNAL_POLICY_VALUES = [
    0,
    1,
    2
]
```

*Model: unknown*
```
KEY_WMI_CAMERA_LED = 0x00060078 # https://github.com/Plippo/asus-wmi-screenpad/blob/keyboard_camera_led/inc/asus-wmi.h
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
# fix only controlling file with multiple values (e.g. fan key with allowed modes 0,1,2)
KEY_WMI_FAN_THROTTLE_THERNAL_POLICY = '/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy'
KEY_WMI_FAN_THROTTLE_THERNAL_POLICY_VALUES = [
    0,
    1,
    2
]
key_wmi_fan = [
    EV_KEY.KEY_PROG4,
    [
        KEY_WMI_FAN_THROTTLE_THERNAL_POLICY,
        KEY_WMI_FAN_THROTTLE_THERNAL_POLICY_VALUES

    ]
]
# fix by custom command (disable keyboard, touchpad, ..)
key_wmi_tablet_mode_disable_keyboard = [
    InputEvent(EV_SW.SW_TABLET_MODE, 1),
    'xinput disable 19'
]

key_wmi_tablet_mode_enable_keyboard = [
    InputEvent(EV_SW.SW_TABLET_MODE, 0),
    'xinput enable 19'
]
# fix event for specific device 
allowed_listen_to_devices = [
    "Asus keyboard",              # listening by default
    "Asus WMI hotkeys",           # listening by default
    "Lid Switch",                 # NOT listening by default
    "Asus WMI accel tablet mode", # NOT listening by default
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

- [python service, not configurable, mic-mute LED via kernel module brightness file] https://github.com/Arkapravo-Ghosh/asus-micmute-key-led-driver
- [how to write kernel patch for adding not supported key led by kernel yet] https://github.com/asus-linux-drivers/asus-how-to-kernel-driver
