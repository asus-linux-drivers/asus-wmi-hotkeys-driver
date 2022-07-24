#!/usr/bin/env python3

import importlib
import logging
import os
import re
import sys
from typing import Optional

from libevdev import EV_SYN, EV_MSC, Device, InputEvent

# Setup logging
# LOG=DEBUG sudo -E ./asus_wmi_hotkeys.py  # all messages
# LOG=ERROR sudo -E ./asus_wmi_hotkeys.py  # only error messages
logging.basicConfig()
log = logging.getLogger('Asus WMI additional hotkeys')
log.setLevel(os.environ.get('LOG', 'INFO'))

# Layout of key mapping
layout = 'up541ea'
if len(sys.argv) > 1:
    layout = sys.argv[1]

keys_wmi_layouts = importlib.import_module('keys_wmi_layouts.'+ layout)

# Figure out device from devices file
keyboard: Optional[str] = None
device_id: Optional[str] = None

tries = 5

# Look into the devices file
while tries > 0:

    keyboard_detected = 0

    with open('/proc/bus/input/devices', 'r') as f:
        lines = f.readlines()
        for line in lines:

            # Look for the keyboard
            if keyboard_detected == 0 and ("Name=\"Asus WMI hotkeys" in line):
                keyboard_detected = 1
                log.debug('Detect keyboard from %s', line.strip())

            if keyboard_detected == 1:
                if "S: " in line:
                    # search device id
                    device_id=re.sub(r".*i2c-(\d+)/.*$", r'\1', line).replace("\n", "")
                    log.debug('Set keyboard device id %s from %s', device_id, line.strip())

                if "H: " in line:
                    keyboard = line.split("event")[1]
                    keyboard = keyboard.split(" ")[0]
                    keyboard_detected = 2
                    log.debug('Set keyboard id %s from %s', keyboard, line.strip())

            # Stop looking if keyboard have been found
            if keyboard_detected == 2:
                break

    if keyboard_detected != 2:
        tries -= 1
        if tries == 0:
            if keyboard_detected != 2:
                log.error("Can't find keyboard (code: %s)", keyboard_detected)
            if keyboard_detected == 2 and not device_id.isnumeric():
                log.error("Can't find device id")
            sys.exit(1)
    else:
        break


# Start monitoring the keyboard

fd_t = open('/dev/input/event' + str(keyboard), 'rb')
d_t = Device(fd_t)


# Create a new device to send right clickss

dev = Device()
dev.name = "Asus WMI hotkeys"
for key in keys_wmi_layouts.keys_wmi:
    keys_to_enable = key[1:]
    for key_to_enable in keys_to_enable:
        dev.enable(key_to_enable)

udev = dev.create_uinput_device()

while True:

    # If Asus WMI hotkeys sends something
    for e in d_t.events():

        log.debug(e)

        find_key_mapping = list(filter(lambda x: e.value in x, keys_wmi_layouts.keys_wmi))
        if e.matches(EV_MSC.MSC_SCAN) and find_key_mapping:

            keys_to_send_press_events = []
            for keys_to_send_press in find_key_mapping[0][1:]:
                keys_to_send_press_events.append(InputEvent(keys_to_send_press, 1))

            keys_to_send_release_events = []
            for keys_to_send_release in find_key_mapping[0][1:]:
                keys_to_send_release_events.append(InputEvent(keys_to_send_release, 0))

            sync_event = [
                InputEvent(EV_SYN.SYN_REPORT, 0)
            ]

            try:
                udev.send_events(keys_to_send_press_events)
                udev.send_events(sync_event)
                udev.send_events(keys_to_send_release_events)
                udev.send_events(sync_event)
            except OSError as e:
                log.error("Cannot send event, %s", e)