# maybe this helps when my laptop freezes again...
setxkbmap -option terminate:ctrl_alt_bksp

#setxkbmap -layout us,de -option grp:shift_caps_toggle
#setxkbmap -layout us,de -option grp:shifts_toggle
setxkbmap -layout us,de -option grp:ctrls_toggle
setxkbmap -option grp:lswitch
setxkbmap -option grp_led:caps
setxkbmap -option caps:escape
# this one somehow disables 'ctrl + alt + f2'
#xmodmap -e "remove mod1 = Alt_R" -e "add mod4 = Alt_R"

# make tab and backslash extra mod keys when held down
xmodmap -e "keycode 23 = Hyper_L"
xmodmap -e "keycode any = Tab"
xmodmap -e "keysym backslash = Hyper_R bar"
xmodmap -e "keycode any = backslash"
xcape -e "Hyper_L=Tab" -t 400
xcape -e "Hyper_R=backslash" -t 130

xset r rate 220 60

xrdb ~/.Xresources
urxvtd -q -o -f
dunst &
nm-applet &
mpd

#unclutter -noevents -idle 3 &
unclutter -idle 3 -noevents -root -notclass firefox Minecraft &

# Use a fifo (named pipe) to write volume changes for xmobar
# mode rw-rw-rw so that acpi events can also change it.
#rm /home/jonas/.vol; mkfifo -m 666 /home/jonas/.vol; #echo "--" > /home/jonas/.vol &
rm /tmp/vol; mkfifo -m 777 /tmp/vol; #echo "--" > /home/jonas/.vol &

# Torrent Program
pgrep -xf transmission-daemon || transmission-daemon --paused

# Activate second monitor if connected
xrandr -q | grep "HDMI1 connected" && xrandr \
	--output HDMI1 --primary --mode 2560x1440 --pos 0x0 \
	--output VIRTUAL1 --off --output eDP1 --off
	#--output VIRTUAL1 --off --output eDP1 --mode 1920x1080 --pos 304x1440 --rotate normal


# -- Window Managers -- #
wm=dwm
# needs tryones compton fork!
comptoncmd="compton -b --xrender-sync-fence --blur-background --blur-method kawase --blur-strength 10 --blur-background-exclude !(class_g='URxvt')"

case $wm in
	i3) exec i3;;
	xmonad)
		~/.fehbg;
		xsetroot -cursor_name left_ptr;
		#compton -b --xrender-sync-fence;
		$comptoncmd;
		exec xmonad;;
	awesome)
		~/.fehbg;
		# needs tryones compton fork, breaks with multihead setup
		#compton -b --xrender-sync-fence --blur-background --blur-method kawase --blur-strength 10;
		compton -b --xrender-sync-fence;
		exec awesome;;
	dwm)
		~/.fehbg;
		dwm_status.sh &
		# needs tryones compton fork, breaks with multihead setup
		#compton -b --xrender-sync-fence --blur-background --blur-method kawase --blur-strength 10;
		$comptoncmd;
		exec startdwm;; # starts dwm in a loop
	#*) echo "error, no wm selected!"
esac
