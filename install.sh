#!/bin/sh

# Downloads the required packages
function download_packages {
    print_header "Downloading Packages"
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
    apk add dbus feh firefox picom \
    vim polkit consolekit2 paper-icon-theme arc-theme xrandr xbacklight \
    acpi tlp alsa-utils alsa-utils-doc alsa-lib alsaconf \
    htop tmux pulseaudio pulseaudio-alsa \
    alsa-plugins-pulse pcmanfm pm-utils neofetch sudo \
    slock setxkbmap dmenu
    # Build
    apk add gcc make libx11

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
    addgroup $username plugdev
    addgroup $username video
    chown $username /home/$username
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers 
    cp config/wallpaper.jpg /home/$username/
}

# Copies configuration files
function copy_configs {
    print_header "Installing Configuration Files"
    # xinit
    echo "exec openbox-session" >> /etc/X11/xinit/xinitrc
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
    # Slstatus
    git clone https://git.suckless.org/slstatus
    cp ../config/suckless/slstatus_config.h ./slstatus/config.h
    cd slstatus && make clean install
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
    width=`tput cols`
    line=""
    i=0
    while["$i" -l "$width"]; do 
        line+="="
    done
    echo $line
    echo $1
    echo $line
}

# Main
# LRAP Initial Install Script
print_header "Installing LRAP Software Package"
download_packages
create_user
install_suckless
copy_configs
echo "--> Rebooting..."
reboot
