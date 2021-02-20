# LRAP

* Low Resource Alpine Project
* Alpine Linux software selection and configuration for low resource usage

## Motivation

* This project aims to provide an alpine based environment which has a low
    resource footprint
* This is so that older machines can be used like Chromebooks
* The low resource usage is made possible through use of DWM, a lightweight
    window manager
    to provide a minimal desktop environment
* The included script and configuration files streamline the setup process of
    such an environment
* A configuration shell script is included to perform basic system management

## Installation

* 1. Install Alpine to disk using the setup-alpine script
* 2. Reboot and log in
* 3. Use apk to install git
* 4. Clone this git repo and enter the directory
* 5. Run ./install as root
* 6. Reboot
* 7. Use startx to launch the desktop

## Usage

* Alt-p can be used to start rofi launcher
* Alt-Shift-Enter can be used to start a terminal
* The configuration menu can be accessed by running lrap-config from the
	terminal

## Configuration

* Basic configuration can be done through the configuration menu
* This includes simple Wi-Fi management and resource overviews
* At this time, additional configuration must be performed using
    manually written configuration files for individual pieces of software
* More complicated Wi-Fi setups like eduroam will have to be done manually
* Please see the alpine wiki for more information on configuration

# Post Installation

* For a better web browsing experience on older machines, installing the
    following firefox extensions is recommended:
    * Ghostery - Blocks adverts to allow pages to load faster
    * User-Agent Switcher - Allows you to 'pretend' to be a smartphone
        and receive simpler versions of web pages

## Planned Features

* More advanced network configuration utilities
* User interface configuration utilities
* Improved setup procedure
* Easy update procedure
