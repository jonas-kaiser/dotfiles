#!/bin/bash

# Creates shortcuts for bash and ranger

# Shell rc file (i.e. bash vs. zsh, etc.)
shellrc="$HOME/.bashrc"

# Config locations, make sure these are present!
folders="$HOME/.scripts/shortcuts/folders"
configs="$HOME/.scripts/shortcuts/configs"
others="$HOME/.scripts/shortcuts/others"

# Output locations
shell_shortcuts="$HOME/.shortcuts"
ranger_shortcuts="$HOME/.config/ranger/shortcuts.conf"
lf_shortcuts="$HOME/.config/lf/shortcuts.conf"

# Remove old files
rm -f "$shell_shortcuts" "$ranger_shortcuts" "$lf_shortcuts"

# Ensure that output locations are properly sourced
(grep "source ~/.shortcuts" "$shellrc")>/dev/null || echo "source ~/.shortcuts" >> "$shellrc"
(grep "source ~/.config/ranger/shortcuts.conf" "$HOME/.config/ranger/rc.conf")>/dev/null || echo "source ~/.config/ranger/shortcuts.conf" >> "$HOME/.config/ranger/rc.conf"
(grep "source ~/.config/lf/shortcuts.conf" "$HOME/.config/lf/lfrc")>/dev/null || echo "source ~/.config/lf/shortcuts.conf" >> "$HOME/.config/lf/lfrc"

# Format the 'folders' file in the correct syntax and sent it to both configs.
sed -e "/^#/d" -e "/^\s*$/d" "$folders" | tee \
	>(awk '{printf "alias g"$1"=\"cd"; $1=""; print $0"\""}' >> "$shell_shortcuts") \
	>(awk '{printf "map g"$1" cd"; $1=""; gsub("\\\\ "," ",$0); print $0}' >> "$ranger_shortcuts") \
	>(awk '{printf "map g"$1" cd"; $1=""; gsub("\\\\ "," ",$0); print $0}' >> "$lf_shortcuts") \
	> /dev/null
	# this one doesn't print strings with spaces
	#>(awk '{print "alias g"$1"=\"cd "$2"\""}' >> "$shell_shortcuts") \
	# the ranger one doesn't need escaped whitespace, so remove the backslash

# Format the 'configs' file in the correct syntax and sent it to both configs
sed -e "/^#/d" -e "/^\s*$/d" "$configs" | tee \
	>(awk '{print "alias "$1"=\"$EDITOR "$2"\""}' >> "$shell_shortcuts") \
	>(awk '{print "map "$1" shell $EDITOR "$2}' >> "$ranger_shortcuts") \
	> /dev/null

# Format the 'others' file in the correct syntax and sent it to both configs
sed -e "/^#/d" -e "/^\s*$/d" "$others" | tee \
	>(awk '{printf "alias "$1"=\""; for (i=2; i<NF; i++) printf $i " "; printf $NF "\"\n"}' >> "$shell_shortcuts") \
	>(awk '{printf "map "$1" shell "; for (i=2; i<NF; i++) printf $i " "; printf $NF "\"\n"}' >> "$ranger_shortcuts") \
	> /dev/null
