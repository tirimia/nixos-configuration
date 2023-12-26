#!/usr/bin/env bash
options="Window\nSelection\nScreen"
chosen="$(echo -e "$options" | rofi -lines 3 -dmenu -i -p "Screenshot " -width 10%)"

windowscreenshot () {
    	maim -i $(xdotool getactivewindow) /tmp/$(date '+%F-T-%H-%M-%S').png
}
selectionscreenshot () {
	TMPFILE=$(mktemp -t XXXXXXX.png)
	maim -s $TMPFILE
	xclip -sel clip -t image/png < $TMPFILE
	rm $TMPFILE
}

screenscreenshot () {
	maim --quality 10 /tmp/$(date '+%F-T-%H-%M-%S').png
}

case $chosen in
	"Window")
        windowscreenshot;;
	"Selection")
	selectionscreenshot;;
	"Screen")
	screenscreenshot;;
esac
