from libevdev import EV_KEY

KEY_WMI_MICMUTE = 0x7C # 124
KEY_WMI_CAMERA = 0x85 # 133
KEY_WMI_MYASUS = 0x86 # 134
KEY_WMI_TOUCHPAD = 0x6B # 107

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

key_wmi_micmute = [
    KEY_WMI_MICMUTE,
    EV_KEY.KEY_LEFTSHIFT,
    EV_KEY.KEY_LEFTMETA,
    EV_KEY.KEY_Q,
]

key_wmi_touchpad = [
    KEY_WMI_TOUCHPAD,
    EV_KEY.KEY_LEFTSHIFT,
    EV_KEY.KEY_LEFTMETA,
    EV_KEY.KEY_N,
]

keys_wmi = [
    key_wmi_camera,
    key_wmi_myasus,
    key_wmi_micmute,
    key_wmi_touchpad
]