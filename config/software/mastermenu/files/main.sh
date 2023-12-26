#!/usr/bin/env bash
options="Monitors\nKeyboard\nScreenshot\nPower"
chosen="$(echo -e "$options" | rofi -lines 5 -dmenu -i -p "Task " -width 20)"

case $chosen in
    "Monitors")
	autorandr -c;;
    "Keyboard")
        ~/.config/mastermenu/keyboard.sh;;
    "Screenshot")
        ~/.config/mastermenu/screenshot.sh;;
    "Power")
        ~/.config/mastermenu/powermenu.sh;;
esac
