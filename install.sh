#!/bin/bash

# Downloads the required packages
function download_packages {

    #Enable repos
    sudo echo "http://uk.alpinelinux.org/alpine/edge/community" \
        >> /etc/apk/repositories
    sudo echo "http://uk.alpinelinux.org/alpine/edge/testing" \
        >> /etc/apk/repositories
    sudo echo "http://uk.alpinelinux.org/alpine/edge/main" \
        >> /etc/apk/repositories
    # Update
    sudo apk update
    sudo apk upgrade
    # Install packages
    setup-xorg-base dbus-x11 xf86-video-intel xf86-input-synaptics \
        xf86-input-mouse xf86-input-keyboard
    # Fonts
    sudo apk add terminus-font ttf-inconsolata ttf-dejavu font-noto \
        ttf-font-awesome font-noto-extra
    # Others 
    sudo apk add dbus sudo openbox lxterminal tint2 feh firefox picom \
        vim polkit consolekit2 paper-icon-theme arc-theme xrandr xbacklight \
        acpi upowera tlp alsa-utils alsa-utils-doc alsa-lib alsaconf \
        volumeicon lightdm-gtk-greeter htop tmux pulseaudio pulseaudio-alsa \
        alsa-plugins-pulse pcmanfm pm-utils

    # Enable services
    sudo rc-update add lightdm
    sudo rc-update add dbus
    sudo rc-update add acpid
    sudo rc-update add alsa
    sudo rc-update add wpa_supplicant

}

# Create a user
function create_user {
    echo "Enter name of user to create"
    read username
    sudo adduser $username
    sudo addgroup $username wheel
    sudo addgroup $username audio
    sudo addgroup $username netdev
    sudo addgroup $username plugdev
    sudo addgroup $username video
}

# Copies configuration files
function copy_configs {
    # xinit
    sudo echo "exec openbox-session" >> /etc/X11/xinit/xinitrc
    # openbox
    sudo cp config/openbox/rc.xml /etc/xdg/openbox/rc.xml
    sudo cp config/openbox/autostart /etc/xdg/openbox/autostart
    sudo cp config/openbox/menu.xml /etc/xdg/openbox/menu.xml
    # Tint2
    sudo cp config/tint2/tint2rc /etc/xdg/tint2/tint2rc
    # GTK
    sudo cp config/gtk/gtkrc /etc/gtk-2.0/gtkrc
    sudo cp config/gtk/settings.ini /etc/gtk-3.0/settings.ini
    # LID
    sudo mkdir /etc/acpi/LID
    sudo cp config/lid/00000080 /etc/acpi/LID/00000080
}

# Main
# LRAP Initial Install Script
echo "Installing LRAP Software package..."
download_packages
create_user
copy_configs
sudo reboot
