#!/bin/bash

################################################################################
#                                                                              #
# setup_Ubuntu                                                                 #
#                                                                              #
################################################################################
#                                                                              #
# LICENCE INFORMATION                                                          #
#                                                                              #
# This program sets up an Ubuntu personal installation.                        #
#                                                                              #
# copyright (C) 2011 Will Breaden Madden, wbm@protonmail.ch                    #
#                                                                              #
# This software is released under the terms of the GNU General Public License  #
# version 3 (GPLv3).                                                           #
#                                                                              #
# This program is free software: you can redistribute it and/or modify it      #
# under the terms of the GNU General Public License as published by the Free   #
# Software Foundation, either version 3 of the License, or (at your option)    #
# any later version.                                                           #
#                                                                              #
# This program is distributed in the hope that it will be useful, but WITHOUT  #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for     #
# more details.                                                                #
#                                                                              #
# For a copy of the GNU General Public License, see                            #
# <http://www.gnu.org/licenses>.                                               #
#                                                                              #
################################################################################

################################################################################
#                                                                              #
# SCRIPT DOCUMENTATION                                                         #
#                                                                              #
# This is a setup script for Ubuntu. It is likely to work well with the most   #
# recent version of Ubuntu (and should work to varying degrees with earlier    #
# versions). There are some Boolean option variables that should be set before #
# running this script in a special function near the top of this script.       #
#                                                                              #
# UPCOMING                                                                     #
# consideration of https://en.wikipedia.org/wiki/CheckInstall                  #
#                                                                              #
################################################################################

version="2023-09-04T0125Z"

