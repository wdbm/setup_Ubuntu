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
################################################################################

version="2025-05-23T0800Z"

#¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´><(((º>

reload_options(){
    # =======\                                                          /=======
    # =======> THIS IS THE PLACE WHERE YOU SET THE SCRIPT CONFIGURATION <=======
    # =======/                                                          \=======
    #
    # 0: no, don't set up
    # 1: yes, do set up
    AirVPN=1
    LaTeX=1
    ROOT=0
    Sage=0
    Mathics=0
    VirtualBox=0
    GPU=0 # install GPU utilities
    theme_Bash=1
    Indicator_SysMonitor=1
    Wine=1
    VeraCrypt=1
}

note(){
    # This function echos text given to a log file.
    timestamp="$(date -u +"%Y-%m-%dT%H%M%SZ")"
    text="${*}"
    echo ""${timestamp}" "${text}""
    log_file="log.txt"
    echo ""${timestamp}" "${text}"" >> "${log_file}"
    #echo "${text}" | festival --tts &
}

echo_pause(){
    # This function echos text given and pauses for a key press.
    text="${*}"
    echo "${text}" | festival --tts &
    read -s -n 1 -p "${text}"
    echo
}

actuality(){
    # This function checks for the existence of a program. It returns a truth
    # value and is intended for use in conditional branching code. Example:
    #
    #     if actuality root; then
    #         echo "ROOT exists."
    #     fi
    #     if !(actuality zappo); then
    #         echo "zappo does not exist."
    #     fi
    type "$1" &> /dev/null;
}

text_in_lower_case(){
    # This function converts text to lower case.
    text="${1}"
    echo "$(echo "${text}" | sed 's/\(.*\)/\L\1/')"
}

