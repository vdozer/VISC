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
if command -v pacman &>/dev/null; then
    echo -e "\e[1;36mDetected Arch Linux.\e[0m"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm i3 i3status dex xss-lock i3lock networkmanager network-manager-applet pulseaudio alacritty dmenu flameshot thunar picom feh ttf-dejavu
elif command -v apt &>/dev/null; then
    echo -e "\e[1;31mDetected Debian/Debian-based.\e[0m"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y i3 i3status dex xss-lock i3lock network-manager network-manager-gnome pulseaudio-utils alacritty dmenu flameshot thunar picom feh fonts-dejavu-core
elif command -v dnf &>/dev/null; then
    echo -e "\e[1;36mDetected Fedora.\e[0m"
    sudo dnf upgrade -y
    sudo dnf install -y i3 i3status dex xss-lock i3lock NetworkManager NetworkManager-plasma pulseaudio-utils alacritty dmenu flameshot thunar picom feh dejavu-sans-mono-fonts
elif command -v zypper &>/dev/null; then
    echo -e "\e[1;32mDetected OpenSUSE.\e[0m"
    sudo zypper refresh
    sudo zypper install -y i3 i3status dex xss-lock i3lock NetworkManager NetworkManager-pantheon pulseaudio-utils alacritty dmenu flameshot thunar picom feh fonts-dejavu
elif command -v emerge &>/dev/null; then
    echo -e "\e[1;35mDetected Gentoo.\e[0m"
    sudo emerge --sync
    sudo emerge -v x11-wm/i3 x11-misc/i3status x11-misc/dex x11-misc/xss-lock x11-misc/i3lock net-misc/networkmanager media-sound/pulseaudio app-emulation/alacritty app-misc/dmenu media-gfx/flameshot xfce-extra/thunar x11-misc/picom media-gfx/feh media-fonts/dejavu
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
mkdir Pictures

# Prompt to install zsh and set as default shell
read -p $'\e[1;33mInstall zsh and set as default shell? (Y/n) \e[0m' choice
if [ "$choice" = "Y" ] || [ "$choice" = "y" ] || [ -z "$choice" ]; then
    if command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm zsh
    elif command -v apt &>/dev/null; then
        sudo apt install -y zsh
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y zsh
    elif command -v zypper &>/dev/null; then
        sudo zypper install -y zsh
    elif command -v emerge &>/dev/null; then
        sudo emerge -v zsh
    fi
    chsh -s "$(which zsh)"
fi

echo -e "\e[1;32mSetup complete! Thank you for using VISC\e[0m"