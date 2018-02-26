#!/bin/bash
## @file
## @author Paweł Roszatycki <pawel@roszatycki.pl>
## @brief e-Deklaracje installer
## @copyright GNU GPL v3
## @version 1.0.0
##

## @fn checkFmenuileExists
## @brief Function menu
function menu() {
    echo -e "\n\ne-deklaracje installer:\nOption 1 - Update Your system\nOption 2 - Install Adobe Reader\nOption 3 - Install Adobe Air\nOption 4 - Install e-Deklaracje\nOption 5 - Uninstall Adobe Reader\nOption 6 - Uninstall Adobe Air\nOption 7 - Uninstall e-Deklaracje"
    PS3="Please enter your choice: "
    options=("Option 1" "Option 2" "Option 3" "Option 4" "Option 5" "Option 6" "Option 7" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Option 1")
                updateSystem
                ;;
            "Option 2")
                installAdobeReader
                ;;
            "Option 3")
                installAdobeAir
                ;;
            "Option 4")
                installeDeklaracje
                ;;
            "Option 5")
                uninstallAdobeReader
                ;;
            "Option 6")
                uninstallAdobeAir
                ;;
            "Option 7")
                uninstallDeklaracje
                ;;
            "Quit")
                clean
                break
                ;;
            *) echo "Invalid option";;
        esac
    done
}

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

## @fn checkDirExists
## @brief Function directory file exist
## @param ${1} – directory ex. ‘abc’
## @param ${2} – return variable
## @return true if the directory is exist, otherwise false
function checkDirExists() {
    if [ -d "$DIRECTORY" ]
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

## @fn updateSystem
## @brief Function update system
function updateSystem() {
    apt-get update
    apt-get full-upgrade -y
    apt-get autoremove -y
}

## @fn installLibs
## @brief Function install necessary libraries
function installLibs() {
    apt-get install wget -y
    apt-get install p7zip-full -y
}

## @fn installAdobeAir
## @brief Function install Adobe Air
function installAdobeAir() {
    wget http://airdownload.adobe.com/air/lin/download/2.6/AdobeAIRSDK.tbz2 #2.6
    wget https://github.com/pawel112/linux-install-eDeklaracje/blob/master/adobe-air.tar.gz #latest
    mkdir /opt/Adobe/Air
    tar jxf AdobeAIRSDK.tbz2 -C /opt/Adobe/Air

    tar xvf adobe-air.tar.gz -C /opt/Adobe/Air
    chmod +x /opt/Adobe/Air/adobe-air/adobe-air

    apt-get install libgtk2.0-0:i386 libstdc++6:i386 libxml2:i386 libxslt1.1:i386 libcanberra-gtk-module:i386 gtk2-engines-murrine:i386 libqt4-qt3support:i386 libgnome-keyring0:i386 libnss-mdns:i386 libnss3:i386 -y
    ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0 /usr/lib/libgnome-keyring.so.0
    ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0.2.0 /usr/lib/libgnome-keyring.so.0.2.0

    checkFileExists '/opt/Adobe/Air/bin/adl' result

    if [ "$result" -eq "0" ];
    then
        echo "Adobe Air installed failed"
        exit 1
    fi
}

## @fn installAdobeReader
## @brief Function install Adobe Reader
function installAdobeReader() {
    wget ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb #9.5.5
    dpkg -i AdbeRdr9.5.5-1_i386linux_enu.deb
    apt-get install -f

    checkFileExists '/opt/Adobe/Reader9/bin/acroread' result

    if [ "$result" -eq "0" ];
    then
        echo "Adobe Reader installed failed"
        exit 1
    fi
}

## @fn installeDeklaracje
## @brief Function install e-Deklaracje
function installeDeklaracje() {
    wget http://www.finanse.mf.gov.pl/documents/766655/1196444/e-DeklaracjeDesktop.air #latest
    mkdir e-deklaracje
    mkdir /opt/e-deklaracje
    cp e-DeklaracjeDesktop.air /opt/e-deklaracje/
    mv e-DeklaracjeDesktop.air e-deklaracje/e-DeklaracjeDesktop.air
    cd e-deklaracje
    unzip e-DeklaracjeDesktop.air
    cp assets/icons/icon128.png /opt/e-deklaracje/e-deklaracje.png
    cd ..

    cat <<__CONF__ | tee $HOME/.local/share/applications/e-deklaracje.desktop
[Desktop Entry]
Type=Application
Terminal=false
Categories=Office
Exec=/opt/Adobe/Air/adobe-air/adobe-air /opt/e-deklaracje/e-DeklaracjeDesktop.air
Icon=/opt/e-deklaracje/e-deklaracje.png
Name=e-Deklaracje
__CONF__

	chmod +x $HOME/.local/share/applications/e-deklaracje.desktop

	checkFileExists '/opt/e-deklaracje/e-DeklaracjeDesktop.air' result

    if [ "$result" -eq "0" ];
    then
        echo "e-Deklaracje installed failed"
        exit 1
    fi
}

## @fn clean
## @brief Function remove temporary files
function clean() {
    checkFileExists 'AdbeRdr9.5.5-1_i386linux_enu.deb' result

    if [ "$result" -eq "1" ];
    then
        rm AdbeRdr9.5.5-1_i386linux_enu.deb
    fi

    checkFileExists 'AdobeAIRSDK.tbz2' result

    if [ "$result" -eq "1" ];
    then
        rm AdobeAIRSDK.tbz2
    fi

    checkFileExists 'adobe-air.tar.gz' result

    if [ "$result" -eq "1" ];
    then
        rm adobe-air.tar.gz
    fi

    checkDirExists 'e-deklaracje' result

    if [ "$result" -eq "1" ];
    then
        rm e-deklaracje -r
    fi
}

## @fn uninstallAdobeReader
## @brief Function uninstall Adobe Reader
function uninstallAdobeReader() {
    apt-get purge adobereader-enu -y

    checkFileExists '/opt/Adobe/Air/bin/adl' result

    if [ "$result" -eq "1" ];
    then
        echo "Adobe Air uninstall failed"
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

clean
checkRoot
installLibs
menu
