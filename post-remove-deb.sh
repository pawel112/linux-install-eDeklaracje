#!/bin/bash
## @file
## @author Paweł Roszatycki <pawel@roszatycki.pl>
## @brief e-Deklaracje installer
## @copyright GNU GPL v3
## @version 1.0.0
##


## @fn checkFileExists
## @brief Function check file exist
## @param ${1} – filename ex. ‘file.txt’
## @param ${2} – return variable
## @return true if the file is exist, otherwise false
function checkFileExists() {
    if [ -f "${1}" ]
    then
        eval ${2}="'1'"
    else
        eval ${2}="'0'"
    fi
}

## @fn checkRoot
## @brief Function check is script run by root user
function checkRoot() {
    if [[ $EUID -ne 0 ]];
    then
        echo "This script must be run as root"
        exit 1
    fi
}

## @fn uninstallAdobeAir
## @brief Function uninstall Adobe Air
function uninstallAdobeAir() {
    rm /opt/Adobe/Air/ -r

    checkFileExists '/usr/lib/libgnome-keyring.so.0' result

    if [ "$result" -eq "1" ];
    then
        rm /usr/lib/libgnome-keyring.so.0
    fi

    checkFileExists '/usr/lib/libgnome-keyring.so.0.2.0' result

    if [ "$result" -eq "1" ];
    then
        rm /usr/lib/libgnome-keyring.so.0.2.0
    fi

    checkFileExists '/opt/Adobe/Air/bin/adl' result

    if [ "$result" -eq "1" ];
    then
        echo "Adobe Air uninstall failed"
        exit 1
    fi
}

## @fn uninstallDeklaracje
## @brief Function uninstall e-Deklaracje
function uninstallDeklaracje() {
    rm /opt/e-deklaracje/ -r
    rm $HOME/.local/share/applications/e-deklaracje.desktop

    checkFileExists '/opt/e-deklaracje/e-DeklaracjeDesktop.air' result

    if [ "$result" -eq "1" ];
    then
        echo "e-Deklaracje uninstall failed"
        exit 1
    fi
}

checkRoot
uninstallAdobeAir
uninstallDeklaracje