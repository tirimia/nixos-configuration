#!/usr/bin/env bash
LANGS='us-de-ro std'
LANG=$(echo "$LANGS" | tr '-' '\n' | rofi -dmenu -i -lines 3 -auto-select -p "lang" -width 10%)
if [ -z "$LANG" ] ; then
  notify-send "No language selected"
else
  setxkbmap "$LANG"
  notify-send "$LANG keymap set"
fi
