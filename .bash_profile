#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH=$PATH:$HOME/.scripts
export XDG_CONFIG_HOME="$HOME/.config"
export PAGER="less"
export EDITOR="nvim"
export TERMINAL="urxvtc"
#export TERMINAL="st"
export BROWSER="firefox"
export MAKEFLAGS="-j$(nproc)"
# to make java GUIs run on xmonad (and dwm etc.):
export _JAVA_AWT_WM_NONREPARENTING=1

# to stop ranger from loading the default config files
export RANGER_LOAD_DEFAULT_RC="FALSE"

if [[ "$(tty)" = "/dev/tty1" ]]; then
    # not using `pgrep i3` because we might use other wm's
    pgrep Xorg || exec startx
fi
