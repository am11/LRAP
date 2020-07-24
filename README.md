# LRAP

* Low Resource Alpine Project
* Alpine Linux software selection and configuration for low resource usage

## Motivation

* This project aims to provide an alpine based environment which has a low
    resource footprint
* This is so that older machines can be used like Chromebooks
* The low resource usage is made possible through use of openbox and tint2
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

## Usage

* Ctrl-R can be used to start rofi launcher
* Ctrl-Alt-t can be used to start lxterminal

* Right clicking on the desktop allows the configuration menu to be launched

## Configuration

* Basic configuration can be done through the configuration menu
* This includes simple Wi-Fi management and resource overviews
* At this time, additional configuration must be performed using
    manually written configuration files for individual pieces of software
* More complicated Wi-Fi setups like eduroam will have to be done manually

## Planned Features

* More advanced network configuration utilities
* User interface configuration utilities
* Improved setup procedure
* Easy update procedure
