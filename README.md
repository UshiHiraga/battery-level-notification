# Battery level notification  

This lightweight systemd service helps you monitor your laptop's battery level and execute a user-defined script when changes. It's particularly useful for laptops that don't provide default discharge notifications.

## Installation

### Any linux distribution

```bash
git clone https://github.com/UshiHiraga/battery-level-notification.git
cd battery-level-notification
chmod a+x install.sh
./install.sh
```

### Archlinux

The installation in ArchLinux can be done by using `yay` or by cloning the PKGBUILD and building with `makepkg`.

```bash
yay -Syu battery-level-notification
```

```bash
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/battery-level-notification.git
cd battery-level-notification
makepkg -si
```

## Usage

First, you must get the name of the battery you want to watch:

```bash
$ ls /sys/class/power_supply/
ADP0 BAT0 BAT1 BAT2
```

Then you must enable the systemd service. You can watch as many batteries you want by enabling the service again with a different battery name.

```bash
systemctl --user enable battery-level-notification@<BATTERY_NAME>.service
systemctl --user start battery-level-notification@<BATTERY_NAME>.service
```

### User defined script

By default the service will check for changes in charge level every five seconds. If there's a change then it will try to execute `$HOME/.config/battery-level-notification/<BATTERY_NAME>/script` script file. If the script doesn't exist, it will only skip.

Script will be executed as the user who enabled and will receive two arguments:

- `$1`: An integer. Current battery charge level.
- `$2`: A string. Current battery status: charging or discharging.

These are some example for script file.

```bash
#!/bin/bash
# Send a notification whenever the battery charge level changes.
notify-send "Battery level changed" "Battery is now $2 at $1%"
```

```bash
#!/bin/bash
# Suspend the laptop when te battery level is less than 5%
if test $1 -lt 5 && test $2 != "Discharging"; then
    notify-send -i dialog-warning "Battery level is too low"
    systemctl suspend
fi
```

## Configuration

You can change the behavior of the service by creating `$HOME/.config/battery-level-notification/<BATTERY_NAME>/script`. These are the avaible configurations:

```bash
SLEEP_TIME=5; # A integer. Time to wait to check battery charge level again.
EXEC_PATH=""; # A path. Path to executable script.
```
