#! /bin/bash


############################
##### Create symlinks ######
############################
<<<<<<< HEAD
ln -snf ~/my_dotfiles/.bashrc ~/.bashrc
#ln -s ~/my_dotfiles/.ros_setup ~/.ros_setup

ln -snf ~/my_dotfiles/.vimrc ~/.vimrc
ln -snf ~/my_dotfiles/.vim ~/.vim
#ln -s ~/my_dotfiles/.ycm_extra_conf.py ~/catkin_ws/.ycm_extra_conf.py

ln -snf ~/my_dotfiles/.tmux.conf ~/.tmux.conf
ln -snf ~/my_dotfiles/.tmux-powerlinerc ~/.tmux-powerlinerc
ln -snf ~/my_dotfiles/.tmuxinator ~/.tmuxinator
#ln -s ~/my_dotfiles/.tmuxautorun ~/.tmuxautorun

ln -snf ~/my_dotfiles/.latexmkrc ~/.latexmkrc
=======
ln -s ~/dotfiles/.bashrc ~/.bashrc
#ln -s ~/dotfiles/.ros_setup ~/.ros_setup

ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.vim ~/.vim
#ln -s ~/dotfiles/.ycm_extra_conf.py ~/catkin_ws/.ycm_extra_conf.py

ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.tmux-powerlinerc ~/.tmux-powerlinerc
ln -s ~/dotfiles/.tmuxinator ~/.tmuxinator
#ln -s ~/dotfiles/.tmuxautorun ~/.tmuxautorun

ln -s ~/dotfiles/.latexmkrc ~/.latexmkrc
>>>>>>> 802bc8a6f82f7e2ddeed8bc368a5fa8071dcf7a9



####################################
##### Install Shougo/neobundle #####
####################################
#git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
# Then, run :NeoBundleInstall on vim to install the other plugins



##################################
##### Install tmux-powerline #####
##################################
# Install tmux
<<<<<<< HEAD
# sudo apt-get install aptitude
# sudo aptitude install tmux # NOTE: tmux should be version 1.8. Please check whether you have the right version. If not, downgrade it via apt.
# 
# sudo gem install rubygems-update
# sudo update_rubygems
# sudo gem install tmuxinator
# 
# git clone git://github.com/erikw/tmux-powerline.git ~/tmux-powerline
# 
# 
# 
# #########################################################################
# ##### Install Ricty font (http://www.rs.tus.ac.jp/yyusa/ricty.html) #####
# #########################################################################
# # Install FontForge
# sudo add-apt-repository ppa:fontforge/fontforge
# sudo apt-get update
# sudo apt-get install fontforge
# 
# # Get Google Fonts Inconsolata and M+ IPA synthesized font Migu 1M
# mkdir ~/.fonts
# cp Ricty/Inconsolata/Inconsolata-Bold.ttf ~/.fonts/
# cp Ricty/Inconsolata/Inconsolata-Regular.ttf ~/.fonts/
# cp Ricty/migu-1m-20150712/migu-1m-bold.ttf ~/.fonts/
# cp Ricty/migu-1m-20150712/migu-1m-regular.ttf ~/.fonts/
# 
# # Run Ricty ge
# ./Ricty/ricty_generator.sh auto
# # or ./Ricty/ricty_generator.sh Inconsolata-{Regular,Bold}.ttf migu-1m-{regular,bold}.ttf
# mv Ricty-* ~/.fonts/
# mv RictyDiscord-* ~/.fonts/
# 
# # Scan font directories
# sudo fc-cache -vf
# fc-list | grep Ri
# 
# # Set Ricty as default font
# gconftool-2 --get /apps/gnome-terminal/profiles/Default/font # Show current font
# echo "->"
# gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/font "Ricty Regular 12"
=======
sudo apt-get install aptitude
sudo aptitude install tmux # NOTE: tmux should be version 1.8. Please check whether you have the right version. If not, downgrade it via apt.

sudo gem install rubygems-update
sudo update_rubygems
sudo gem install tmuxinator

git clone git://github.com/erikw/tmux-powerline.git ~/tmux-powerline



#########################################################################
##### Install Ricty font (http://www.rs.tus.ac.jp/yyusa/ricty.html) #####
#########################################################################
# Install FontForge
sudo add-apt-repository ppa:fontforge/fontforge
sudo apt-get update
sudo apt-get install fontforge

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
>>>>>>> 802bc8a6f82f7e2ddeed8bc368a5fa8071dcf7a9



#########################################################################
##### Install tex-related software #####
#########################################################################
#sudo apt-get install texlive-full
#sudo apt-get install latexmk



################################################################################################################################
###### Install Qt creator (ros_rqt_plugin:https://github.com/ros-industrial/ros_qtc_plugin/wiki/1.-How-to-Install-(Users)) #####
################################################################################################################################
## Installation for Ubuntu 14.04
#sudo add-apt-repository ppa:levi-armstrong/qt-libraries-trusty
#sudo add-apt-repository ppa:levi-armstrong/ppa
#sudo apt-get update && sudo apt-get install qt57creator-plugin-ros
#
## May need to remove old PPA
#sudo add-apt-repository --remove ppa:beineri/opt-qt57-trusty
#sudo add-apt-repository --remove ppa:beineri/opt-qt571-trusty
#
## Create a symbolic link file
#sudo ln -s /opt/qt57/bin/qtcreator-wrapper /usr/local/bin/qtcreator

