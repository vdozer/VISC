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
echo -e "\e[1;37mValentin's I3 Shell Script [Revised]\e[0m"

# Prompt for graphics drivers
read -p $'\e[1;33mInstall graphics drivers? (Y/n) \e[0m' gpu_choice
gpu_choice=${gpu_choice:-Y}

# Detect distribution and install packages
if command -v pacman &>/dev/null; then
    echo -e "\e[1;36mDetected Arch Linux.\e[0m"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm \
        i3 i3status dex xss-lock i3lock networkmanager network-manager-applet \
        pulseaudio alacritty dmenu flameshot thunar picom feh ttf-dejavu pciutils git

    # Graphics drivers
    if [[ $gpu_choice =~ ^[Yy]$ ]]; then
        echo "Detecting GPU..."
        if lspci | grep -E "NVIDIA|3D controller"; then
            echo -e "\e[1;32mInstalling NVIDIA drivers...\e[0m"
            sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
        elif lspci | grep -E "AMD|Radeon"; then
            echo -e "\e[1;32mInstalling AMD drivers...\e[0m"
            sudo pacman -S --noconfirm mesa vulkan-radeon libva-mesa-driver
        else
            echo -e "\e[1;32mInstalling default Mesa drivers...\e[0m"
            sudo pacman -S --noconfirm mesa
        fi
    fi

elif command -v apt &>/dev/null; then
    echo -e "\e[1;31mDetected Debian/Debian-based.\e[0m"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y \
        i3 i3status dex xss-lock i3lock network-manager network-manager-gnome \
        pulseaudio-utils alacritty dmenu flameshot thunar picom feh fonts-dejavu-core pciutils git

    if [[ $gpu_choice =~ ^[Yy]$ ]]; then
        echo "Detecting GPU..."
        if lspci | grep -E "NVIDIA|3D controller"; then
            echo -e "\e[1;32mInstalling NVIDIA drivers...\e[0m"
            sudo apt install -y nvidia-driver libnvidia-glvkspirv
        elif lspci | grep -E "AMD|Radeon"; then
            echo -e "\e[1;32mInstalling AMD drivers...\e[0m"
            sudo apt install -y mesa-vulkan-drivers libva-mesa-driver
        else
            echo -e "\e[1;32mInstalling default Mesa drivers...\e[0m"
            sudo apt install -y mesa-utils
        fi
    fi

elif command -v dnf &>/dev/null; then
    echo -e "\e[1;36mDetected Fedora.\e[0m"
    sudo dnf upgrade -y
    sudo dnf install -y \
        i3 i3status dex xss-lock i3lock NetworkManager NetworkManager-plasma \
        pulseaudio-utils alacritty dmenu flameshot thunar picom feh dejavu-sans-mono-fonts pciutils git

    if [[ $gpu_choice =~ ^[Yy]$ ]]; then
        echo "Detecting GPU..."
        if lspci | grep -E "NVIDIA|3D controller"; then
            echo -e "\e[1;32mInstalling NVIDIA drivers...\e[0m"
            sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
        elif lspci | grep -E "AMD|Radeon"; then
            echo -e "\e[1;32mInstalling AMD drivers...\e[0m"
            sudo dnf install -y mesa-vulkan-drivers libva-mesa-driver
        else
            echo -e "\e[1;32mInstalling default Mesa drivers...\e[0m"
            sudo dnf install -y mesa-dri-drivers
        fi
    fi
else
    echo "Unsupported distribution. Please install packages manually."
    exit 1
fi

# Make LY the default display manager everywhere
echo -e "\e[1;36mInstalling and enabling LY display manager...\e[0m"
	if command -v pacman &>/dev/null; then
		sudo pacman -S --noconfirm ly
		sudo systemctl enable ly.service
	elif command -v apt &>/dev/null; then
		sudo apt install -y git build-essential libpam0g-dev libxcb-xkb-dev
		git clone https://github.com/fairyglade/ly ~/ly
		cd ~/ly && make && sudo make install
		sudo systemctl enable ly.service
		rm -rf ~/ly
	elif command -v dnf &>/dev/null; then
		sudo dnf install -y git pam-devel xcb-util xcb-util-keysyms-devel make gcc ncurses-devel
		git clone https://github.com/fairyglade/ly ~/ly
		cd ~/ly && make && sudo make install
		sudo systemctl enable ly.service
		rm -rf ~/ly
fi

# Clone dotfiles and copy configuration
git clone https://github.com/vdozer/VISC.git ~/visc-temp
mkdir -p ~/.config
cp -r ~/visc-temp/{i3,alacritty,picom} ~/.config/
cp ~/visc-temp/{.vimrc,.bashrc,.xinitrc} ~/
rm -rf ~/visc-temp

# Create Pictures directory
mkdir -p ~/Pictures

# ZSH prompt
read -p $'\e[1;33mInstall zsh and set as default shell? (Y/n) \e[0m' choice
choice=${choice:-Y}
if [[ $choice =~ ^[Yy]$ ]]; then
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

echo -e "\e[1;32mSetup complete! You can reboot now.\e[0m"
