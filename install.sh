#!/bin/sh

# Downloads the required packages
function download_packages {

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
    setup-xorg-base dbus-x11 xf86-video-intel xf86-input-synaptics \
        xf86-input-mouse xf86-input-keyboard
    # Fonts
     apk add terminus-font ttf-inconsolata ttf-dejavu font-noto \
        ttf-font-awesome font-noto-extra
    # Others 
     apk add dbus openbox lxterminal tint2 feh firefox picom \
        vim polkit consolekit2 paper-icon-theme arc-theme xrandr xbacklight \
        acpi tlp alsa-utils alsa-utils-doc alsa-lib alsaconf \
        volumeicon lightdm-gtk-greeter htop tmux pulseaudio pulseaudio-alsa \
        alsa-plugins-pulse pcmanfm pm-utils rofi neofetch sudo

    # Enable services
     rc-update add lightdm
     rc-update add dbus
     rc-update add acpid
     rc-update add alsa
     rc-update add wpa_supplicant
     rc-update add tlp

    # Install configuration menu
    cp util/lrap-config /sbin/lrap-config
    mkdir /etc/lrap-config

}

# Create a user
function create_user {
    echo "Enter name of user to create"
    read username
    adduser $username
    addgroup $username wheel
    addgroup $username audio
    addgroup $username netdev
    addgroup $username plugdev
    addgroup $username video
    chown $username /home/$username
}

# Copies configuration files
function copy_configs {
    # xinit
     echo "exec openbox-session" >> /etc/X11/xinit/xinitrc
    # openbox
     cp config/openbox/rc.xml /etc/xdg/openbox/rc.xml
     cp config/openbox/autostart /etc/xdg/openbox/autostart
     cp config/openbox/menu.xml /etc/xdg/openbox/menu.xml
    # Tint2
     cp config/tint2/tint2rc /etc/xdg/tint2/tint2rc
    # GTK
     cp config/gtk/gtkrc /etc/gtk-2.0/gtkrc
     cp config/gtk/settings.ini /etc/gtk-3.0/settings.ini
    # LID
     mkdir /etc/acpi/LID
     cp config/lid/00000080 /etc/acpi/LID/00000080
}

# Main
# LRAP Initial Install Script
echo "Installing LRAP Software package..."
download_packages
create_user
copy_configs
reboot