#:START:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>
reload_options(){
IFS= read -d '' function_information << "EOF"
This function ensures that appropriate configuration option variables exist.

===========\                                                          /=========
===========> THIS IS THE PLACE WHERE YOU SET THE SCRIPT CONFIGURATION <=========
===========/                                                          \=========

0: no, don't set up
1: yes, do set up

EOF

AirVPN=1                          # VPN service
NordVPN=1                         # VPN service
Nextcloud=0                       # synchronisation of files, contacts, calendars etc.
Syncthing=0                       # synchronisation of files, contacts, calendars etc.
Dropbox=0                         # recommendation: no
LaTeX=1                           # set up LaTeX infrastructure
ROOT=0                            # install ROOT
Sage=0                            # install Sage
Mathics=0                         # install Mathics
VirtualBox=0                      # install VirtualBox VM software
GPU=0                             # install GPU utilities
PopcornTime=0                     # install Popcorn Time
music_applications=0              # install music applications
configure_browsers=0              # configure browsers
PPELX=0                           # PPELX Wi-Fi and CUPS setup
switch_libinput_to_synaptics=0    # switch libinput to Synaptics (likely recommended for Ubuntu 20.04)
remove_default_home_directories=0 # remove Documents, Music, Pictures, Public, Templates, Videos
make_public_user_account=0        # make a public user account
theme_Bash=1                      # theme Bash
Indicator_SysMonitor=1            # set up Indicator-SysMonitor
LXDE=0                            # install LXDE desktop environment
MATE=1                            # install MATE desktop environment
Unity=0                           # install Unity7 desktop environment
Wine=1                            # install Wine
VeraCrypt=1                       # install VeraCrypt
}

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>
note(){
IFS= read -d '' function_information << "EOF"
This function records things.
EOF
text="${*}"
echo "${text}"
log_file="log.txt"
echo "${text}" >> "${log_file}"
#echo "${text}" | festival --tts &
}

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>
echo_pause(){
IFS= read -d '' function_information << "EOF"
This function echos the given text argument (if any) and pauses for a key press.
EOF
text="${*}"
echo "${text}" | festival --tts &
read -s -n 1 -p "${text}"
echo
}

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>
actuality_program(){
IFS= read -d '' function_information << "EOF"
This function checks for the existence of a program. It returns a truth value
and is intended for use in conditional branching code.

example:

    if actuality_program root; then
        echo "ROOT exists."
    fi
    if !(actuality_program zappo); then
        echo "zappo does not exist."
    fi

example:

    if actuality_program root; then echo "exists"; fi

EOF
type "$1" &> /dev/null;
}

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>
text_in_lower_case(){
IFS= read -d '' function_information << "EOF"
This function converts text to lower case.
EOF
text="${1}"
echo "$(echo "${text}" | sed 's/\(.*\)/\L\1/')"
}

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>
terminal_dimension(){
IFS= read -d '' function_information << "EOF"
This function takes one argument, the required type of dimension of the
terminal. The required dimension then is returned. If no argument is specified,
nothing is returned. The possible dimensions are as follows:

size:   the width and height of the terminal separated by a space (e.g., 24 80)
height: the height of the terminal (e.g., 24)
width:  the width of the terminal (e.g., 80)
EOF
dimension="${1}"
if [ "${dimension}" = "size" ]; then
    stty size
else
    if [ "${dimension}" = "height" ]; then
        stty size | cut -d" " -f1
    else
        if [ "${dimension}" = "width" ]; then
            stty size | cut -d" " -f2
        fi
    fi
fi
}

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>
print_character(){
IFS= read -d '' function_information << "EOF"
This function takes two arguments, the first being the character to print and
the second being the number of times to print the character. This function
prints the specified character the specified number of times without carriage
returns.
EOF
character="${1}"
number_of_times_to_print_character="${2}"
for ((  current_print_number = 0;  current_print_number<=${number_of_times_to_print_character}; current_print_number++  ))
do
    echo -n "${character}"
done
}

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>
print_line(){
IFS= read -d '' function_information << "EOF"
This function prints one line on the terminal. It may be used for the purpose of
terminal output legibility. This function initially determines the terminal
width and then prints one line of _ characters.

prerequisite_functions:

print_character
terminal_dimension
EOF
number_of_lines=1
terminal_width="$(terminal_dimension "width")"
number_of_characters_to_print=$(echo "${number_of_lines}*(${terminal_width})-1" | bc)
print_character "_" "${number_of_characters_to_print}"
}

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>
pp(){
IFS= read -d '' function_information << "EOF"
This function is shorthand for function print_line.
EOF
print_line
}

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>
instate(){
IFS= read -d '' function_information << "EOF"
This is a quick function for installation. It attempts to install the specified
information (program, package archive etc.) on the local computer system. First,
the system is checked for the information. If the information exists for the
system, then the installation is aborted. If the information does not exist for
the system, then the installation is attempted. In use, this function can test
for existence of Apt and YUM.
EOF
for current_program in "${@}"; do
    # If the program exists for the system, do not attempt to install it.
    echo "check for actuality of program "${current_program}""
    if actuality_program "${current_program}"; then
        echo "program actualised -- abort instatement"
    else
        echo "install "${current_program}""
        # Attempt to install the program.
        #if [[ "$(text_in_lower_case "${current_program}")" == "acroread" ]]; then
        #    wget --content-disposition https://www.dropbox.com/s/e68vsjhoa2vfudy/AdbeRdr9.5.5-1_i386linux_enu.deb?dl=0
        #    sudo apt -y install gdebi
        #    sudo gdebi --non-interactive AdbeRdr9.5.5-1_i386linux_enu.deb
        #    sudo apt -y install libgtk2.0-0:i386 libnss3-1d:i386 libnspr4-0d:i386 lib32nss-mdns* libxml2:i386 libxslt1.1:i386 libstdc++6:i386
        #    rm AdbeRdr9.5.5-1_i386linux_enu.deb
        if [[ "$(text_in_lower_case "${current_program}")" == "bitcoin" ]]; then
            sudo add-apt-repository -y ppa:bitcoin/bitcoin
            sudo apt update
            time sudo apt -y install bitcoin-qt
        elif [[ "$(text_in_lower_case "${current_program}")" == "calibre" ]]; then
            #sudo add-apt-repository -y ppa:n-muench/calibre
            #sudo apt update
            time sudo apt -y install calibre
        elif [[ "$(text_in_lower_case "${current_program}")" == "cinnamon" ]]; then
            sudo add-apt-repository -y ppa:gwendal-lebihan-dev/cinnamon-stable
            sudo apt update
            time sudo apt -y install cinnamon
        elif [[ "$(text_in_lower_case "${current_program}")" == "cool-retro-term" ]]; then
            time sudo apt -y install              \
                build-essential                   \
                qmlscene                          \
                qt5-qmake                         \
                qt5-default                       \
                qtdeclarative5-dev                \
                qtdeclarative5-controls-plugin    \
                qtdeclarative5-qtquick2-plugin    \
                libqt5qml-graphicaleffects        \
                qtdeclarative5-dialogs-plugin     \
                qtdeclarative5-localstorage-plugin\
                qtdeclarative5-window-plugin
            git clone --recursive https://github.com/Swordfish90/cool-retro-term.git
            cd cool-retro-term/
            qmake && make
            sudo make install
            cd ..
            rm -rf cool-retro-term/
        elif [[ "$(text_in_lower_case "${current_program}")" == "dropbox" ]]; then
            time sudo apt -y install python-gtk2
            wget https://linux.dropbox.com/packages/ubuntu/dropbox_2.10.0_amd64.deb
            sudo apt -y install ./dropbox_2.10.0_amd64.deb
            rm dropbox_2.10.0_amd64.deb
        elif [[ "$(text_in_lower_case "${current_program}")" == "edex-ui" ]]; then
            wget https://github.com/GitSquared/edex-ui/releases/download/v2.2.8/eDEX-UI-Linux-x86_64.AppImage
            chmod 755 eDEX-UI-Linux-x86_64.AppImage
            ./eDEX-UI-Linux-x86_64.AppImage
        elif [[ "$(text_in_lower_case "${current_program}")" == "gimp-plugin-registry" ]]; then
            sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
            sudo apt update
            time sudo apt -y install gimp-plugin-registry
        elif [[ "$(text_in_lower_case "${current_program}")" == "google-chrome" ]]; then
            sudo apt -y install libappindicator1
            wget https://dl.google.com/linux/direct/google-chrome<-stable_current_amd64.deb
            time sudo su -c 'DEBIAN_FRONTEND=noninteractive apt -y install ./google-chrome-stable_current_amd64.deb'
            rm google-chrome-stable_current_amd64.deb
        #elif [[ "$(text_in_lower_case "${current_program}")" == "google-earth" ]]; then
        #    time sudo apt -y install libc6:i386 lsb-core
        #    time sudo apt -y install ./google-earth-stable_7.1.2.2041_amd64.deb
        #    rm google-earth-stable_7.1.2.2041_amd64.deb
        elif [[ "$(text_in_lower_case "${current_program}")" == "jitsi" ]]; then
            wget https://github.com/jitsi/jitsi-meet-electron/releases/download/v2022.1.1/jitsi-meet-x86_64.AppImage
            chmod 755 jitsi-meet-x86_64.AppImage
            ./jitsi-meet-x86_64.AppImage
            rm jitsi-meet-x86_64.AppImage
        elif [[ "$(text_in_lower_case "${current_program}")" == "mathics" ]]; then
            git clone https://github.com/poeschko/Mathics.git
            cd Mathics
            sudo pip install pint
            sudo python3 setup.py install
            sudo python3 setup.py initialize
            cd ../
            sudo rm -rf Mathics
        elif [[ "$(text_in_lower_case "${current_program}")" == "neo" ]]; then
            time sudo apt -y install build-essential libncurses-dev
            git clone https://github.com/st3w/neo.git
            cd neo
            ./autogen.sh
            ./configure
            make -j5
            sudo make install
            rm -rf neo
        elif [[ "$(text_in_lower_case "${current_program}")" == "nextcloud" ]]; then
            sudo add-apt-repository -y ppa:nextcloud-devs/client
            sudo apt update
            time sudo apt -y install nextcloud-client
        elif [[ "$(text_in_lower_case "${current_program}")" == "nordvpn" ]]; then
            wget https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb
            sudo apt -y install ./nordvpn-release_1.0.0_all.deb
            rm nordvpn-release_1.0.0_all.deb
            sudo apt update
            time sudo apt -y install nordvpn
        elif [[ "$(text_in_lower_case "${current_program}")" == "nuclear" ]]; then
            time wget https://github.com/nukeop/nuclear/releases/download/v0.6.3/nuclear-fca030.deb
            sudo apt -y install ./nuclear-fca030.deb
            rm nuclear-fca030.deb
        elif [[ "$(text_in_lower_case "${current_program}")" == "playonlinux" ]]; then
            wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
            sudo wget http://deb.playonlinux.com/playonlinux_precise.list -O /etc/apt/sources.list.d/playonlinux.list
            sudo apt update
            time sudo apt -y install playonlinux
        elif [[ "$(text_in_lower_case "${current_program}")" == "riot-web" ]]; then
            source /etc/os-release
            sudo sh -c "echo 'deb https://riot.im/packages/debian/ "${UBUNTU_CODENAME}" main' > /etc/apt/sources.list.d/matrix-riot-im.list"
            curl -L https://riot.im/packages/debian/repo-key.asc | sudo apt-key add -
            sudo apt update
            time sudo apt install riot-web
        elif [[ "$(text_in_lower_case "${current_program}")" == "sage" ]]; then
            #sudo add-apt-repository -y ppa:aims/sagemath
            #sudo apt update
            #time sudo apt -y install sagemath-upstream-binary
            time sudo apt -y install build-essential m4 dpkg-dev sagemath
        elif [[ "$(text_in_lower_case "${current_program}")" == "seamonkey" ]]; then
            echo -e "\ndeb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main" |sudo tee -a /etc/apt/sources.list > /dev/null
            sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C1289A29
            sudo apt update
            time sudo apt -y install seamonkey-mozilla-build
        elif [[ "$(text_in_lower_case "${current_program}")" == "signal" ]]; then
            #source /etc/os-release
            #curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
            #echo "deb [arch=amd64] https://updates.signal.org/desktop/apt "${UBUNTU_CODENAME}" main" | sudo tee -a /etc/apt/sources.list.d/signal-"${UBUNTU_CODENAME}".list
            #sudo apt update
            #sudo apt install signal-desktop
            # install Signal public software signing key
            wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
            cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
            # install Signal repository to your list of repositories
            echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
                sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
            # update package database and install signal
            sudo apt update
            time sudo apt -y install signal-desktop
        elif [[ "$(text_in_lower_case "${current_program}")" == "simplescreenrecorder" ]]; then
            sudo add-apt-repository -y ppa:maarten-baert/simplescreenrecorder
            sudo apt update
            time sudo apt -y install simplescreenrecorder
        #elif [[ "$(text_in_lower_case "${current_program}")" == "skype" ]]; then
        #    sudo apt -y install libpulse0:i386
        #    sudo add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
        #    sudo apt update
        #    sudo apt -y install skype
        #elif [[ "$(text_in_lower_case "${current_program}")" == "skype-call-recorder" ]]; then
        #    time sudo apt -y install\
        #        libqtgui4           \
        #        libid3-tools:i386   \
        #        libid3-3.8.3v5:i386 \
        #        libid3-tools        \
        #        libid3-3.8.3v5
        #    wget http://atdot.ch/scr/files/0.10/skype-call-recorder-ubuntu_0.10_amd64.deb
        #    sudo su -c 'DEBIAN_FRONTEND=noninteractive apt -y install ./skype-call-recorder-ubuntu_0.10_amd64.deb'
        #    rm skype-call-recorder-ubuntu_0.10_amd64.deb
        #    sudo apt -y -f install
        elif [[ "$(text_in_lower_case "${current_program}")" == "syncthing" ]]; then
            sudo apt -y install curl apt-transport-https
            curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
            echo "deb https://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list
            sudo apt update
            time sudo apt -y install syncthing
        elif [[ "$(text_in_lower_case "${current_program}")" == "teamviewer" ]]; then
            time wget http://www.teamviewer.com/download/teamviewer_linux.deb
            sudo apt -y install gdebi
            sudo gdebi -n teamviewer_linux.deb
            rm teamviewer_linux.deb
        elif [[ "$(text_in_lower_case "${current_program}")" == "vidyo" ]]; then
            sudo apt -y install libqt4-gui
            #wget http://information-technology.web.cern.ch/sites/information-technology.web.cern.ch/files/VidyoDesktopInstaller-ubuntu64-TAG_VD_3_0_0_141.deb
            #sudo apt -y install ./VidyoDesktopInstaller-ubuntu64-TAG_VD_3_0_0_141.deb
            #sudo su -c 'DEBIAN_FRONTEND=noninteractive apt -y install ./VidyoDesktopInstaller-ubuntu64-TAG_VD_3_0_0_141.deb'
            #rm VidyoDesktopInstaller-ubuntu64-TAG_VD_3_0_0_141.deb
            #wget http://information-technology.web.cern.ch/sites/information-technology.web.cern.ch/files/VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017.deb
            wget --content-disposition https://www.dropbox.com/s/4ag4hm5enma3qgv/VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017-no_libqt4-gui.deb?dl=0
            sudo su -c 'DEBIAN_FRONTEND=noninteractive apt -y install ./VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017-no_libqt4-gui.deb'
            rm VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017-no_libqt4-gui.deb
        elif [[ "$(text_in_lower_case "${current_program}")" == "virtualbox" ]]; then
            #wget http://dlc.sun.com.edgesuite.net/virtualbox/4.3.10/virtualbox-4.3_4.3.10-93012~Ubuntu~raring_amd64.deb
            #sudo su -c 'DEBIAN_FRONTEND=noninteractive apt -y install ./virtualbox-4.3_4.3.10-93012~Ubuntu~raring_amd64.deb'
            #rm virtualbox-4.3_4.3.10-93012~Ubuntu~raring_amd64.deb
            #wget https://download.virtualbox.org/virtualbox/6.0.8/virtualbox-6.0_6.0.8-130520~Ubuntu~xenial_amd64.deb
            #sudo su -c 'DEBIAN_FRONTEND=noninteractive apt -y install ./virtualbox-6.0_6.0.8-130520~Ubuntu~xenial_amd64.deb'
            #rm virtualbox-6.0_6.0.8-130520~Ubuntu~xenial_amd64.deb
            wget https://download.virtualbox.org/virtualbox/7.0.4/virtualbox-7.0_7.0.4-154605~Ubuntu~jammy_amd64.deb
            sudo su -c 'DEBIAN_FRONTEND=noninteractive apt -y install ./virtualbox-7.0_7.0.4-154605~Ubuntu~jammy_amd64.deb'
            rm virtualbox-7.0_7.0.4-154605~Ubuntu~jammy_amd64.deb
        elif [[ "$(text_in_lower_case "${current_program}")" == "youtube-dlg" ]]; then
            sudo add-apt-repository -y ppa:nilarimogard/webupd8
            sudo apt update
            time sudo apt -y install youtube-dlg
        else
            # If Apt is available, use it to install the program.
            if actuality_program apt; then
                time sudo apt -y install "${current_program}"
            # If YUM is available, use it to install the program.
            elif actuality_program yum; then
                time sudo yum -y install "${current_program}"
            # If neither Apt nor YUM is available, cease attempts at
            # installation.
            else
                echo "could not instate "${current_program}""
            fi
        fi
        sudo apt -f install
        #sudo apt -y autoremove
    fi
done
}

