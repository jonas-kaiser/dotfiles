#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# search official repositories for packages if command wasn't found
source /usr/share/doc/pkgfile/command-not-found.bash

# Allows you to cd into directory merely by typing the directory name.
shopt -s autocd


GREEN="\[$(tput setaf 2)\]"
RESET="\[$(tput sgr0)\]"

# use git prompt
source /usr/share/git/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

#PS1="[${GREEN}\u${RESET}@\h \W]\$ "
#PS1='[\u@\h \W]\$ '

export GPG_TTY=$(tty)

alias vim="nvim"

# Some aliases
alias sm="msmtp-runqueue.sh"
alias lm="msmtp-listqueue.sh"

alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -a --color=auto'
#alias gm='offlineimap'
alias t='$TERMINAL'
alias r='ranger'
alias m='neomutt'
alias n='newsboat'
#alias v='vim'
#alias v='vifm .'
alias v='nvim'
alias refl='sudo reflector --latest 30 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
#alias gitlog='git log --graph --pretty=oneline'
alias gitlog='git log --graph --pretty=format:"%C(yellow)%h %C(cyan)%ad%C(auto)%d %s" --date=human'
alias gitlogb='git log --graph --pretty=format:"%C(yellow)%h %C(cyan)%ad%C(auto)%d %s" --date=human --branches'

# use this to work on dotfile repo
alias config='git --git-dir=$HOME/.cfg --work-tree=$HOME'

# pipe file to pastebin site
alias ixio="curl -F 'f:1=<-' ix.io"

alias ':q'='exit'

source ~/.shortcuts

## using both vi mode and inputrc:vi mode to mak fzf work and inputrc because it wider config
set -o vi
#bind '"\C-l": "clear\C-d"'

# fuzzy find (needs to be sourced after vi mode!)
#source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# Prevent nested ranger instances
ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        /usr/bin/ranger "$@"
    else
        exit
    fi
}

shdl() { curl -O $(curl -s http://sci-hub.mu/"$@" | grep location.href | grep -o http.*pdf) ;}

se() {
	if [[ $# == 0 ]]; then
		FILE=$(find $HOME/.scripts/* $HOME/.config/* | fzf)
	else
		FILE=$(find $@ | fzf)
	fi

	if [ -z $FILE ]; then return; fi

	#echo $FILE
	$EDITOR "$FILE"
}
