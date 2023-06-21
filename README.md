# Asus WMI hotkeys driver

The driver has been created for situation when special keys on laptop do not work. The driver works as middle-man, is listening for events and when is appropriate key event caught then is send custom event configured in config file. 

[![License: GPLv2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![GitHub commits](https://img.shields.io/github/commits-since/asus-linux-drivers/asus-wmi-hotkeys-driver/v1.0.1.svg)](https://GitHub.com/asus-linux-drivers/asus-wmi-hotkeys-driver/commit/)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fasus-linux-drivers%2Fasus-wmi-hotkeys-driver&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

If you find the project useful, do not forget to give project a [![GitHub stars](https://img.shields.io/github/stars/asus-linux-drivers/asus-wmi-hotkeys-driver.svg?style=flat-square)](https://github.com/asus-linux-drivers/asus-wmi-hotkeys-driver/stargazers) People already did!

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

## Configuration

Back-up of configuration is up to you as repository contains only examples for easy getting started. Config is located here:

```
$ cat "/usr/share/asus_wmi_hotkeys-driver/keys_wmi_layouts/layout.py"
```

Discovered keys up to this moment which might be equal across models:

*Model: UP5401EA*
```
KEY_WMI_TOUCHPAD = 0x6B # 107
KEY_WMI_MICMUTE = 0x7C # 124
KEY_WMI_CAMERA = 0x85 # 133
KEY_WMI_MYASUS = 0x86 # 134
```

*Model: UX8402*
```
KEY_WMI_SCREENPAD = 0x6A #106
KEY_WMI_SWITCHWINDOWS = 0x9C #156
```

*Model: UX582X*
```
KEY_WMI_FAN = 0x9D  # 157
```

## Troubleshooting

To activate logger, do in a console:
```
$ LOG=DEBUG sudo -E ./asus_wmi_hotkeys.py
```

## Existing similar projects

Do not know any.
