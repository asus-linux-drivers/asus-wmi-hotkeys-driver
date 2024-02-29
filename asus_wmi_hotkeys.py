#!/usr/bin/env python3

import importlib
import logging
import os
import re
import sys
from typing import Optional
import subprocess
from libevdev import EV_KEY, EV_SYN, Device, InputEvent
from os import access, R_OK
from os.path import isfile
from time import sleep
import signal
import multiprocessing

# Setup logging
# LOG=DEBUG sudo -E ./asus_wmi_hotkeys.py  # all messages
# LOG=ERROR sudo -E ./asus_wmi_hotkeys.py  # only error messages
logging.basicConfig()
log = logging.getLogger('Asus WMI additional hotkeys')
log.setLevel(os.environ.get('LOG', 'INFO'))

# Layout of key mapping
layout = 'up5401ea'
if len(sys.argv) > 1:
    layout = sys.argv[1]

keys_wmi_layouts = importlib.import_module('keys_wmi_layouts.'+ layout)

# Default listen to these devices:
#
# - Device `Asus Keyboard` (e.g. laptop `ROG-Zephyrus-G16-GU603ZI`)
# - Device `Asus WMI hotkeys` (e.g. laptop `Zenbook-UP5401EA`)
allowed_listen_to_devices = getattr(keys_wmi_layouts, "allowed_listen_to_devices", [
    "Asus keyboard",
    "Asus WMI hotkeys"
])

log.info(f"We find these devices to listen {allowed_listen_to_devices}")

# Figure out device from devices file
device_event_ids: Optional[list[str]] = []
device_ids: Optional[list[str]] = []

device_detection_status = 0

# because for example when is udev created by another systemctl service asus_accel_tablet_mode_driver
attempts = 5

while attempts:

    device_event_ids = []
    device_ids = []
    device_detection_status = 0

    with open('/proc/bus/input/devices', 'r') as f:
        lines = f.readlines()
        for line in lines:

            # Do we want listen this device?
            if device_detection_status == 0 and list(filter(lambda x: x in line, allowed_listen_to_devices)):
                device_detection_status = 1
                log.debug('Detect device from %s', line.strip())

            if device_detection_status == 1:
                if "S: " in line:
                    # search device id
                    device_id=re.sub(r".*i2c-(\d+)/.*$", r'\1', line).replace("\n", "")
                    device_ids.append(device_id)
                    log.debug('Set device id %s from %s', device_id, line.strip())

                if "H: " in line:
                    device = line.split("event")[1].split(" ")[0]
                    device_event_ids.append(device)
                    log.debug('Set device id %s from %s', device, line.strip())
                    device_detection_status = 0

            # Stop looking if all devices have been found already
            if len(allowed_listen_to_devices) == len(device_event_ids):
                device_detection_status = 2
                break

        sleep(0.2)

        attempts-=1


if not len(device_event_ids) > 0:
    log.error("Can't find any device (code: %s)", device_detection_status)
    sys.exit(1)


# Start monitoring the devices
device_devices = []
for event_id in device_event_ids:
    fd = open('/dev/input/event' + str(event_id), 'rb')
    device = Device(fd)
    device_devices.append(device)
    log.info(f"Found device {device.name}")


def isInputEvent(event):
    if isinstance(event, InputEvent):
        return True
    return False


def isEventKey(event):
    if hasattr(event, "name") and hasattr(EV_KEY, event.name):
        return True
    return False


# Create a new device
dev = Device()
dev.name = "Asus WMI hotkeys"
for key in keys_wmi_layouts.keys_wmi:
    keys_to_enable = key[1:]
    for key_to_enable in keys_to_enable:
        if isEventKey(key_to_enable):
            dev.enable(key_to_enable)

# Sleep for a bit so udev, libinput, Xorg, Wayland, ... all have had
# a chance to see the device and initialize it. Otherwise the event
# will be sent by the kernel but nothing is ready to listen to the
# device yet
udev = dev.create_uinput_device()
sleep(1)


KEY_WMI_LED_ON = 0x00010001
#KEY_WMI_LED_OFF = 0x00010000

def execute_cmd(cmd):
    try:
        os.system(cmd)
    except OSError as e:
        log.error(e)