# install prerequisites
echo "install prerequisites"
sudo apt -y update
instate bc festival sox python3-launchpadlib

# Install updates and try to ensure that the installation environment is ok.
sudo apt -f install
sudo apt -y update
sudo apt -y upgrade
sudo apt -f install
sudo apt -y autoremove

clear
pp; note "set up Ubuntu"
echo_pause "Press any key to start."
pp; note "set up operating system"
note "time: "$(date "+%A %d %B %H:%M:%S %Z %Y (%Y-%m-%dT%H%M%S)")""
echo -e "\nHello! I am a script that tries their best to set up Ubuntu. Make sure that you are very simply running me in a Bash terminal using your normal user account (not root) and that you are not trying to redirect my output to a file or something (I already keep a log which should hopefully suffice). Also make sure that you are using a sturdy, reliable internet connection. So, if you are at CERN, make sure you are using a wired connection, not the Wi-Fi. There are three main parts to my running. First I do some initial script interactions with you where I advise you to click things and so on and basically do manual things that I don't yet know how to do automatically. I tell you when these initial script interactions are complete. Then I run lots of things automatically. Then I finish up by asking you to do a few last things manually again. Note that I require an internet connection at all times and that I prefer to be run all at once, but if something breaks I will do my best to pick things up again if you restart me without screwing anything up. Before continuing, just make sure that the options that you want are set correctly in my function called \"reload_options\". It you turn up the volume on your computer I will try to speak out occasionally telling you what I am doing. Don't worry -- I won't talk too much. Thanks for trusting me and I hope you like the things I will try to do. :)"

