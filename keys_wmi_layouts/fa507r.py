from libevdev import EV_KEY

KEY_WMI_ARMOURY = 0x38
KEY_WMI_AURA = 0xB3

key_wmi_armoury = [
    KEY_WMI_ARMOURY,
    EV_KEY.KEY_LEFTSHIFT,
    EV_KEY.KEY_LEFTMETA,
    EV_KEY.KEY_A
]

key_wmi_aura = [
    KEY_WMI_AURA,
    EV_KEY.KEY_LEFTSHIFT,
    EV_KEY.KEY_LEFTMETA,
    EV_KEY.KEY_B
]

keys_wmi = [
    key_wmi_armoury,
    key_wmi_aura
]
