from libevdev import EV_KEY

KEY_WMI_CAMERA = 0x85
KEY_WMI_MYASUS = 0x86

key_wmi_camera = [
    KEY_WMI_CAMERA,
    EV_KEY.KEY_LEFTSHIFT,
    EV_KEY.KEY_LEFTMETA,
    EV_KEY.KEY_R
]

key_wmi_myasus = [
    KEY_WMI_MYASUS,
    EV_KEY.KEY_LEFTSHIFT,
    EV_KEY.KEY_LEFTMETA,
    EV_KEY.KEY_T,
]

keys_wmi = [
    key_wmi_camera,
    key_wmi_myasus
]