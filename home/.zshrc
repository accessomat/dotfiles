#!/bin/zsh
trace=false
if $trace; then
	start=$(gdate "+%s%N")
	# set the trace prompt to include seconds, nanoseconds, script name and line number
	# PS4='$(($(date "+%s%N")-$start))	%N:%i	'
	PS4='$(($(gdate "+%s%N")-$start)) %N:%i> '
	# save file stderr to file descriptor 3 and redirect stderr (including trace 
	# output) to a file with the script's PID as an extension
	exec 3>&2 2>/tmp/startlog.$$
	# set options to turn on tracing and expansion of commands contained in the prompt
	setopt xtrace prompt_subst
fi


# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
if [[ -s "${ZDOTDIR:-$HOME}/.aliases" ]]; then
  source "${ZDOTDIR:-$HOME}/.aliases"
fi

# homeshick stuff
if [ -f $HOME/.homesick/repos/homeshick/homeshick.sh ]; then
    source $HOME/.homesick/repos/homeshick/homeshick.sh
    # Check if castles need refreshing
    homeshick --quiet refresh 14 $HOMESHICK_REFRESH_REPOS
    fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
fi

# dotfiles stuff
if [[ -d $HOME/.homesick/repos/dotfiles/ ]]; then
    fpath=($HOME/.homesick/repos/dotfiles/completions $fpath)
fi

unsetopt    SHARE_HISTORY


if $trace; then
	# turn off tracing
	unsetopt xtrace
	# restore stderr to the value saved in FD 3
	exec 2>&3 3>&-
fi

export JAVA_HOME="$(/usr/libexec/java_home)"

 GATEWAY_SERVER="gateway.univide.com"
 INTERNAL_DOMAIN="cwl"
 function cwl () {
     target="$1"
     if [ "${target}" != "" ]; then
         shift
         echo "Connecting to ${target}"
         if ! echo ${target} | grep '\.' &> /dev/null; then
             target="${target}.${INTERNAL_DOMAIN}"
         fi
         ssh -q -C -t ${GATEWAY_SERVER} ssh -q ${target} ${@}
     else
         echo "Connecting to gateway"
         ssh -q -C ${GATEWAY_SERVER}
     fi
 }