################################################################################
text="starting initial script interactions"
pp; note "${text}"
echo "${text}" | festival --tts &
################################################################################

# security
pp; echo "Disable Zeitgeist (using Activity Log Manager for example) and other logging as desired."
pp; instate macchanger
pp; instate unattended-upgrades
sudo dpkg-reconfigure -pmedium unattended-upgrades
pp; echo "Disable GNOME Tracker."
systemctl --user mask tracker-extract-3.service tracker-miner-fs-3.service tracker-miner-rss-3.service tracker-writeback-3.service tracker-xdg-portal-3.service tracker-miner-fs-control-3.service
tracker3 reset -s -r
# to re-enable:
#systemctl --user unmask tracker-extract-3.service tracker-miner-fs-3.service tracker-miner-rss-3.service tracker-writeback-3.service tracker-xdg-portal-3.service tracker-miner-fs-control-3.service
pp; echo "Disable Apport."
sudo systemctl disable --now apport.service
sudo systemctl mask apport.service
# to re-enable:
#sudo systemctl unmask apport.service
#sudo systemctl enable apport.service
# enable click-to-minimize
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
# to undo:
#gsettings reset org.gnome.shell.extensions.dash-to-dock click-action
# Geany
pp; instate geany
pp; note "configure Geany";
git clone https://github.com/wdbm/geany_config.git
cd geany_config
./setup.sh
cd ..
rm -rf geany_config
## Firefox
#sudo snap -y remove firefox
#sudo add-apt-repository -y ppa:mozillateam/ppa
#echo '
#Package: *
#Pin: release o=LP-PPA-mozillateam
#Pin-Priority: 1001
#' | sudo tee /etc/apt/preferences.d/mozilla-firefox
#sudo apt -y --allow-downgrades install firefox
# terminal style
pp; echo "set up terminal style"
list_of_gsettings_schemas="$(gsettings list-relocatable-schemas | grep -i terminal)"
uuid_profile_default="$(gsettings get org.gnome.Terminal.ProfilesList default)" # returns UUID4 profile label
uuid_profile_default="${uuid_profile_default:1:-1}" # remove leading and trailing single quotes
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ scrollback-unlimited true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ foreground-color "#ffffff"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ background-color "#000000"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ use-transparent-background true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ background-transparency-percent "10"
reload_options
if [ ${theme_Bash} -eq 1 ]; then
# install Powerline fonts
pp; note "install fonts patched for Powerline (note: https://superuser.com/a/1336614/705613)"
# install Powerline fonts for user
mkdir ~/.fonts
wget --content-disposition -N -O ~/.fonts/Monofur_for_Powerline.ttf                           https://raw.githubusercontent.com/powerline/fonts/master/Monofur/Monofur%20for%20Powerline.ttf
wget --content-disposition -N -O ~/.fonts/Monofur_Bold_for_Powerline.ttf                      https://raw.githubusercontent.com/powerline/fonts/master/Monofur/Monofur%20Bold%20for%20Powerline.ttf
wget --content-disposition -N -O ~/.fonts/Monofur_Italic_for_Powerline.ttf                    https://raw.githubusercontent.com/powerline/fonts/master/Monofur/Monofur%20Italic%20for%20Powerline.ttf
# install Powerline fonts for system
sudo wget --content-disposition -N -O /usr/local/share/fonts/Monofur_for_Powerline.ttf        https://raw.githubusercontent.com/powerline/fonts/master/Monofur/Monofur%20for%20Powerline.ttf
sudo wget --content-disposition -N -O /usr/local/share/fonts/Monofur_Bold_for_Powerline.ttf   https://raw.githubusercontent.com/powerline/fonts/master/Monofur/Monofur%20Bold%20for%20Powerline.ttf
sudo wget --content-disposition -N -O /usr/local/share/fonts/Monofur_Italic_for_Powerline.ttf https://raw.githubusercontent.com/powerline/fonts/master/Monofur/Monofur%20Italic%20for%20Powerline.ttf
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ font "monofur for Powerline bold 12"
fi
# sound, display, power
instate pulseaudio-utils
pp; echo_pause "Set sound settings as required (allow loud volume etc.), set power settings as necessary and set display settings as necessary, such as preventing dimming."
sudo apt -y install acpi tlp
systemctl enable tlp.service
# root privileges for programs
pp; note "set up sudoer permissions"
pp; echo -e "The file /etc/sudoers is about to be editable. When it is editable,
customise the sudo environment reset timeout which is specified in minutes. For
example, the line

Defaults        env_reset

could be changed to

Defaults        env_reset, timestamp_timeout=120

