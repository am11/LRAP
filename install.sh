#!/bin/sh

# Downloads the required packages
function download_packages {
    print_header "Package Installation"
    #Enable repos
    echo "http://uk.alpinelinux.org/alpine/edge/community" \
        >> /etc/apk/repositories
    echo "http://uk.alpinelinux.org/alpine/edge/testing" \
        >> /etc/apk/repositories
    echo "http://uk.alpinelinux.org/alpine/edge/main" \
        >> /etc/apk/repositories
    # Update
    apk update
    apk upgrade
    # Install packages
    setup-xorg-base
    # Fonts
    apk add terminus-font ttf-inconsolata ttf-dejavu font-noto \
        ttf-font-awesome font-noto-extra
    # Others 
    apk add dbus dbus-x11 feh firefox picom \
    vim polkit consolekit2 paper-icon-theme arc-theme xrandr xbacklight \
    acpi tlp alsa-utils alsa-utils-doc alsa-lib alsaconf \
    htop tmux pulseaudio pulseaudio-alsa \
    alsa-plugins-pulse pcmanfm pm-utils neofetch sudo \
    slock setxkbmap dmenu xsetroot wireless-tools wpa_supplicant
    # Build
    apk add build-base make libx11 libx11-dev libxft-dev libxinerama-dev ncurses

    # Enable services
    rc-update add dbus
    rc-update add acpid
    rc-update add alsa
    rc-update add wpa_supplicant
    rc-update add tlp

    # Install configuration menu
    cp util/lrap-config /sbin/lrap-config
    mkdir /etc/lrap-config

    echo "--> Done!"

}

# Create a user
function create_user {
    print_header "User Creation"
    echo "--> Enter name of user to create"
    read -p "> " username
    adduser $username
    addgroup $username wheel
    addgroup $username audio
    addgroup $username netdev
    addgroup $username video
    addgroup $username floppy
    addgroup $username cdrom
    addgroup $username tape
    addgroup $username usb
    addgroup $username users
    chown $username /home/$username
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers 
    cp config/wallpaper.jpg /home/$username/
}

# Copies configuration files
function copy_configs {
    print_header "Installing Configuration Files"
    # GTK
    cp config/gtk/gtkrc /etc/gtk-2.0/gtkrc
    cp config/gtk/settings.ini /etc/gtk-3.0/settings.ini
    # LID
    mkdir /etc/acpi/LID
    cp config/lid/00000080 /etc/acpi/LID/00000080
    # Xorg
    mkdir /etc/X11/xorg.conf.d
    cp config/xorg/* /etc/X11/xorg.conf.d/
    cp config/xinit/xinitrc /etc/X11/xinit/
    echo "--> Done!"
}

# Installs suckless apps
function install_suckless {
    print_header "Installing Suckless Apps"
    mkdir ./suckless && cd suckless
    # Dwm
    git clone https://git.suckless.org/dwm
    cp ../config/suckless/dwm_config.h ./dwm/config.h
    cd dwm && make clean install
    cd ../
    # St
    git clone https://git.suckless.org/st
    cp ../config/suckless/st_config.h ./st/config.h
    cd st && make clean install
    cd ../../
    echo "--> Done!"
}

# Header printing function
function print_header() {
    echo "============================================================================="
    echo "| $1"
    echo "============================================================================="
}

# Main
# LRAP Initial Install Script
print_header "Installing LRAP Software Package"
download_packages
create_user
install_suckless
copy_configs
echo "--> Installation has finished, please reboot"
