#!/bin/sh

# Load X resources if present
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# Start any needed background processes
xss-lock --transfer-sleep-lock -- i3lock --nofork &
nm-applet &  # Network Manager applet
pactl set-sink-mute @DEFAULT_SINK@ toggle &  # PulseAudio controls
pactl set-source-mute @DEFAULT_SOURCE@ toggle &  # Mic mute toggle

# Start compositor for transparency and effects
picom &

# Launch i3 window manager
exec i3