After editing, press Ctrl x to exit. Press \"y\" to save changes. Confirm the
file to which changes are to be saved, /etc/sudoers.tmp, by pressing Enter.
"
echo_pause "Press a key to continue."
sudo visudo
pp; echo -e "The file /etc/sudoers is about to be editable. When it is editable,
set up root privileges for special scripts by editing the file /etc/sudoers.tmp
(internally using the command sudo visudo). So, copy the following lines (or
merely some of them as appropriate) and then add them to the file
/etc/sudoers.tmp that shall be opened next.
"
IFS= read -d '' text << "EOF"
# Allow users of the group airvpn to run AirVPN as root.
%airvpn ALL=(root) NOPASSWD:/usr/bin/eddie-ui
# Allow users of the group OpenVPN to run openvpn as root.
%openvpn ALL=(root) NOPASSWD:/usr/sbin/openvpn
# Allow users of the group veracrypt to run VeraCrypt as root.
%veracrypt ALL=(root) NOPASSWD:/usr/bin/veracrypt
EOF
echo "${text}"
echo "
After editing, press Ctrl x to exit. Press \"y\" to save changes. Confirm the
file to which changes are to be saved, /etc/sudoers.tmp, by pressing Enter.
"
echo_pause "Press a key to continue."
sudo visudo
# OpenVPN
pp; note "create openvpn group"
sudo groupadd openvpn
sudo gpasswd -a "${USER}" openvpn
echo "add current user ("${USER}") to the group openvpn"
# AirVPN
reload_options
if [ ${AirVPN} -eq 1 ]; then
pp; note "create airvpn group"
sudo groupadd airvpn
echo "add current user ("${USER}") to the group airvpn"
sudo gpasswd -a "${USER}" airvpn
# upcoming: apt-key deprecated:
wget -qO - https://eddie.website/repository/keys/eddie_maintainer_gpg.key | sudo apt-key add -
sudo add-apt-repository -y "deb http://eddie.website/repository/apt stable main"
sudo apt -y install eddie-ui
# Edit the file /usr/share/polkit-1/actions/org.airvpn.eddie.ui.elevated.policy,
# changing "auth_admin" to "yes".
sudo sed -i 's/auth_admin/yes/g' /usr/share/polkit-1/actions/org.airvpn.eddie.ui.elevated.policy
fi
# VeraCrypt
reload_options
if [ ${VeraCrypt} -eq 1 ]; then
pp; note "create veracrypt group"
sudo groupadd veracrypt
echo "add current user ("${USER}") to the group VeraCrypt"
sudo gpasswd -a "${USER}" veracrypt
sudo apt -y install dbus-x11 libfuse2
mkdir veracrypt
cd veracrypt
wget https://launchpadlibrarian.net/289850375/veracrypt-1.19-setup.tar.bz2
tar -xvf veracrypt-1.19-setup.tar.bz2
sudo ./veracrypt-1.19-setup-gui-x64
cd ..
rm -rf veracrypt
fi
# coding
pp; instate build-essential checkinstall git
#pp; note "install GCC 4.9";
#sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
#sudo apt -y update
#instate gcc-4.9
pp; note "install fonts etc."
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
instate ubuntu-restricted-extras
# communications
# AppImageLauncher
pp; note "install AppImageLauncher, followed by some AppImages for installation with AppImageLauncher"
sudo add-apt-repository -y ppa:appimagelauncher-team/stable
sudo apt -y update
sudo apt -y install appimagelauncher
pp; instate jitsi
pp; instate edex-ui

################################################################################
text="initial script interactions complete"
pp; note "${text}"
echo "${text}" | festival --tts &
################################################################################

# Synchronisation software below could be moved to initial script interactions
# to enable synchronisation to happen while this script runs.

# Dropbox
reload_options
if [ ${Dropbox} -eq 1 ]; then
pp; instate dropbox
fi
# Nextcloud
reload_options
if [ ${Nextcloud} -eq 1 ]; then
pp; instate nextcloud
fi
# Syncthing
reload_options
if [ ${Syncthing} -eq 1 ]; then
pp; instate syncthing
fi
# science and mathematics
reload_options
if [ ${Sage} -eq 1 ]; then
    instate sage #sagemath
fi
# drivers
instate dkms
# security
# disable recently-used files lists
gsettings set org.gnome.desktop.privacy remember-recent-files false
pp; instate fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
# directories
reload_options
if [ ${remove_default_home_directories} -eq 1 ]; then
pp; note "remove default home directories"
    rm -rf ~/Documents
    rm -rf ~/Music
    rm -rf ~/Pictures
    rm -rf ~/Public
    rm -rf ~/Templates
    rm -rf ~/Videos
    rm ~/examples.desktop
fi
# web
pp; instate tor torbrowser-launcher
pp; instate chromium-browser
# grid
pp; instate globus-gsi-cert-utils-progs
# networking
pp; instate net-tools # ifconfig
pp; instate openssh-server
# SSH client
pp; note "add SSH configurations to keep connections alive"
IFS= read -d '' text << "EOF"
TCPKeepAlive yes
ExitOnForwardFailure yes
ServerAliveInterval 60
Protocol 2,1
EOF
if grep -Fxq "ServerAliveInterval" /etc/ssh/ssh_config; then
    echo "configuration found, not overwriting"
else
    echo "${text}" | sudo tee -a /etc/ssh/ssh_config
fi
# SSH server
IFS= read -d '' text << "EOF"
ClientAliveInterval 60
EOF
if grep -Fxq "ClientAliveInterval" /etc/ssh/sshd_config; then
    echo "configuration found, not overwriting"
else
    echo "${text}" | sudo tee -a /etc/ssh/sshd_config
