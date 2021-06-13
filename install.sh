#!/bin/sh

username=

# Downloads the required packages
download_packages() {
    print_header "Package Installation"
    #Enable repos
    sed -i 's|#http://dl-cdn|http://dl-cdn|g' /etc/apk/repositories
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
        slock setxkbmap dmenu xsetroot wireless-tools wpa_supplicant \
        xinput fontconfig flatpak alacritty nano nano-syntax i3lock light \
        py3-pip curl less thunar tumbler scrot lightdm-gtk-greeter ffmpeg-dev \
        libimobiledevice libimobiledevice-progs idevicerestore ideviceinstaller \
        ifuse libirecovery libideviceactivation libusb usbmuxd libplist-util \
        xdg-utils virt-manager libvirt-daemon qemu-openrc qemu-modules \
        qemu-system-x86_64 terminus-font docker shadow imagemagick
    # Build
    apk add build-base make libx11 libx11-dev libxft-dev libxinerama-dev ncurses ncurses-dev

    # Enable services
    rc-update add dbus
    rc-update add acpid
    rc-update add alsa
    rc-update add wpa_supplicant
    rc-update add tlp
    rc-update add lightdm
    rc-update add docker
    rc-update add libvirtd

    # Install dri and egl
    apk add mesa-dri-gallium mesa-egl

    # Install Apple emojis
    mkdir -p /usr/share/fonts/apple
    (cd /usr/share/fonts/apple && curl -SLO \
        https://github.com/samuelngs/apple-emoji-linux/releases/download/latest/AppleColorEmoji.ttf)
    fc-cache -fv

    # Copy i3lock background
    mkdir -p /usr/share/i3lock
    curl -O http://justfunfacts.com/wp-content/uploads/2016/11/crane-chick.jpg
    mogrify -format png crane-chick.jpg
    convert crane-chick.png -resize $(cat /sys/class/graphics/fb0/virtual_size | awk -F, '{print $1 "x" $2}')! /usr/share/i3lock/crane-chick.png
    rm crane-chick.*

    # Add tun to modules
    echo tun >> /etc/modules

    echo "--> Done!"
}

# Create a user
create_user() {
    print_header "User Creation"
    echo "--> Enter name of user to create"
    read -rp "> " username
    adduser -g "$username" "$username"
    addgroup "$username" wheel
    addgroup "$username" audio
    addgroup "$username" netdev
    addgroup "$username" video
    addgroup "$username" floppy
    addgroup "$username" cdrom
    addgroup "$username" tape
    addgroup "$username" usb
    addgroup "$username" users
    chown "$username" /home/"$username"
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
}

# Copies configuration files
copy_configs() {
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

    mkdir /usr/share/xsessions
    cp dwm.desktop /usr/share/xsessions

    echo "--> Done!"
}

# Installs suckless apps
install_suckless() {
    print_header "Installing Suckless Apps"
    mkdir ./suckless && cd suckless
    # Dwm
    git clone https://git.suckless.org/dwm --single-branch --depth 1
    cp ../config/suckless/dwm_config.h ./dwm/config.h
    cd dwm
    curl -sS https://dwm.suckless.org/patches/movestack/dwm-movestack-6.1.diff |\
        git apply --include=movestack.c -
    make clean install
    cd ../
    # St

    git clone https://git.suckless.org/st --single-branch --depth 1
    cp ../config/suckless/st_config.h ./st/config.h
    cd st && make clean install
    cd ../../
    echo "--> Done!"
}

# Header printing function
print_header() {
    echo "============================================================================="
    echo "| $1"
    echo "============================================================================="
}

copy_user_configs() {
    cp .profile /home/"$username"

    mkdir -p /home/"$username"/.config/alacritty
    cp ./alacritty.yml /home/"$username"/.config/alacritty

    mkdir -p /home/"$username"/.config/fontconfig
    cp fonts.conf /home/"$username"/.config/fontconfig

    find /usr/share/nano/ -iname "*.nanorc" -exec echo include {} \; >> /home/"$username"/.nanorc

    mkdir -p /home/"$username"/.weather
    cp weather_show /home/"$username"/.weather/show

    git clone https://github.com/xorg62/tty-clock /home/"$username"/.tty-clock
    make -C /home/"$username"/.tty-clock

    mkdir -p /home/"$username"/Pictures/Screenshots

    mkdir -p /home/"$username"/.config/htop
    echo "hide_function_bar=2" > /home/"$username"/.config/htop/htoprc2

    chown "$username" -R /home/"$username"

    addgroup "$username" docker

    curl -o /home/"$username"/.config/wallpaper.jpg \
        https://wallup.net/wp-content/uploads/2015/12/105133-trees-red-sky-horizon-clouds-nature-landscape.jpg
}

install_flatpaks() {
    # Install flatpaks as user
    su "$username" -c 'flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo'
    su "$username" -c 'flatpak install flathub --user -y \
        com.spotify.Client \
        com.vscodium.codium \
        org.mozilla.firefox'

    echo -e "#!/bin/sh\n\nflatpak run com.spotify.Client\n" > /usr/bin/spotify
    echo -e "#!/bin/sh\n\nflatpak run com.vscodium.codium\n" > /usr/bin/codium
    echo -e "#!/bin/sh\n\nflatpak run org.mozilla.firefox\n" > /usr/bin/ffbox

    chmod +x /usr/bin/spotify /usr/bin/codium /usr/bin/ffbox
}

# Main
# LRAP Initial Install Script
print_header "Installing LRAP Software Package"
create_user
download_packages
install_flatpaks
install_suckless
copy_configs
copy_user_configs
echo "--> Installation has finished, please reboot"
