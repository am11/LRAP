#!/bin/bash
# Lightweight system configuration utility
# JEASH1 - 2020

# Should control the following
# Wi-Fi
# Bluetooth
# User accounts
# 

# Main menu function
function main_menu {
clear
echo "---------------------------------------"
echo "  _____ ____  _   _ ______ _____ _____"
echo " / ____/ __ \| \ | |  ____|_   _/ ____|"
echo "| |   | |  | |  \| | |__    | || |  __"
echo "| |   | |  | |     |  __|   | || | |_ |"
echo "| |___| |__| | |\  | |     _| || |__| |"
echo " \_____\____/|_| \_|_|    |_____\_____|"
echo "---------------------------------------"
echo ""
echo ""
echo "[0] Exit"
echo "[1] Wi-Fi Settings"
echo "[9] Misc Settings"
echo "---------------------------------------"
# Get the selection
read selection
case "$selection" in
    0)
        # Do nothing
    ;;
    1)
        wifi_menu 
    ;;

    9)
        misc_menu
    ;;

    *)
        main_menu
    ;;
esac
}

# Wifi menu function
function wifi_menu {
clear
echo "---------------------------------------"
echo "Wi-Fi Settings"
echo "---------------------------------------"
echo "[0] Back"
echo "---------------------------------------"
# Get the selection
read selection
case "$selection" in
    0)
        main_menu 
    ;;

    *)
        wifi_menu
    ;;
esac
}

# Misc Menu function
function misc_menu {
clear
echo "---------------------------------------"
echo "Misc Settings"
echo "---------------------------------------"
echo "[0] Back"
echo "---------------------------------------"
# Get the selection
read selection
case "$selection" in
    0)
        main_menu
    ;;

    *)
        misc_menu
    ;;
esac
}


# Run the main menu
main_menu
