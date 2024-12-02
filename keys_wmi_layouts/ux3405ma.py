from libevdev import EV_KEY

KEY_WMI_MICMUTE = 0x7C # 124
KEY_WMI_MIC = 0xCB # 203
KEY_WMI_MYASUS = 0x86 # 134

KEY_WMI_MICMUTE_LED = '/sys/class/leds/platform::micmute/brightness' # or 0x00040017
#KEY_WMI_MIC_LED = 0x0004001B TODO: how to read current state and calculate opposite? (echo "0x0004001B" > dev_id && echo "0x0000001"|"0x0000000" > ctrl_param && cat devs && cat dsts always returns DSTS(0x4001b) = 0x30000)
#If ((IIA0 == 0x0004001B))
#{
#   Local0 = Zero
#   Local0 |= Local1
#   Local2 = 0x00010000
#   Local0 |= Local2
#   Return (Local0)
#}

key_wmi_micmute = [
    KEY_WMI_MICMUTE,
    KEY_WMI_MICMUTE_LED
]

key_wmi_mic = [
    KEY_WMI_MIC,
    #KEY_WMI_MIC_LED
]

key_wmi_myasus = [
    KEY_WMI_MYASUS,
    EV_KEY.KEY_LEFTSHIFT,
    EV_KEY.KEY_LEFTMETA,
    EV_KEY.KEY_T,
]

keys_wmi = [
    key_wmi_micmute,
    key_wmi_mic,
    key_wmi_myasus,
]