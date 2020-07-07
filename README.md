# LRAP
* Low Resource Alpine Project
* Alpine Linux software selection and configuration for low resource usage

## Motivation

* This project aims to provide an alpine based environment which has a low
    resource footprint
* This is so that a Chrome OS-like experience can be provided on older machines
* The low resource usage is made possible through use of openbox and tint2
    to provide a minimal desktop environment
* The included script and configuration files streamline the setup process of
    such an environment

## Installation

* 1. Install Alpine to disk using the setup-alpine script
* 2. Reboot and log in
* 3. Use apk to install git
* 4. Clone this git repo and enter the directory
* 5. Run ./install as root

## Usage

* Ctrl-R can be used to start rofi launcher
* Ctrl-Alt-t can be used to start lxterminal

* Currently wifi must be managed manually with wpa_supplicant

## Configuration

* User configuration must be done through configuration files mostly
* Some software includes gui configuration tools

## TODO

* Create a configuration shell script to act as a settings menu -
    mostly so that wireless networks can be connected to easily
