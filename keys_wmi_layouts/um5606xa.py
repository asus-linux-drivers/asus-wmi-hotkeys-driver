from libevdev import EV_KEY

KEY_WMI_MICMUTE = 0x7C # 124
KEY_WMI_CAMERA = 0x85 # 133

KEY_WMI_MICMUTE_LED = '/sys/class/leds/platform::micmute/brightness' # or 0x00040017
KEY_WMI_CAMERA_LED = 0x00060078

key_wmi_micmute = [
    KEY_WMI_MICMUTE,
    KEY_WMI_MICMUTE_LED
]

key_wmi_camera = [
    KEY_WMI_CAMERA,
    KEY_WMI_CAMERA_LED
]


keys_wmi = [
    key_wmi_camera,
    key_wmi_micmute
]