terminal_dimension(){
    # This function takes one argument, the required "type" of dimension
    # (size, height or width) of the terminal. The required dimension then is
    # returned. If no argument is specified, nothing is returned. The dimensions
    # are as follows:
    #
    # size:   the width and height of the terminal separated by a space
    #         (e.g., 24 80)
    # height: the height of the terminal (e.g., 24)
    # width:  the width of the terminal (e.g., 80)
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

print_character(){
    # This function takes two arguments, the first being the character to print
    # and the second being the number of times to print the character. This
    # function prints the specified character the specified number of times
    # without carriage returns.
    character="${1}"
    number_of_times_to_print_character="${2}"
    for (( current_print_number=0;
           current_print_number<=${number_of_times_to_print_character};
           current_print_number++ )); do
        echo -n "${character}"
    done
}

pp(){
    # This function prints one line on the terminal. It may be used for the
    # purpose of terminal output legibility. This function initially determines
    # the terminal width and then prints one line of _ characters.
    #
    # prerequisite_functions:
    #
    # print_character
    # terminal_dimension
    number_of_lines=1
    terminal_width="$(terminal_dimension "width")"
    number_of_characters_to_print=$(
        echo "${number_of_lines}*(${terminal_width})-1" | bc
    )
    print_character "_" "${number_of_characters_to_print}"
}

instate(){
    # This is a quick function for installation of some object. It attempts to
    # install the specified object (program, package archive etc.) on the local
    # computer system. First, the system is checked for the object. If the
    # object exists for the system, then the installation is aborted. If the
    # object does not exist for the system, then the installation is attempted.
    for current_program in "${@}"; do
        # If the program exists for the system, do not attempt to install it.
        echo "check for actuality of program "${current_program}""
        if actuality "${current_program}"; then
            echo "program actualised -- abort instatement"
        else
            echo "install "${current_program}""
            # Attempt to install the program.
            if [[ "$(text_in_lower_case "${current_program}")" == "edex-ui" ]]; then
                wget https://github.com/GitSquared/edex-ui/releases/download/v2.2.8/eDEX-UI-Linux-x86_64.AppImage
                chmod 755 eDEX-UI-Linux-x86_64.AppImage
                ./eDEX-UI-Linux-x86_64.AppImage #--no-sandbox
            elif [[ "$(text_in_lower_case "${current_program}")" == "gimp-plugin-registry" ]]; then
                sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
                sudo apt update
                time sudo apt -y install gimp-plugin-registry
            elif [[ "$(text_in_lower_case "${current_program}")" == "mathics" ]]; then
                time git clone https://github.com/poeschko/Mathics.git
                cd Mathics
                time sudo pip3 install pint
                time sudo python3 setup.py install
                time sudo python3 setup.py initialize
                cd ../
                sudo rm -rf Mathics
            elif [[ "$(text_in_lower_case "${current_program}")" == "signal" ]]; then
                wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
                cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
                echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | \
                    sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
                sudo apt update
                time sudo apt -y install signal-desktop
            elif [[ "$(text_in_lower_case "${current_program}")" == "simplescreenrecorder" ]]; then
                sudo add-apt-repository -y ppa:maarten-baert/simplescreenrecorder
                sudo apt update
                time sudo apt -y install \
                    libavcodec-extra     \
                    libavformat-extra    \
                    pavucontrol          \
                    simplescreenrecorder
            elif [[ "$(text_in_lower_case "${current_program}")" == "virtualbox" ]]; then
                wget https://download.virtualbox.org/virtualbox/7.0.22/virtualbox-7.0_7.0.22-165102~Ubuntu~noble_amd64.deb
                sudo su -c 'DEBIAN_FRONTEND=noninteractive apt -y install ./virtualbox-7.0_7.0.22-165102~Ubuntu~noble_amd64.deb'
                rm virtualbox-7.0_7.0.22-165102~Ubuntu~noble_amd64.deb
            else
                time sudo apt -y install "${current_program}"
            fi
            sudo apt -f install
        fi
    done
}

pp; note "setup_Ubuntu.sh version "${version}""

# prerequisites -------------------------------------------------------------- #

pp; note "set up prerequisites"

pp; note "set display not to dim and to blank after 15 minutes"
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.desktop.session idle-delay 900
pp; note "enable volume over-amplification"
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true

pp; note "apt update"
sudo apt -y update

pp; note "install bc (Basic Calculator)"
instate bc
pp; note "install build-essential"
instate build-essential
pp; note "install Festival"
instate festival
pp; note "install Geany"
instate geany
pp; note "install Git"
instate git
pp; note "install python3-launchpadlib"
nstate python3-launchpadlib
pp; note "install Sed (Stream Editor)"
instate sed
pp; note "install SoX (Sound eXchange)"
instate sox

# Python, pip and virtualenv
pp; note "install Python"
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt -y update
instate python3-dev
instate python3-tk
pp; note "install and set up pip"
instate python3-pip
sudo python3 -m pip config set global.break-system-packages true
pp; note "install virtualenv"
sudo pip3 install virtualenv
pp; note "install pypandoc"
sudo pip3 install pypandoc

# package management

# AppImageLauncher
#pp; note "install AppImageLauncher"
#sudo add-apt-repository -y ppa:appimagelauncher-team/stable
#sudo apt -y update
#instate appimagelauncher

# Flatpak
pp; note "install Flatpak"
instate flatpak gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo

# updates and fixes
pp; note "apt update, apt upgrade and apt fix"
time sudo apt -f install
time sudo apt -y update
time sudo apt -y upgrade
time sudo apt -f install

################################################################################
text="starting initial script interactions"
pp; note "${text}"
echo "${text}" | festival --tts &
################################################################################

pp; note "set up Ubuntu"
echo_pause "Press any key to start."
echo -e "\nPlease run this script as a non-root user and please ensure that \
the output of this script is not being redirected to a file as this is done \
by the script. In this script, there are initial interactions to advise on \
more manual steps, then the script advises when these steps are complete. \
Following this, various non-interactive installations are completed. Before \
continuing, please ensure that configuration options for the script are set \
appropriately in the function \"reload_options\"."

# security ------------------------------------------------------------------- #

# VeraCrypt
reload_options
if [ ${VeraCrypt} -eq 1 ]; then
pp; note "create veracrypt group"
sudo groupadd veracrypt
echo "add current user ("${USER}") to the group VeraCrypt"
sudo gpasswd -a "${USER}" veracrypt
pp; note "install VeraCrypt"
instate dbus-x11 libfuse2
mkdir veracrypt
cd veracrypt
wget https://launchpadlibrarian.net/289850375/veracrypt-1.19-setup.tar.bz2
tar -xvf veracrypt-1.19-setup.tar.bz2
sudo ./veracrypt-1.19-setup-console-x64
cd ..
rm -rf veracrypt
fi

# MAC address
pp; note "install macchanger"
instate macchanger

# interfaces ----------------------------------------------------------------- #

# Indicator-SysMonitor (a system tray system monitor notification indicator)
reload_options
if [ ${Indicator_SysMonitor} -eq 1 ]; then
pp; note "install and set up Indicator-SysMonitor"
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
echo -e "Set Indicator-SysMonitor to run on startup (the executable is \
indicator-sysmonitor) and set the output format as appropriate. The following \
is an example:"
echo
echo_pause "${text}"
fi

################################################################################
text="initial script interactions complete"
pp; note "${text}"
echo "${text}" | festival --tts &
################################################################################

# security ------------------------------------------------------------------- #

# private user area
pp; note "make user home area private"
sudo chmod 750 /home/"${USER}"

# Globus
pp; note "install Globus Toolkit"
instate globus-gsi-cert-utils-progs

# disable recently-used files lists
pp; note "disable GNOME Recent Files"
gsettings set org.gnome.desktop.privacy remember-recent-files false

# Fail2Ban
pp; note "install Fail2Ban"
instate fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Apache2
pp; note "stop Apache2"
sudo systemctl stop apache2

# unattended upgrades
pp; note "enable unattended upgrades"
instate unattended-upgrades
sudo dpkg-reconfigure -pmedium unattended-upgrades

# disable GNOME tracking
pp; note "disable GNOME Tracker" # see also Activity Log Manager
# GNOME 46
# https://discourse.gnome.org/
#     t/can-tracker-extract-be-disabled-in-gnome-46/20782
sudo rm /usr/share/tracker3-miners/extract-rules/*
# up to GNOME 46:
sudo systemctl --user mask             \
    tracker-extract-3.service          \
    tracker-miner-fs-3.service         \
    tracker-miner-rss-3.service        \
    tracker-writeback-3.service        \
    tracker-xdg-portal-3.service       \
    tracker-miner-fs-control-3.service
tracker3 reset -s -r
# to re-enable:
#sudo systemctl --user unmask           \
#    tracker-extract-3.service          \
#    tracker-miner-fs-3.service         \
#    tracker-miner-rss-3.service        \
#    tracker-writeback-3.service        \
#    tracker-xdg-portal-3.service       \
#    tracker-miner-fs-control-3.service

# GNOME error-reporting
pp; note "disable Apport"
sudo systemctl disable --now apport.service
sudo systemctl mask apport.service
# to re-enable:
#sudo systemctl unmask apport.service
#sudo systemctl enable apport.service

# interfaces ----------------------------------------------------------------- #

# terminal theme
pp; echo "set up terminal theme"
list_of_gsettings_schemas="$(gsettings list-relocatable-schemas | grep -i terminal)"
uuid_profile_default="$(gsettings get org.gnome.Terminal.ProfilesList default)" # returns UUID4 profile label
uuid_profile_default="${uuid_profile_default:1:-1}" # remove leading and trailing single quotes
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ scrollback-unlimited true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ foreground-color "#ffffff"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ background-color "#000000"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ use-transparent-background false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${uuid_profile_default}/ background-transparency-percent "10"

# Bash Agnoster theme with Powerline

reload_options
if [ ${theme_Bash} -eq 1 ]; then

pp; note "set up Bash Agnoster theme with Powerline"
pp; note "install Agnoster"

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

# definition of Agnoster configuration for .bashrc
IFS= read -d '' text << "EOF"
export THEME=${HOME}/.bash/themes/agnoster-bash/agnoster.bash
if [[ -f ${THEME} ]]; then
    export DEFAULT_USER="$(whoami)"
    source ${THEME}
fi
EOF
mkdir -p ${HOME}/.bash/themes/agnoster-bash
git clone https://github.com/speedenator/agnoster-bash.git ${HOME}/.bash/themes/agnoster-bash
if grep -Fxq "agnoster" ~/.bashrc; then
    echo "configuration found, not overwriting"
    echo "${text}"
else
    echo "${text}" >> ~/.bashrc
fi

fi

# fonts
pp; note "install fonts etc."
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
instate ttf-mscorefonts-installer

pp; note "install ARandR"
instate arandr
#pp; note "install eDEX-UI"
#instate edex-ui
pp; note "install Graphical Disk Map"
instate gdmap
pp; note "install genact"
sudo snap install genact
pp; note "install Hollywood"
instate hollywood
pp; note "install Ranger"
instate ranger
pp; note "install Screen"
instate screen
pp; note "install s-tui"
sudo pip3 install s-tui --ignore-installed psutil
pp; note "install Tilix"
instate tilix
pp; note "install TUIFI Manager"
sudo pip3 install tuifimanager
pp; note "install x11-apps"
instate x11-apps
pp; note "install xcalib"
instate xcalib
pp; note "install xtrlock"
instate xtrlock
pp; note "install xvkbd"
instate xvkbd

# tmux
pp; note "install tmux"
instate tmux
wget --content-disposition -O ~/.tmux.conf \
    https://raw.githubusercontent.com/wdbm/tmux_config/master/.tmux.conf

# desktop environments

pp; note "install GNOME Tweaks, shell extensions etc."
pp; instate gnome-tweaks
pp; instate gnome-shell-extensions
pp; instate chrome-gnome-shell
pp; instate gnome-shell-extension-manager
pp; instate unity-tweak-tool

# keyboard shortcuts

pp; note "set some keyboard shortcuts"

create_shortcut() {
    local shortcut_name="${1}"
    local shortcut_binding="${2}"
    local shortcut_command="${3}"
    local keybinding_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${shortcut_name}/"

    # Fetch current custom keybindings.
    current_keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

    # Initialize new_keybindings variable based on the current state.
    if [[ "${current_keybindings}" == "@as []" ]]; then
        # If the list is empty, initialise it with the new keybinding path.
        new_keybindings="['${keybinding_path}']"
    elif [[ "${current_keybindings}" != *"${keybinding_path}"* ]]; then
        # If the keybinding does not exist, add it to the list.
        new_keybindings=$(echo "${current_keybindings}" | sed "s|]$|, '${keybinding_path}']|")
    else
        # If the keybinding already exists, use the current list.
        new_keybindings="${current_keybindings}"
    fi

    # Update the custom keybindings list if modified.
    if [[ "${new_keybindings}" != "${current_keybindings}" ]]; then
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${new_keybindings}"
    fi

    # Set the properties for the new shortcut.
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"${keybinding_path}" name "${shortcut_name}"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"${keybinding_path}" binding "${shortcut_binding}"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"${keybinding_path}" command "${shortcut_command}"
}

# shortkey: xtrlock
create_shortcut \
    "xtrlock" \
    "<Control><Shift>l" \
    "xtrlock"

# shortkey: volume up
# pactl set-sink-volume @DEFAULT_SINK@ +5%
create_shortcut \
    "volume_up" \
    "<Control><Shift>Page_Up" \
    "pactl set-sink-volume @DEFAULT_SINK@ +5%"

# shortkey: volume down
# pactl set-sink-volume @DEFAULT_SINK@ -5%
create_shortcut \
    "volume_down" \
    "<Control><Shift>Page_Down" \
    "pactl set-sink-volume @DEFAULT_SINK@ -5%"

# shortkey: type datetime
# bash -c "sleep 0.1; xvkbd -text $(date "+%Y-%m-%dT%H%MZ" --utc) 2>/dev/null"
create_shortcut "type_datetime" \
    "<Control><Shift>d" \
    "bash -c 'sleep 0.1; xvkbd -text \"\$(date \"+%Y-%m-%dT%H%MZ\" --utc)\" 2>/dev/null'"

## shortkey: copy datetime
## bash -c "(date "+%Y-%m-%dT%H%MZ" --utc) | xclip -selection c"
#create_shortcut \
#    "copy_datetime" \
#    "<Control><Shift>t" \
#    "bash -c '(date \"+%Y-%m-%dT%H%MZ\" --utc) | xclip -selection c'"

# editors, coding, typesetting ----------------------------------------------- #

# Calibre
pp; note "install Calibre"
instate calibre
# Geany
pp; note "install enscript"
instate enscript
pp; note "install Geany"
instate geany
pp; note "install highlight"
instate highlight
# LaTeX
reload_options
if [ ${LaTeX} -eq 1 ]; then
    pp; note "install LaTeX"
    instate pdflatex
    instate texlive-full
    instate texlive-latex-extra
    instate texlive-fonts-recommended
    instate texlive-fonts-extra
    instate texlive-metapost
    instate texworks
    instate texinfo
    instate texi2html
fi
# Mini Text
pp; note "install Mini-Text"
sudo snap install mini-text
# Nice Editor
pp; note "install Nice Editor"
instate ne
# Pandoc
pp; note "install Pandoc"
instate pandoc
pp; note "install PDFtk"
instate pdftk
sudo snap install pdftk
pp; note "install pdftotext"
instate pdftotext
# Xournal
#pp; note "install Xournal"
#instate xournal
# Xournal++
pp; note "install Xournal++"
sudo snap install xournalpp

# networking and communications ---------------------------------------------- #

# upcoming: separate:
IFS= read -d '' text << "EOF"
# Allow users of the group airvpn to run AirVPN as root.
%airvpn ALL=(root) NOPASSWD:/usr/bin/eddie-ui
# Allow users of the group OpenVPN to run openvpn as root.
%openvpn ALL=(root) NOPASSWD:/usr/sbin/openvpn
# Allow users of the group veracrypt to run VeraCrypt as root.
%veracrypt ALL=(root) NOPASSWD:/usr/bin/veracrypt
EOF
if sudo grep -q "veracrypt" /etc/sudoers; then
    echo "The string 'veracrypt' was found in /etc/sudoers, so the file is" \
         " not to be modified."
else
    echo "The string 'veracrypt' was not found in /etc/sudoers, so the file" \
         " is to be modified to include the following text:"
    echo "${text}"
    echo "${text}" | sudo tee -a /etc/sudoers
fi

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
# apt-key deprecated:
#wget -qO - https://eddie.website/repository/keys/eddie_maintainer_gpg.key | sudo apt-key add -
#sudo add-apt-repository -y "deb http://eddie.website/repository/apt stable main"
echo "deb [signed-by=/usr/share/keyrings/eddie.website-keyring.asc] http://eddie.website/repository/apt stable main" | sudo tee /etc/apt/sources.list.d/eddie.website.list
sudo apt update
pp; note "install Eddie"
instate eddie-ui
instate eddie-cli
# Edit the file /usr/share/polkit-1/actions/org.airvpn.eddie.ui.elevated.policy,
# changing "auth_admin" to "yes".
sudo sed -i 's/auth_admin/yes/g' /usr/share/polkit-1/actions/org.airvpn.eddie.ui.elevated.policy
fi

# Signal
pp; note "install Signal"
instate signal

# torrenting
pp; note install "Transmission"
sudo snap install transmission
pp; note "install transmission-cli"
instate transmission-cli

pp; note "install net-tools"
instate net-tools

# SSH

pp; note "install OpenSSH Server"
instate openssh-server

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

# VNC
pp; note "install VPN infrastructure"
pp; instate xtightvncviewer #vncviewer
pp; instate tightvncserver #vnc4server
pp; instate vpnc

# system, monitoring, management and utilities ------------------------------- #

# GRUB
pp; note "set up GRUB, enabling terminal output on boot"
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="text"/' /etc/default/grub
sudo update-grub

# sudo timeout and root privileges for programs
pp; note "set up sudoer sudo environment reset timeout and sudoer permissions"
if sudo grep -q "timestamp_timeout" /etc/sudoers; then
    echo "The string 'timestamp_timeout' was found in /etc/sudoers, so the"\
         "file is not to be modified."
else
    echo "The string 'timestamp_timeout' was not found in /etc/sudoers, so"\
         "the file is be modified to include timestamp_timeout=120."
    sudo sed -i 's/Defaults\s\+env_reset/Defaults        env_reset, timestamp_timeout=120/' /etc/sudoers
fi

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
echo "${text}" \
    | sudo tee \
    /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla

pp; note "install Dynamic Kernel Module Support"
instate dkms
pp; note "install ubuntu-restricted-extras"
instate ubuntu-restricted-extras
pp; note "install pulseaudio-utils"
instate pulseaudio-utils
pp; note "install ACPI"
instate acpi
pp; note "install and set up TLP"
instate tlp
sudo systemctl enable tlp.service

pp; note "install atool"
instate atool
pp; note "install GdMap"
instate gdmap
pp; note "install GParted"
instate gparted
pp; note "install htop"
instate htop
pp; note "install iftop"
instate iftop
pp; note "install Pipe Viewer"
instate pv
pp; note "install NetHogs"
instate nethogs
pp; note "install realpath"
instate realpath
pp; note "install sockstat"
instate sockstat
pp; note "install TkCVS"
instate tkcvs
pp; note "install tree"
instate tree
pp; note "install unrar-free"
instate unrar-free

# GPU
if [ ${GPU} -eq 1 ]; then
    pp; note "install nvtop"
    git clone https://github.com/Syllo/nvtop.git
    mkdir -p nvtop/build && cd nvtop/build
    cmake ..
    make
    sudo make install
    cd ../..
    rm -rf nvtop
    cd
fi

# DOSBox
pp; note "install DOSBox"
instate dosbox

# VirtualBox
reload_options
if [ ${VirtualBox} -eq 1 ]; then
    pp; note "install VirtualBox"
    instate virtualbox
fi

# Wine
reload_options
if [ ${Wine} -eq 1 ]; then
    pp; note "install Wine"
    #instate wine-development
    instate wine
fi

# browsers etc. -------------------------------------------------------------- #

pp; note "install Chromium"
instate chromium-browser
pp; note "install cURL"
instate curl
pp; note "install ELinks"
instate elinks
pp; note "install Tor"
instate tor
instate torbrowser-launcher

# media ---------------------------------------------------------------------- #

# text

# RSS
pp; note "install Fluent Reader"
sudo snap install fluent-reader --candidate

# sound

pp; note "install Audacious"; instate audacious
pp; note "install Audacity"; instate audacity
pp; note "install cmus"; instate cmus
pp; note "install faad"; instate faad
pp; note "install FFmpreg"; instate ffmpeg
pp; note "install LAME"; instate lame
pp; note "install libsox-fmt-all"; instate libsox-fmt-all
pp; note "install libtheora-dev"; instate libtheora-dev
pp; note "install Pico-TTS"; instate libttspico0 libttspico-utils libttspico-data
pp; note "install lingot"; instate lingot
pp; note "install mediainfo"; instate mediainfo
pp; note "install MPlayer"; instate mplayer
pp; note "install PulseAudio Volume Control"; instate pavucontrol

# Audio Recorder
pp; echo "instate Audio Recorder"
wget https://raw.githubusercontent.com/wdbm/media_editing/master/setup/audio-recorder/audio-recorder_1.7-5%7Exenial_amd64.deb
sudo apt -y install ./audio-recorder_1.7-5~xenial_amd64.deb
rm audio-recorder_1.7-5~xenial_amd64.deb

# Rhythmbox
pp; note "remove Rhythmbox"
sudo apt -y remove rhythmbox

# image

pp; note "install ASCII Draw"
sudo snap install ascii-draw
pp; note "install Colour ASCII Art Library"
instate caca-utils
pp; note "install Python character encoding detector"
sudo pip3 install chardet
pp; note "install ExifTool"
instate exiftool
pp; note "install FIGlet"
instate figlet
pp; note "install Hugin"
flatpak install -y flathub net.sourceforge.Hugin
pp; note "install ImageMagick"
instate imagemagick
pp; note "install Inkspace"
instate inkscape
pp; note "install gallery-dl"
sudo pip3 install gallery-dl
pp; note "install GIMP with GIMP plugin registry"
pp; instate gimp
pp; instate gimp-plugin-registry
pp; note "install GNOME Screenshot"
instate gnome-screenshot
pp; note "install Graphviz"
instate graphviz
pp; note "install mediainfo"
instate mediainfo
pp; note "install WEBP"
instate webp

# Gcolor2
pp; note "install Gcolor2"
wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcolor2/gcolor2_0.4-2.1ubuntu1_amd64.deb
sudo apt -y install ./gcolor2_0.4-2.1ubuntu1_amd64.deb
rm gcolor2_0.4-2.1ubuntu1_amd64.deb

# Luminance HDR
pp; note "install Luminance HDR"
instate luminance-hdr

# video

pp; note "install Cheese"
instate cheese
pp; note "install fswebcam"
instate fswebcam
pp; note "install Guvcview"
instate guvcview
pp; note "install mpv"
instate mpv
pp; note "install OpenShot"
instate openshot
pp; note "install SimpleScreenRecorder"
instate simplescreenrecorder
pp; note "remove Totem"
sudo apt -y remove totem
pp; note "install Parabolic"
sudo snap install tube-converter

# VLC
pp; note "install and set up VLC and VLC plugins"
instate vlc
pp; instate vlc-plugin-fluidsynth
pp; instate vlc-plugin-libde265 # upcoming: fix
git clone https://github.com/wdbm/vlcrc.git
cd vlcrc
./setup.sh
cd ..
rm -rf vlcrc

# yt-dlp
pp; note "install yt-dlp"
sudo pip3 install yt-dlp

# science, mathematics and data analysis ------------------------------------- #

pp; note "install Orpie"
instate orpie
pp; note "install DB Browser for SQLite"
instate sqlitebrowser
pp; note "install Matplotlib, NumPy, pandas and seaborn"
sudo pip3 install matplotlib
sudo pip3 install numpy
sudo pip3 install pandas
sudo pip3 install seaborn

# Mathics
reload_options
if [ ${Mathics} -eq 1 ]; then
    pp; note "install Mathics"
    instate mathics
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

# Sage
reload_options
if [ ${Sage} -eq 1 ]; then
    pp; note "install Sage"
    instate build-essential m4 dpkg-dev sagemath
fi

# approaching completion ----------------------------------------------------- #

pp; note "apt autoremove"
sudo apt -y autoremove

pp; note "apt update and apt upgrade"
sudo apt -y update
sudo apt -y upgrade

################################################################################
text="setup complete"
pp; note "${text}"
echo "${text}" | festival --tts &
pp
################################################################################