def handle_events(device, udev):
    while True:
        # If device (e.g. Asus WMI hotkeys) sends something
        for e in device.events():

            log.debug(e)

            # We are interested in events generally defined by:
            #
            #           - MSC_SCAN
            #           - EV_KEY.X with value 1 only!
            #           - InputEvent(EV_SW.X/EV_KEY.X/.. with specific value 0 or 1)
            #if e.matches(EV_MSC.MSC_SCAN) or (e.matches(EV_KEY) and e.value == 1) or e.matches(EV_SW):
            if True:
                if e.matches(EV_KEY) and e.value == 0:
                    continue

                # Check if is sent any specific event we are interested in
                find_custom_key_mapping = list(filter(lambda x: e.value in x or e.code in x or e in x, keys_wmi_layouts.keys_wmi))

                # Not sent
                if not len(find_custom_key_mapping):
                    continue

                # Second position is reserved for:
                #
                #         - control file with possible values (e.g. list where is first element control file '/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy' and second is array of values rotating in cycle)
                #         - control file (e.g. '/sys/class/leds/platform::micmute/brightness')
                #         - hex value of device id '/sys/kernel/debug/asus-nb-wmi/dev_id' (e.g. 0x00060079)
                if len(find_custom_key_mapping[0]) > 1 and not isEventKey(find_custom_key_mapping[0][1]) and not isInputEvent(find_custom_key_mapping[0][1]):
                    try:
                        # Is it path to e.g. brightness file or throttle_thermal_policy created by kernel module?
                        if (not isinstance(find_custom_key_mapping[0][1], list) and isfile(find_custom_key_mapping[0][1]) and access(find_custom_key_mapping[0][1], R_OK)) or\
                            (isinstance(find_custom_key_mapping[0][1], list) and isfile(find_custom_key_mapping[0][1][0]) and access(find_custom_key_mapping[0][1][0], R_OK)):

                            if isinstance(find_custom_key_mapping[0][1], list):
                                file_path = find_custom_key_mapping[0][1][0]
                            else:
                                file_path = find_custom_key_mapping[0][1]

                            cmd = ["cat", file_path]
                            log.debug(cmd)
                            prop_data = subprocess.check_output(cmd)

                            value = int(prop_data.decode().strip())

                            new_value = 0

                            if isinstance(find_custom_key_mapping[0][1], list) > 1:
                                custom_values = find_custom_key_mapping[0][1][1]
                                value_index = custom_values.index(value)
                                if value_index + 1 >= len(custom_values):
                                    new_value = 0
                                else:
                                    new_value = value + 1
                            else:
                                if value == 0:
                                    new_value = 1

                            cmd = "echo " + str(new_value) + "| sudo tee -a '" + file_path + "' >/dev/null"
                            log.debug(cmd)

                            subprocess.call(cmd, shell=True)

                        # Otherwise try use as device id (hex value translated to integer) for asus-nb-wmi module
                        elif isinstance(find_custom_key_mapping[0][1], int):

                            # Access to specific device led id
                            dev_id = hex(find_custom_key_mapping[0][1])

                            cmd = "echo " + str(dev_id) + "| sudo tee '/sys/kernel/debug/asus-nb-wmi/dev_id' >/dev/null"
                            log.debug(cmd)

                            subprocess.call(cmd, shell=True)

                            # Read device led value
                            cmd = "cat '/sys/kernel/debug/asus-nb-wmi/dsts'"
                            log.debug(cmd)
                            prop_data = subprocess.check_output(cmd, shell=True)

                            led_state = prop_data.decode().split(" ")[len(prop_data.decode().split(" ")) - 1].strip()

                            # Prepare opposite led value to device (on/off)
                            new_led_state = hex(1)

                            led_state_hex = hex(int(led_state, 16))
                            led_state_on_hex = hex(KEY_WMI_LED_ON)
                            if led_state_hex == led_state_on_hex:
                                new_led_state = hex(0)

                            cmd = "echo " + str(new_led_state) + " | sudo tee '/sys/kernel/debug/asus-nb-wmi/ctrl_param' >/dev/null"
                            log.debug(cmd)

                            subprocess.call(cmd, shell=True)

                            # Write opposite led value to device
                            cmd = "cat '/sys/kernel/debug/asus-nb-wmi/devs' >/dev/null"
                            log.debug(cmd)

                            subprocess.call(cmd, shell=True)

                    except subprocess.CalledProcessError as e:
                        log.error('Error during changing led state: \"%s\"', e.output)

                # - EV_KEY (will be sent press & unpress)
                # - InputEvent
                # - custom shell command (e.g. 'xinput disable 19')
                if find_custom_key_mapping:

                    keys_to_send_press_events = []
                    for keys_to_send_press in find_custom_key_mapping[0][1:]:

                        if isEventKey(keys_to_send_press):
                            keys_to_send_press_events.append(InputEvent(keys_to_send_press, 1))
                        elif isInputEvent(keys_to_send_press) and keys_to_send_press.value == 1:
                            keys_to_send_press_events.append(keys_to_send_press)

                    keys_to_send_release_events = []
                    for keys_to_send_release in find_custom_key_mapping[0][1:]:

                        if isEventKey(keys_to_send_release):
                            keys_to_send_release_events.append(InputEvent(keys_to_send_release, 0))
                        elif isInputEvent(keys_to_send_release) and keys_to_send_release.value == 0:
                            keys_to_send_release_events.append(keys_to_send_release)

                    cmds = []
                    for cmd in find_custom_key_mapping[0][1:]:

                        if not isfile(str(cmd)) and access(str(cmd), R_OK) and not isEventKey(str(cmd)) and not isInputEvent(str(cmd)):
                            cmds.append(cmd)

                    sync_event = [
                        InputEvent(EV_SYN.SYN_REPORT, 0)
                    ]

                    try:
                        udev.send_events(keys_to_send_press_events)
                        udev.send_events(sync_event)
                        udev.send_events(keys_to_send_release_events)
                        udev.send_events(sync_event)

                        for cmd in cmds:
                            execute_cmd(cmd)
                    except OSError as e:
                        log.error("Cannot send event, %s", e)


# Create and start processes, each device get its own process
processes = []
for device in device_devices:
    log.info(f"Started process for device {device.name}")
    process = multiprocessing.Process(target=handle_events, args=(device, udev,))
    process.start()
    processes.append(process)


# Clean before exiting
def sigint_handler(sig, frame):
    log.debug("Received SIGINT, stopping now...")
    for process in processes:
        process.kill()
        log.debug("Device %s closed.", process.name)
    log.debug("Threads dead, now exiting. Goodbye.")
    sys.exit(0)

signal.signal(signal.SIGINT, sigint_handler)

signal.pause()