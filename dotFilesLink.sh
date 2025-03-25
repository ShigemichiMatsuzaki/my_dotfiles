#!/bin/bash

###########################
#### Create symlinks ######
###########################
make_symlinks()
{
  ln -snf ~/my_dotfiles/.bashrc ~/.bashrc
  
  ln -snf ~/my_dotfiles/.vim/rc/.vimrc ~/.vimrc
  ln -snf ~/my_dotfiles/.vim ~/.vim
  
  ln -snf ~/my_dotfiles/.tmux.conf ~/.tmux.conf
  ln -snf ~/my_dotfiles/.tmux-powerlinerc ~/.tmux-powerlinerc
  ln -snf ~/my_dotfiles/.tmuxinator ~/.tmuxinator
  
  ln -snf ~/my_dotfiles/.latexmkrc ~/.latexmkrc
}

##################################
########## Install ROS ###########
##################################
install_ros()
{
  echo "Install ROS $1"
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
  
  sudo apt update && sudo apt install -y ros-noetic-"$1"
}

##################################
##### Install tmux-powerline #####
##################################
install_tmux()
{
  # Install tmux
  sudo apt-get update
  sudo apt install -y aptitude
  sudo aptitude install -y tmux # NOTE: tmux should be version 1.8. Please check whether you have the right version. If not, downgrade it via apt.
  
  sudo apt install -y gem ruby-dev build-essential gconf2
  sudo gem install -y rubygems-update
  sudo update_rubygems
  sudo gem install tmuxinator
  
  git clone git@github.com:erikw/tmux-powerline.git ~/tmux-powerline
}
 
# #########################################################################
# ##### Install Ricty font (http://www.rs.tus.ac.jp/yyusa/ricty.html) #####
# #########################################################################
install_font()
{
  # Install FontForge
  sudo apt-get install -y fontforge
  
  # Get Google Fonts Inconsolata and M+ IPA synthesized font Migu 1M
  mkdir ~/.fonts
  cp Ricty/Inconsolata/Inconsolata-Bold.ttf ~/.fonts/
  cp Ricty/Inconsolata/Inconsolata-Regular.ttf ~/.fonts/
  cp Ricty/migu-1m-20150712/migu-1m-bold.ttf ~/.fonts/
  cp Ricty/migu-1m-20150712/migu-1m-regular.ttf ~/.fonts/
  
  # Run Ricty ge
  ./Ricty/ricty_generator.sh auto
  # or ./Ricty/ricty_generator.sh Inconsolata-{Regular,Bold}.ttf migu-1m-{regular,bold}.ttf
  mv Ricty-* ~/.fonts/
  mv RictyDiscord-* ~/.fonts/
  
  # Scan font directories
  sudo fc-cache -vf
  fc-list | grep Ri
  
  # Set Ricty as default font
  gconftool-2 --get /apps/gnome-terminal/profiles/Default/font # Show current font
  echo "->"
  gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/font "Ricty Regular 12"
}

#########################################################################
##### Install tex-related software #####
#########################################################################
install_latex()
{
  sudo apt-get install texlive-full
  sudo apt-get install latexmk
}

install_vim()
{
  # Node.js for Coc (plugin for code completion)
  # https://gist.github.com/budiantoip/fb4d04c80f4cf05f33deace08984e8eb
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  ## TODO: fix this part so that `nvm install` is automatically executed 
  # source ${HOME}/.nvm/nvm.sh
  # nvm install --lts
  
  # Latest version of Vim
  sudo apt purge -y vim
  sudo add-apt-repository ppa:jonathonf/vim
  sudo apt update 
  sudo apt install -y vim
}

install_nvidia_driver()
{
  echo "Installing NVIDIA Driver..."
  sudo apt update
  sudo apt install -y ubuntu-drivers-common
  ubuntu-drivers devices
  sudo ubuntu-drivers autoinstall
  sudo update-initramfs -u
  echo "NVIDIA Driver installation completed."
}

install_cuda()
{
  echo "Installing CUDA..."
  sudo apt purge -y '*cuda*'
  sudo apt update
  sudo apt upgrade -y
  distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
  wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.pin
  sudo mv cuda-$distribution.pin /etc/apt/preferences.d/cuda-repository-pin-600
  sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/3bf863cc.pub
  echo "deb https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list
  sudo apt update
  sudo apt install -y cuda
  echo "CUDA installation completed."
}

install_docker()
{
  # Uninstall already installed Docker and related packages
  sudo apt-get remove docker docker-engine docker.io containerd runc

  # Set up keys
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Install Docker Engine
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
  sudo docker run hello-world # Test

  # Install NVIDIA docker
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \ && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \ && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  sudo apt-get update
  sudo apt-get install -y nvidia-docker2
  sudo systemctl restart docker
  sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
}

install_docker_with_nvidia()
{
  echo "Installing Docker with NVIDIA Container Toolkit..."
  sudo apt-get remove -y docker docker-engine docker.io containerd runc
  sudo apt update
  sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  sudo apt update
  sudo apt install -y nvidia-container-toolkit
  sudo systemctl restart docker
  sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
  echo "Docker with NVIDIA Container Toolkit installation completed."
}

################
##### MAIN #####
################
sudo apt update
sudo apt install -y \
  curl \
  git \
  ca-certificates \
  curl \
  gnupg \
  software-properties-common \
  lsb-release

#
# Options
#
VALID_ARGS=$(getopt -o alr:vtfcd --long all,ln,ros:,vim,tmux,font,latex,cuda,docker -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$VALID_ARGS"
ROS_DEFAULT="desktop-full"
while [ : ]; do
  case "$1" in
    -a | --all)
      echo "Install everything"
      make_symlinks
      install_tmux
      install_ros
      install_vim
      install_tmux
      install_latex
      shift 2
      ;;
    -l | --ln)
      echo "Make symlinks"
      make_symlinks
      shift
      ;;
    -r | --ros)
      if [ "$2" != "desktop-full" && "$2" != "desktop" && "$2" != "ros-base" && "$2" != "ros-core" ]; then
        ROS_VERSION="$ROS_DEFAULT"
        shift
      else
        ROS_VERSION="$2"
        shift 2
      fi 
      install_ros "$ROS_VERSION"
      ;;
    -v | --vim)
      echo "(Re-)Install Vim"
      install_vim
      shift
      ;;
    -t | --tmux)
      echo "(Re-)Install tmux"
      install_tmux
      shift
      ;;
    --latex)
      echo "(Re-)Install LaTeX and related software"
      install_latex
      shift
      ;;
    -c | --cuda)
      echo "(Re-)Install CUDA"
      install_cuda
      shift
      ;;
    -d | --docker)
      echo "(Re-)Install Docker"
      install_docker_with_nvidia
      shift
      ;;
    --) shift; 
      break 
      ;;
  esac
done
