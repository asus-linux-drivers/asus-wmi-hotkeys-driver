from libevdev import EV_KEY

KEY_WMI_TOUCHPAD = 0x6B # 107
KEY_WMI_MICMUTE = 0x7C # 124
KEY_WMI_CAMERA = 0x85 # 133
KEY_WMI_MYASUS = 0x86 # 134

KEY_WMI_MICMUTE_LED = 0x00040017 # TODO: allow too '/sys/class/leds/platform::micmute/brightness' when kernel module is already created but is not associated led together with key?
KEY_WMI_CAMERA_LED = 0x00060079

key_wmi_touchpad = [
    KEY_WMI_TOUCHPAD,
    EV_KEY.KEY_TOUCHPAD_TOGGLE
]

key_wmi_micmute = [
    KEY_WMI_MICMUTE,
    KEY_WMI_MICMUTE_LED
]

key_wmi_camera = [
    KEY_WMI_CAMERA,
    KEY_WMI_CAMERA_LED
]

key_wmi_myasus = [
    KEY_WMI_MYASUS,
    EV_KEY.KEY_LEFTSHIFT,
    EV_KEY.KEY_LEFTMETA,
    EV_KEY.KEY_T,
]

keys_wmi = [
    key_wmi_touchpad,
    key_wmi_micmute,
    key_wmi_camera,
    key_wmi_myasus,
]