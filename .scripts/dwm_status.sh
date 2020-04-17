#!/bin/bash

# color schemes as defined in config.h
x1=""
x2=""
x3=""
x4=""
x5=""

while true; do
	time=$(date +'%a %d. %b, %H:%M')
	batt=$(acpi -b | awk '{print $4 $3 $5}' \
		| sed "s/%./% /;s/Discharging,//;s/Charging,/Charging /;s/..:../(&)/;s/):../)/")
	temp=$(acpi -t | grep 'Thermal 1' | awk '{print $4 " °C"}')
	vol=$( if $(pamixer --get-mute); then echo "Mute ($(pamixer --get-volume))";
	       else echo "$(pamixer --get-volume)"; fi; )

	xsetroot -name "$x1 🔊 $vol% | $temp | $batt | $time"

	sleep 1
done