fi
pp
pp; instate xtightvncviewer #vncviewer
pp; instate tightvncserver #vnc4server
pp; instate screen
pp; instate tmux
pp; instate tilix
# coding, utilities
pp; instate build-essential
pp; instate checkinstall
pp; instate cmus
pp; instate cython
pp; instate faad
pp; instate gnome-screenshot
pp; instate lame
pp; instate libsox-fmt-all
pp; instate libtheora-dev
pp; instate mediainfo
pp; instate ne
# FFmpeg
#git clone https://github.com/wdbm/FFmpeg_config.git
#cd FFmpeg_config
#./setup.sh
#cd ..
#rm -rf FFmpeg_config
pp; instate ffmpeg
pp; instate figlet
pp; instate git
pp; instate git-core
pp; instate htop
pp; instate iftop
pp; instate mlocate
pp; instate nano
pp; instate nethogs
pp; instate pandoc
pp; instate pv
pp; instate sockstat
pp; instate sox
pp; instate tree
# Python
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt -y update
pp; instate python-dev
pp; instate python-tk
pp; instate python3-dev
pp; instate python3-tk
#pp; instate python3.8
pp; instate python3.8-dev
pp; instate python3.8-tk
# pip
wget -N https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py
rm get-pip.py
sudo pip install pypandoc
# Flatpak
sudo apt -y install flatpak gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Xournal and Xournal++
#pp; instate xournal
sudo snap install xournalpp
# Mini Text
sudo snap install mini-text
# Calibre
pp; instate calibre
# RSS
pp; sudo snap install fluent-reader --candidate
# LaTeX
reload_options
if [ ${LaTeX} -eq 1 ]; then
pp; note "install LaTeX"
instate pdflatex # kept in script for backwards-compatibility (installed by following packages)
instate texlive-full
instate texlive-latex-extra
instate texlive-fonts-recommended
instate texlive-fonts-extra
instate texlive-metapost
instate texworks
instate texinfo
instate texi2html
fi
# video
pp; instate mpv
pp; instate vlc
pp; note "install vlc-plugin-fluidsynth (to set up VLC to play MIDI files) and ability to decode HEVC/H.265"
pp; instate vlc-plugin-fluidsynth
pp; instate vlc-plugin-libde265 # upcoming: fix
git clone https://github.com/wdbm/vlcrc.git
cd vlcrc
./setup.sh
cd ..
rm -rf vlcrc
pp; note "remove Totem"
sudo apt -y remove totem
pp; instate openshot # upcoming: fix: AppImage?
pp; instate ffmpeg
#pp; instate gnash
# LightSpark Flash player
pp; note "install yt-dlp"
sudo pip install yt-dlp
pp; note "install Parabolic"
sudo snap install tube-converter
pp; instate simplescreenrecorder # upcoming: "E: The repository 'https://ppa.launchpadcontent.net/maarten-baert/simplescreenrecorder/ubuntu jammy Release' does not have a Release file."
pp; instate cheese
pp; instate fswebcam
pp; instate guvcview
#pp; instate neo
pp; instate hollywood
# sound
# Audio Recorder
pp; echo "instate Audio Recorder"
wget https://raw.githubusercontent.com/wdbm/media_editing/master/setup/audio-recorder/audio-recorder_1.7-5%7Exenial_amd64.deb
sudo apt -y install ./audio-recorder_1.7-5~xenial_amd64.deb
rm audio-recorder_1.7-5~xenial_amd64.deb
# music
pp; instate audacious
reload_options
if [ ${music_applications} -eq 1 ]; then
pp; instate hydrogen
pp; instate nuclear
fi
# Popcorn Time
reload_options
if [ ${PopcornTime} -eq 1 ]; then
sudo apt -y install libgconf-2-4 libcanberra-gtk-module
wget --content-disposition -O ~/Popcorn_Time.tar.gz https://raw.githubusercontent.com/softrains/software/master/Popcorn_Time/Popcorn_Time.tar.gz
tar -xf ~/Popcorn_Time.tar.gz --directory="${HOME}"
rm Popcorn_Time.tar.gz
fi
# images
sudo snap install ascii-draw
pp; instate gimp
pp; instate gimp-plugin-registry
pp; instate imagemagick
pp; instate webp
pp; instate hugin # kept in script for backwards-compatibility
pp; note "install Hugin"; flatpak install -y flathub net.sourceforge.Hugin
pp; instate inkscape
#pp; note "install Instagram download program Instaloader"
#sudo pip install instaloader
pp; note "install gallery download program gallery-dl"
sudo pip install chardet
sudo pip install gallery-dl
# gcolor2
pp; instate gcolor2 # unavailable recently, kept in script for backwards-compatibility
wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcolor2/gcolor2_0.4-2.1ubuntu1_amd64.deb
sudo apt -y install ./gcolor2_0.4-2.1ubuntu1_amd64.deb
rm gcolor2_0.4-2.1ubuntu1_amd64.deb
# Luminance HDR
## Luminance HDR (16.04 LTS)
pp; instate qtpfsgui # kept in script for backwards-compatibility
## Luminance HDR (18.04 LTS)
pp; instate luminance-hdr
# sounds
pp; instate sox
pp; instate lame libsox-fmt-all
pp; instate faad
pp; instate mplayer
pp; instate audacity
pp; instate libttspico0 libttspico-utils libttspico-data
pp; instate lingot
# utilities
pp; instate arandr
pp; instate atool
pp; instate caca-utils
pp; instate curl
pp; instate dosbox
pp; instate dtrx # unavailable recently, kept in script for backwards-compatibility and for future-compatibility
pp; instate elinks
pp; instate exiftool
pp; instate gdmap
pp; instate gnome-tweak-tool # kept in script for backwards-compatibility
pp; instate gnome-tweaks
pp; instate gparted
pp; instate graphviz
pp; instate highlight
pp; instate libmtpserver-dev mtp-server # unavailable recently, kept in script for backwards-compatibility
pp; instate mediainfo
pp; instate orpie
pp; instate pdfmod
pp; instate pdftk
pp; sudo snap install pdftk
pp; instate pdftotext
pp; instate ranger
pp; instate realpath
pp; instate sqlitebrowser
pp; instate tkcvs
pp; instate transmission-cli
pp; instate unity-tweak-tool
pp; instate unrar-free
pp; instate vpnc
pp; instate x11-apps
pp; instate xcalib
pp; instate xtrlock
pp; instate xvkbd
# Python
pp
sudo pip install        \
    six                 \
    bochica             \
    che_guevara_otp     \
    hualang             \
    matplotlib          \
    media_editing       \
    numpy               \
    pandas              \
    pebcaw              \
    pyprel              \
    python-dateutil     \
    r245                \
    scalar              \
    seaborn             \
    shijian             \
    slugifygui          \
    tuifimanager        \
    python_spin         \
    technicolor         \
    tmux_control        \
    virtualenv          \
    william_blake_crypto
sudo pip install s-tui --ignore-installed psutil
reload_options
# communications
#pp; instate riot-web
pp; instate signal
reload_options
if [ ${NordVPN} -eq 1 ]; then
wget https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb
sudo apt -y install ./nordvpn-release_1.0.0_all.deb
rm nordvpn-release_1.0.0_all.deb
sudo apt -y update
sudo apt -y install nordvpn
fi
# science and mathematics
#sudo snap install mathpix-snipping-tool
reload_options
if [ ${Mathics} -eq 1 ]; then
    instate mathics
