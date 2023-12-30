from libevdev import EV_KEY

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

keys_wmi = [
    key_wmi_fan
]