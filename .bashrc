# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -al'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Set default Docker runtime to use in '~/HSR/docker/docker-compose.yml':
# 'runc' (Docker default) or 'nvidia' (Nvidia Docker 2).
export DOCKER_RUNTIME=nvidia
export PATH=$PATH:/usr/local/texlive/2020/bin/x86_64-linux:${HOME}/.local/bin

# ROS
#source /opt/ros/noetic/setup.bash
source /opt/ros/*/setup.bash

alias rsetup='export ROS_IP=133.15.23.154 && source /opt/ros/${ROS_DISTRO}/setup.bash && \
  source ~/catkin_ws/devel/setup.bash'

#
# Set $ROS_MASTER_URI and $ROS_IP of the host to match with the ROS master running in a docker container
#
function docker_ros_setup() {
  if [ "$1" != "" ]; then
    CONTAINER_NAME=$1
  else
    CONTAINER_NAME="master"
  fi

  IP_ADDRESS=`docker inspect $CONTAINER_NAME | grep -E "IPAddress" | grep -o -m1 "[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+"`

  if [ "$IP_ADDRESS" != "" ]; then
    export ROS_MASTER_URI=http://$IP_ADDRESS:11311
    export ROS_IP=${IP_ADDRESS%.*}.1

    echo "Docker ROS setup : $IP_ADDRESS"
    echo "ROS IP           : $ROS_IP"
  else
    echo CONTAINER \"$CONTAINER_NAME\" not found
  fi
}

# Tab completion for 'docker_ros_setup'
function _docker_ros_setup_comp() {
    local cur prev cword
    _get_comp_words_by_ref -n : cur prev cword
    opts=`docker ps --format "{{.Names}}" | grep -E "master"`

    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
}

# Configure tab completion for 'docker_ros_setup'
complete -F _docker_ros_setup_comp docker_ros_setup

#
# Register container names and their IP addresses in /etc/hosts
#
function docker_ip_setup() {
  FILE="/etc/hosts"
  if [ "$1" != "" ]; then
      IP_ADDRESS=`docker inspect $1 | grep -E "IPAddress" | grep -o -m1 "[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+"`
      IF_EXISTS=`cat $FILE | grep $1`
    
      # If the specified container exists
      if [ "$IP_ADDRESS" != "" ]; then
        # If the entry for the container exists
        if [ "$IF_EXISTS" != "" ]; then
          bash -c "echo $IP_ADDRESS $1 && sudo sed -i 's/.*$1.*/$IP_ADDRESS $1/g' $FILE"
        else
          bash -c "echo $IP_ADDRESS $1 | sudo tee -a $FILE"
        fi
      fi
  else
    # If no args, set IP for all the containers
    list=`docker ps --format "{{.Names}}"`
    for container_name in $list; do
      IP_ADDRESS=`docker inspect $container_name | grep -E "IPAddress" | grep -o -m1 "[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+"`
      IF_EXISTS=`cat $FILE | grep $container_name`
      # If the specified container exists
      if [ "$IP_ADDRESS" != "" ]; then
        # If the entry for the container exists
        if [ "$IF_EXISTS" != "" ]; then
          bash -c "echo $IP_ADDRESS $container_name && sudo sed -i 's/.*$container_name.*/$IP_ADDRESS $container_name/g' $FILE"
        else
          bash -c "echo $IP_ADDRESS $container_name | sudo tee -a $FILE"
        fi
      fi
    done
  fi
}

# Tab completion for 'docker_ip_setup'
function _docker_ip_setup_comp() {
    local cur prev cword
    _get_comp_words_by_ref -n : cur prev cword
    opts=`docker ps --format "{{.Names}}"`

    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
}

# Configure tab completion for 'docker_ip_setup'
complete -F _docker_ip_setup_comp docker_ip_setup

alias ssh="ssh -Y $1"

function pdfmin()
{
  local cnt=0
  for i in $@; do
    gs -sDEVICE=pdfwrite \
      -dCompatibilityLevel=1.5 \
      -dPDFSETTINGS=/prepress \
      -dNOPAUSE -dQUIET -dBATCH \
      -sOutputFile=${i%%.*}.min.pdf ${i} &
    (( (cnt += 1) % 4 == 0 )) && wait
  done
  wait && return 0
}

export CXX=/usr/bin/clang++
export C=/usr/bin/clang

# alias nvitop="docker run -it --rm --runtime=nvidia --gpus=all --pid=host nvitop:latest"
function nvitop() {
  IMAGES=`docker images | grep nvitop`
  if [ "$IMAGES" == "" ]; then
    echo "Image 'nvitop' is not found. Build it."
    cd /tmp/ && git clone --depth=1 https://github.com/XuehaiPan/nvitop.git && cd nvitop  # clone this repo first
    docker build --build-arg http_proxy=${http_proxy} --build-arg https_proxy=${https_proxy} --tag nvitop:latest .  # build the Docker image
    cd -
  fi

  docker run -it --rm --gpus=all --pid=host nvitop:latest  # run the Docker container
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Matsuzaki/My docker compose aliases
function mdc () {
  if [ "$1" == "b" ]; then
    docker compose build --build-arg http_proxy=${http_proxy} --build-arg https_proxy=${http_proxy} $2
  elif [ "$1" == "r" ]; then
    docker compose run --rm $2
  elif [ "$1" == "e" ]; then
    docker exec -it $2 $3
  else
    echo "Usage: mdc [b|r|e] <args>"
  fi
}

complete -F _docker_ip_setup_comp mdc

function rm_submodule () {
  if [ "$1" == "" ]; then
    echo "Usage: rm_submodule <submodule_path>"
  else
    git submodule deinit -f $1
    git rm -f $1
    rm -rf .git/modules/$1
  fi
}

# alias db="docker compose build $1"
# alias dr="docker compose run --rm $1"
# alias de="docker exec -it $1 $2"
#
alias df="df -h"
alias du="du --max-depth=1 -h $1"
