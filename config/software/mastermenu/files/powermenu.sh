#!/usr/bin/env bash
options="lock\nlogout\nrestart\nshutdown"
chosen="$(echo -e "$options" | rofi -lines 4 -dmenu -i -p "Power " -width 10%)"

case $chosen in
    "lock")
        betterlockscreen -l;;
    "logout")
        pkill -KILL -u $USER;;
    "restart")
        systemctl reboot;;
    "shutdown")
        systemctl poweroff;;
esac
