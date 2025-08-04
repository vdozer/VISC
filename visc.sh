#!/bin/bash

set -e
clear

# ASCII art with color
echo -e "\e[34m===.     :==--==.  :-====-:    .:-====-.  "
echo -e "\e[34m.+==    .+== ==+. ===-::-===  -===-::===- "
echo -e "\e[34m :==-   ==+. ==+. +==-:. --- -===     --- "
echo -e "\e[34m  ===: ==+.  ==+.  -=======: ===:         "
echo -e "\e[34m   ==+-==-   ==+.:--:  .:===:-==-     -=-."
echo -e "\e[34m   .+=+==    ==+..+==-:::===: ===-:.:-=== "
echo -e "\e[34m    :===     ==+.  -==+=+=-.   :-=+=+=-:  "
echo -e "\e[1;37mValentin's I3 Shell Script\e[0m"

# Detect distribution and install packages
if command -v apt &>/dev/null; then
    echo -e "\e[1;31mDetected Debian/Debian-based.\e[0m"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y i3 i3status dex xss-lock i3lock network-manager network-manager-gnome pulseaudio alsa-utils alacritty dmenu flameshot thunar picom feh fonts-dejavu-core
elif command -v pacman &>/dev/null; then
    echo -e "\e[1;36mDetected Arch Linux.\e[0m"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm i3 i3status dex xss-lock i3lock networkmanager network-manager-applet pulseaudio alacritty dmenu flameshot thunar picom feh ttf-dejavu
else
    echo "Unsupported distribution. Please install packages manually."
    exit 1
fi

# Clone dotfiles and copy specific configuration files and folders
git clone https://gitea.com/vozer/VISC.git ~/visc-temp

# Copy specific configuration folders to ~/.config
mkdir -p ~/.config
cp -r ~/visc-temp/i3 ~/.config/
cp -r ~/visc-temp/alacritty ~/.config/
cp -r ~/visc-temp/picom ~/.config/

# Copy .vimrc and .bashrc to home directory
cp ~/visc-temp/.vimrc ~/
cp ~/visc-temp/.bashrc ~/
cp ~/visc-temp/.xinitrc ~/

# Clean up the temporary dotfiles folder
rm -rf ~/visc-temp

# Also make a picture folder for Flameshot. Screenshots will be stored here.
mkdir -p ~/Pictures

# Prompt to install zsh and set as default shell
read -p $'\e[1;33mInstall zsh and set as default shell? (Y/n) \e[0m' choice
choice=${choice:-Y}  # Set default to Y if empty
if [[ "$choice" =~ ^[Yy]$ ]]; then
    if command -v apt &>/dev/null; then
        sudo apt install -y zsh
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm zsh
    fi
    chsh -s "$(which zsh)"
    echo -e "\e[1;32mZsh installed and set as default shell. You may need to log out and back in for changes to take effect.\e[0m"
fi

echo -e "\e[1;32mSetup complete! Thank you for using VISC\e[0m"
