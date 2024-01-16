from libevdev import EV_KEY, EV_SW, InputEvent

KEY_WMI_TOUCHPAD = 0x6B # 107
KEY_WMI_MICMUTE = 0x7C # 124
KEY_WMI_CAMERA = 0x85 # 133
KEY_WMI_MYASUS = 0x86 # 134

KEY_WMI_NUMLOCK_DISABLE_KEYBOARD = EV_KEY.KEY_NUMLOCK

KEY_WMI_MICMUTE_LED = '/sys/class/leds/platform::micmute/brightness' # or 0x00040017
KEY_WMI_CAMERA_LED = 0x00060079

key_wmi_tablet_mode_disable_keyboard = [
    InputEvent(EV_SW.SW_TABLET_MODE, 1),
    'xinput disable 19'
]

key_wmi_tablet_mode_enable_keyboard = [
    InputEvent(EV_SW.SW_TABLET_MODE, 0),
    'xinput enable 19'
]

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

allowed_listen_to_devices = [
    "Asus keyboard",              # listening by default
    "Asus WMI hotkeys",           # listening by default
    "Lid Switch",                 # NOT listening by default!!
    "Asus WMI accel tablet mode", # NOT listening by default!!
]

keys_wmi = [
    key_wmi_touchpad,
    key_wmi_micmute,
    key_wmi_camera,
    key_wmi_myasus,
    key_wmi_tablet_mode_disable_keyboard,
    key_wmi_tablet_mode_enable_keyboard
]