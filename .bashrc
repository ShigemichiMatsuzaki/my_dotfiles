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

export PYTHONPATH=~/caffe-segnet/python:$PYTHONPATH

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias sb='source ~/.bashrc'
<<<<<<< HEAD
alias bsh='vim ~/.bashrc'
alias rsetup='source /opt/ros/kinetic/setup.bash && source ~/catkin_ws/devel/setup.bash && export PATH="" && export PATH="/opt/ros/kinetic/bin:/home/aisl/bin:/home/aisl/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"'
alias msetup='export ROS_IP=192.168.0.101 && export ROS_MASTER_URI=http://192.168.0.30:11311'
alias lsetup='export ROS_IP=192.168.0.101 && export ROS_MASTER_URI=http://localhost:11311'
=======
>>>>>>> 802bc8a6f82f7e2ddeed8bc368a5fa8071dcf7a9

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

source ~/.ros_setup
ulimit -c unlimited

PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
source ~/.tmuxinator/tmuxinator.bash
#source ~/.tmuxautorun
<<<<<<< HEAD

export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/aisl/catkin_ws/src/ORB_SLAM2/Examples/ROS

#
# HSR related setups
#
#network_if=enp5s0
network_if=wlp4s0

if [ -e /opt/ros/kinetic/setup.bash ] ; then
    source /opt/ros/kinetic/setup.bash
else
    echo "ROS packages are not installed."
fi

source ~/motion_samples_ws/devel/setup.bash

export TARGET_IP=$(LANG=C /sbin/ifconfig $network_if | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
if [ -z "$TARGET_IP" ] ; then
    echo "ROS_IP is not set."
else
    export ROS_IP=$TARGET_IP
fi
export ROS_HOME=~/.ros
alias sim_mode='export ROS_MASTER_URI=http://localhost:11311 export PS1="\[\033[44;1;37m\]<local>\[\033[0m\]\w$ "'
alias hsrb_mode='export ROS_MASTER_URI=http://hsrb.local:11311 export PS1="\[\033[41;1;37m\]<hsrb>\[\033[0m\]\w$ "'

alias hsrviz="rosrun rviz rviz -d `rospack find hsrb_common_launch`/config/hsrb_display_full_hsrb.rviz"
alias hsr_sim="roslaunch hsrb_gazebo_launch hsrb_megaweb2015_world.launch"

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

export DOCKER_USER="--user=$(id -u):$(id -g) $(for i in $(id -G); do echo -n " --group-add "$i; done) --workdir=/home/$USER --volume=/home/$USER:/home/$USER --volume=/etc/group:/etc/group:ro --volume=/etc/passwd:/etc/passwd:ro --volume=/etc/shadow:/etc/shadow:ro --volume=/etc/sudoers.d:/etc/sudoers.d:ro"
export DOCKER_DISP="$DOCKER_USER --env=DISPLAY=$DISPLAY --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw -e QT_X11_NO_MITSHM=1"

# added by Anaconda3 installer
#export PATH="/home/aisl/anaconda3/bin:$PATH"

export GIT_SSL_NO_VERIFY=1
=======
>>>>>>> 802bc8a6f82f7e2ddeed8bc368a5fa8071dcf7a9
