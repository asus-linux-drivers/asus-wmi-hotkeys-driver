# Changelog

## 1.3.2 (15.9.2024)

### Fixed

- Added template for `um5606xa` (camera led address is `0x00060078` and until today was mentioned in templates only adress +1 `0x00060079`, credits @felix-clabs)

## 1.3.1 (29.2.2024)

### Fixed

- The driver run under root again

## 1.3.0 (16.1.2024)

### Feature

- The driver run under current user only
- Allowed to fix any stateful binary switches (e.g. `switch lid state`, `switch tablet-mode state`)
- Allowed to define `InputEvent` as event to which the driver reacts or as the driver reacts (e.g. used for `switch lid state` or `switch tablet-mode state`)
- Allowed to send custom commands (e.g. `xinput enable 19`)
- Zypper package manager support
- Allowed listen to events not only from devices `Asus keyboard` or `Asus WMI hotkeys`

## 1.2.2 (10.1.2024)

### Fixed

- Fixed driver auto-start using systemd service

## 1.2.1 (6.1.2024)

### Fixed

- Added possibility to control files with multiple custom values (e.g. fan modes key) (Replaced len with isinstance(.., list) as len have even string)

## 1.2.0 (30.12.2023)

### Feature

- Added possibility to control files with multiple custom values (e.g. fan modes key)

## 1.1.3 (25.12.2023)

### Fixed

- Usage #!/usr/bin/env instead of hardcoded path bash/sh

## 1.1.2 (22.12.2023)

### Feature

- Added support for laptops with device Asus keyboard

### Fixed

- When was used key not overbound

## 1.1.1 (10.12.2023)

### Fixed

- Allowed to configure associated leds via brightness files added by kernel modules

## 1.1.0 (10.12.2023)

### Feature

- Configure associating leds to keys
