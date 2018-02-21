## Instalacja eDeklaracje na Linuxie

Rozlicz PIT na Linuxie (testowano na Ubuntu 17.10)

# Instrukcja (skrypt)

    wget https://raw.githubusercontent.com/pawel112/linux-install-eDeklaracje/master/script.sh
    chmod +x ./script.sh
    sudo ./script.sh

# Instrukcja (paczka DEB)
    wget ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb
    sudo dpkg -i AdbeRdr9.5.5-1_i386linux_enu.deb
    sudo apt-get install -f
    
    wget https://github.com/pawel112/linux-install-eDeklaracje/raw/master/e-deklaracje-installer_1.0.0_all.deb
    sudo dpkg -i e-deklaracje-installer_1.0.0_all.deb