fi
# Nautilus
#pp; instate nautilus-wallpaper-changer # kept in script for backwards-compatibility
reload_options
# tmux (~/.tmux.conf)
pp; note "set up tmux"
wget --content-disposition -O ~/.tmux.conf https://raw.githubusercontent.com/wdbm/tmux_config/master/.tmux.conf
# PPELX Kelvin Building automated Wi-Fi login
reload_options
#if [ ${PPELX} -eq 1 ]; then
# add Glasgow PPE CUPS server (no longer active)
#pp; note "add the Glasgow PPE CUPS server"
#sudo touch /etc/cups/client.conf
#IFS= read -d '' text << "EOF"
#ServerName ppecups.physics.gla.ac.uk
#EOF
#echo "${text}" | sudo tee -a /etc/cups/client.conf
#sudo service cups restart
#pp; note "install Glasgow PPE WiFi -- suck_lord_kelvin_cock"
#sudo pip install slokc
#fi
# hibernation
pp; note "set up hibernation";
IFS= read -d '' text << "EOF"
[Re-enable hibernate by default in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes

[Re-enable hibernate by default in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate
ResultActive=yes
EOF
echo "${text}" | sudo tee /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
# restart mouse after suspend
pp; note "restart mouse after suspend";
IFS= read -d '' text << "EOF"
#!/bin/bash
[ "${1}" = "post" ] && exec modprobe psmouse
[ "${1}" = "pre" ] && exec rmmod psmouse
exit 0
EOF
echo "${text}" | sudo tee /lib/systemd/system-sleep/restartmouse
# GPU
if [ ${GPU} -eq 1 ]; then
git clone https://github.com/Syllo/nvtop.git
mkdir -p nvtop/build && cd nvtop/build
cmake ..
make
sudo make install
fi
# libinput, synaptics
reload_options
if [ ${switch_libinput_to_synaptics} -eq 1 ]; then
pp; note "Install Synaptics and uninstall libinput."
sudo apt -y install xserver-xorg-input-synaptics-hwe-18.04
sudo apt -y install xserver-xorg-input-evdev-hwe-18.04
sudo apt -y remove xserver-xorg-input-libinput
sudo apt -y remove xserver-xorg-input-libinput-hwe-18.04
fi
# Wine
reload_options
if [ ${Wine} -eq 1 ]; then
## Wine (16.04 LTS)
pp; instate wine
## Wine (18.04 LTS)
pp; instate wine-development
fi
# VirtualBox
reload_options
if [ ${VirtualBox} -eq 1 ]; then
pp; instate virtualbox
fi
# themes
# Numix icons
pp; note "install themes"
sudo apt-add-repository -y ppa:numix/ppa
instate numix-icon-theme numix-icon-theme-circle
# Arc icons
instate build-essential\
        autoconf       \
        automake       \
        pkg-config     \
instate libgtk-3.0 libgtk-3-dev
git clone https://github.com/horst3180/arc-icon-theme
cd arc-icon-theme
./autogen.sh --prefix=/usr
make -j$(nproc)
sudo make install
cd ..
rm -rf arc-icon-theme
# Arc themes
#old:
#git clone https://github.com/horst3180/arc-theme
#cd arc-theme
#./autogen.sh --prefix=/usr
#make -j$(nproc)
#sudo make install
#cd ..
#rm -rf arc-theme
instate arc-theme
# Compiz
#pp; instate compiz-plugins
# desktop environments
reload_options
if [ ${LXDE} -eq 1 ]; then
pp; note "Install the LXDE desktop environment. If wanted, switch to lightdm."
sudo DEBIAN_FRONTEND=noninteractive apt -y install lxde-common
fi
instate lxpanel
reload_options
if [ ${MATE} -eq 1 ]; then
pp; note "Install the MATE desktop environment. If wanted, switch to lightdm."
sudo DEBIAN_FRONTEND=noninteractive apt -y install ubuntu-mate-desktop
fi
reload_options
if [ ${Unity} -eq 1 ]; then
pp; note "Install the Unity7 desktop environment. If wanted, switch to lightdm."
sudo DEBIAN_FRONTEND=noninteractive apt -y install ubuntu-unity-desktop
fi
# sounds
pp; note "remove Rhythmbox"
sudo apt -y remove rhythmbox

################################################################################
pp
text="start final script interactions"
pp; note "${text}"
echo "${text}" | festival --tts &
################################################################################

# configure browsers
reload_options
if [ ${configure_browsers} -eq 1 ]; then
pp; note "configure browsers"
git clone https://github.com/wdbm/browsers_config.git
cd browsers_config
./setup.sh
cd ..
rm -rf browsers_config
fi
# mlocate
#pp; note "set up mlocate"
#echo_pause "Prevent /media from being pruned by mlocate."
#sudo nano /etc/updatedb.conf
# users
pp; note "Make user private."
sudo chmod 750 /home/"${USER}"
reload_options
if [ ${make_public_user_account} -eq 1 ]; then
pp; note "Create public user account, setting passcode to \"public\", full name to \"public\" and everything else to blank."
sudo adduser public
fi
pp; note "Install GNOME Shell extensions capabilities and WinTile."
sudo apt -y install              \
    gnome-tweaks                 \
    gnome-shell-extensions       \
    chrome-gnome-shell           \
    gnome-shell-extension-manager
firefox https://addons.mozilla.org/en-GB/firefox/addon/gnome-shell-integration https://extensions.gnome.org/extension/1723/wintile-windows-10-window-tiling-for-gnome # https://github.com/fmstrat/wintile

################################################################################
#                                                                              #
# themes                                                                       #
#                                                                              #
################################################################################

reload_options
if [ ${theme_Bash} -eq 1 ]; then
# Bash Agnoster theme with Powerline
pp; note "set up Bash Agnoster theme with Powerline"
pp; note "install Agnoster"
mkdir -p ${HOME}/.bash/themes/agnoster-bash
git clone https://github.com/speedenator/agnoster-bash.git ${HOME}/.bash/themes/agnoster-bash
pp; note "add Agnoster configuration to .bashrc"
IFS= read -d '' text << "EOF"
export THEME=${HOME}/.bash/themes/agnoster-bash/agnoster.bash
if [[ -f ${THEME} ]]; then
    export DEFAULT_USER="$(whoami)"
    source ${THEME}
fi
EOF
if grep -Fxq "agnoster" ~/.bashrc; then
    echo "configuration found, not overwriting"
    echo "${text}"
else
    echo "${text}" >> ~/.bashrc
fi
echo_pause "In the terminal, select a profile, then select a font patched for Powerline (e.g. Monofur_for_Powerline.ttf)."
fi
# UCOM
pp; note "install UCOM"
wget https://raw.githubusercontent.com/wdbm/ucomsys/master/setup.sh
chmod 755 setup.sh
./setup.sh
rm setup.sh

################################################################################
#                                                                              #
# keyboard shortcuts                                                           #
#                                                                              #
################################################################################

pp; note "Set some keyboard shortcuts."

# shortkey: type datetime
# The text to enter into the command field of the keyboard shortcut entry dialog is as follows:
# bash -c "sleep 0.1; xvkbd -text $(date "+%Y-%m-%dT%H%MZ" --utc) 2>/dev/null"
echo
pp; note "Ctrl+Shift+d"
IFS= read -d '' text << "EOF"
bash -c "sleep 0.1; xvkbd -text $(date "+%Y-%m-%dT%H%MZ" --utc) 2>/dev/null"
EOF
echo_pause "${text}"

# shortkey: copy datetime
# The text to enter into the command file of the keyboard shortcut entry dialog is as follows:
# bash -c "(date "+%Y-%m-%dT%H%MZ" --utc) | xclip -selection c"
echo
pp; note "Ctrl+Shift+t"
IFS= read -d '' text << "EOF"
bash -c "(date "+%Y-%m-%dT%H%MZ" --utc) | xclip -selection c"
EOF
echo_pause "${text}"

# shortkey: xtrlock
pp; note "Ctrl+Shift+l"
echo_pause "xtrlock"

# shortkey: volume up
# The text to enter into the command field of the keyboard shortcut entry dialog is as follows:
# pactl set-sink-volume @DEFAULT_SINK@ +5%
echo
pp; note "volume up key"
IFS= read -d '' text << "EOF"
pactl set-sink-volume @DEFAULT_SINK@ +5%
EOF
echo_pause "${text}"

# shortkey: volume up
# The text to enter into the command field of the keyboard shortcut entry dialog is as follows:
# pactl set-sink-volume @DEFAULT_SINK@ +5%
echo
pp; note "Ctrl+Shift+PgUp"
IFS= read -d '' text << "EOF"
pactl set-sink-volume @DEFAULT_SINK@ +5%
EOF
echo_pause "${text}"

# shortkey: volume down
# The text to enter into the command field of the keyboard shortcut entry dialog is as follows:
# pactl set-sink-volume @DEFAULT_SINK@ -5%
pp; note "volume down key"
IFS= read -d '' text << "EOF"
pactl set-sink-volume @DEFAULT_SINK@ -5%
EOF
echo_pause "${text}"

# shortkey: volume down
# The text to enter into the command field of the keyboard shortcut entry dialog is as follows:
# pactl set-sink-volume @DEFAULT_SINK@ +5%
echo
pp; note "Ctrl+Shift+PgDn"
IFS= read -d '' text << "EOF"
pactl set-sink-volume @DEFAULT_SINK@ -5%
EOF
echo_pause "${text}"

# for future consideration:
# python -c "import uuid; print(uuid.uuid4())"
# bash -c "TEXT="$(python -c "import uuid; print(uuid.uuid4())")"; xvkbd -text "${TEXT}" 2>/dev/null"

# Unity7
#/usr/share/ucom/CERN-alias/set_Ubuntu_shortkey.py                                      \
#    --command="bash -c \"sleep 0.1; xvkbd -text \$(date \"+%Y-%m-%dT%H%MZ\" --utc) 2>/dev/null\"" \
#    --name="type_time_UTC"                                                             \
#    --keys="<Control><Shift>d"
## xcalib -i -a
#/usr/share/ucom/CERN-alias/set_Ubuntu_shortkey.py \
#    --command="xcalib -i -a"                      \
#    --name="negative"                             \
#    --keys="<Control><Shift>n"
## xtrlock
#/usr/share/ucom/CERN-alias/set_Ubuntu_shortkey.py \
#    --command="xtrlock"                           \
#    --name="xtrlock"                              \
#    --keys="<Control><Shift>l"
## terminal_fullscreen
#/usr/share/ucom/CERN-alias/set_Ubuntu_shortkey.py     \
#    --command="gnome-terminal --window --full-screen" \
#    --name="terminal_fullscreen"                      \
#    --keys="<Control><Shift>x"

# default open applications
pp; note "set default applications"
echo_pause "Set default applications as necessary. In settings, under \"System\", select \"Details\" and then select \"Default Applications\". Select applications such as Tilix as the terminal."
# Indicator-SysMonitor (a system tray system monitor notification indicator)
reload_options
if [ ${Indicator_SysMonitor} -eq 1 ]; then
pp; note "Indicator-SysMonitor"
instate python3-psutil gir1.2-appindicator3-0.1
git clone https://github.com/wdbm/indicator-sysmonitor.git
cd indicator-sysmonitor
sudo make install
cd ..
rm -rf indicator-sysmonitor
nohup indicator-sysmonitor &
IFS= read -d '' text << "EOF"
|{net}    |{publiccountryiso}|cpu:{cpu}/{cputemp}|m/fs:{mem}/{fs///}|
EOF
echo "Set Indicator-SysMonitor to run on startup (the executable is indicator-sysmonitor) and set the output format as appropriate. The following is an example:"
echo
echo_pause "${text}"
fi
# ROOT
reload_options
if [ ${ROOT} -eq 1 ]; then
pp; note "install ROOT"
wget https://raw.githubusercontent.com/wdbm/soil/master/setup.sh
chmod 755 setup.sh
./setup.sh
rm setup.sh
fi
pp; note "set up GRUB"
pp; echo -e "Using the following instructions, enable terminal output on boot, after which there will be an update to GRUB."
echo_pause "Do this by executing (in another terminal) 'sudo nano /etc/default/grub' and then changing the line 'GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"' to include \"text\" and remove  \"quiet\" and \"splash\"."
sudo update-grub
echo_pause "Using a desktop environment tweak tool or similar, set the theme to Arc-dark and the icons to Arc, just 'cause they're cool."

################################################################################
text="final script interactions complete"
pp; note "${text}"
################################################################################

# Autoremove unused packages.
sudo apt -y autoremove
## mlocate
#echo_pause "A db map of non-volatile storage (hard drives) is to take place now for use by mlocate. Remove external drives as necessary."
#pp; note "create db map"
#sudo updatedb

################################################################################
note "time: "$(date "+%A %d %B %H:%M:%S %Z %Y (%Y-%m-%dT%H%M%S)")""
text="setup complete"
pp; note "${text}"
echo "${text}" | festival --tts &
pp
################################################################################

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::END:
