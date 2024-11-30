#!/bin/bash
#.......................................................................................
# Script to configure Arabic support on Linux, including keyboard, fonts, and interface
# Author: Muhammad Adam
# Telegram: https://t.me/meemadam
#.......................................................................................

# Check if the script is run as root

if [ "$(id -u)" -ne 0 ]; then
    echo " ❌ This script must be run as root. Use sudo to execute it."
    exit 1
fi

echo "Starting Arabic support configuration..."

#.......................................................................................

# Add necessary repositories for Arabic and BiDi/RTL support on Debian-based systems

if command -v apt &> /dev/null; then
    echo "Adding necessary repositories for Arabic and BiDi/RTL support..."
    sudo apt-add-repository "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main universe"
    sudo apt-add-repository "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates main universe"
    sudo apt-add-repository "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-security main universe"
    sudo apt-add-repository "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-backports main universe"
    sudo apt update
fi

#.......................................................................................

# Function to install packages

install_package() 
{
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install -y "$1"
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y "$1"
    elif command -v yum &> /dev/null; then
        sudo yum install -y "$1"
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm "$1"
    elif command -v zypper &> /dev/null; then
        sudo zypper install -y "$1"
    else
        echo " ❌ Unsupported package manager. Please install $1 manually."
        exit 1
    fi
}

#.......................................................................................

# Update the package list

echo " ► Updating package list..."
if command -v apt &> /dev/null; then
    sudo apt update && sudo apt upgrade -y
elif command -v dnf &> /dev/null; then
    sudo dnf upgrade -y
elif command -v yum &> /dev/null; then
    sudo yum update -y
elif command -v pacman &> /dev/null; then
    sudo pacman -Syu --noconfirm
elif command -v zypper &> /dev/null; then
    sudo zypper refresh && sudo zypper update -y
fi

#.......................................................................................

# Install necessary packages for Arabic support

echo " ► Installing necessary packages for Arabic support..."
install_package "ibus"
install_package "ibus-m17n"
install_package "fonts-noto"
install_package "fonts-noto-cjk"
install_package "fonts-noto-color-emoji"
install_package "fonts-noto-extra"
install_package "fonts-noto-mono"
install_package "fonts-noto-unhinted"
install_package "fonts-symbola"
install_package "ttf-mscorefonts-installer"
install_package "language-pack-ar"
install_package "gnome-tweaks"
install_package "ibus-gtk"
install_package "ibus-gtk3"
install_package "ibus-qt4"
install_package "ibus-table"
install_package "ibus-table-others"
install_package "ibus-table-chinese"
install_package "ibus-table-extraphrase"
install_package "ibus-table-quick"
install_package "ibus-table-translit"
install_package "ibus-table-wubi"
install_package "ibus-table-yong"
install_package "ibus-table-cangjie"
install_package "ibus-table-cantonese"
install_package "ibus-table-compose"
install_package "ibus-table-emoji"
install_package "ibus-table-ipa"
install_package "ibus-table-latex"
install_package "ibus-table-rustrad"
install_package "ibus-table-thai"
install_package "ibus-table-translit-ua"
install_package "ibus-table-viqr"
install_package "ibus-table-yawerty"
install_package "ibus-table-erase"
install_package "ibus-table-jyutping"
install_package "ibus-table-quick3"
install_package "ibus-table-quick5"
install_package "ibus-table-quick-classic"
install_package "ibus-table-stroke5"
install_package "ibus-table-thai-ket"
install_package "ibus-table-translit-ua"
install_package "ibus-table-viqr"
install_package "ibus-table-yawerty"
install_package "ibus-table-erase"
install_package "ibus-table-jyutping"
install_package "ibus-table-quick3"
install_package "ibus-table-quick5"
install_package "ibus-table-quick-classic"
install_package "ibus-table-stroke5"
install_package "ibus-table-thai-ket"

#.......................................................................................

# Download and install Noto Kufi Arabic font

echo " ► Installing Noto Kufi Arabic font..."
NOTO_KUFI_ARABIC_URL="https://github.com/notofonts/notofonts.github.io/raw/refs/heads/main/fonts/NotoKufiArabic/hinted/ttf/NotoKufiArabic-Regular.ttf"
NOTO_KUFI_ARABIC_DIR="/usr/share/fonts/truetype/noto-kufi-arabic"

sudo mkdir -p "$NOTO_KUFI_ARABIC_DIR"
sudo wget -O "$NOTO_KUFI_ARABIC_DIR/NotoKufiArabic-Regular.ttf" "$NOTO_KUFI_ARABIC_URL"
sudo fc-cache -f -v

#.......................................................................................

# Set Arabic keyboard layout and Alt+Shift toggle shortcut

echo "Configuring keyboard layout and shortcut..."
#setxkbmap -model pc104 -layout us,ar -variant ,digits -option grp:alt_shift_toggle,grp:ctrl_shift_toggle  
setxkbmap -layout "us,ar" -option "grp:alt_shift_toggle"

# Make this change permanent
echo "Making keyboard configuration persistent..."
KEYBOARD_CONFIG_FILE="/etc/default/keyboard"

sudo bash -c "cat > $KEYBOARD_CONFIG_FILE" <<EOF
XKBLAYOUT="us,ar"
XKBVARIANT=""
XKBOPTIONS="grp:alt_shift_toggle"
BACKSPACE="guess"
EOF

#.......................................................................................

# Reload keyboard configuration

echo "Reloading keyboard configuration..."
if command -v dpkg-reconfigure &> /dev/null; then
    sudo dpkg-reconfigure -phigh console-setup
elif command -v systemctl &> /dev/null; then
    sudo systemctl restart keyboard-setup
fi
sudo udevadm trigger --subsystem-match=input --action=change

#.......................................................................................

# Set "Noto Kufi Arabic" as the default font for various desktop environments

DESKTOP_ENV=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')

case "$DESKTOP_ENV" in
    gnome)
        gsettings set org.gnome.desktop.interface font-name 'Noto Kufi Arabic 11'
        gsettings set org.gnome.desktop.interface document-font-name 'Noto Kufi Arabic 11'
        gsettings set org.gnome.desktop.interface monospace-font-name 'Noto Kufi Arabic 11'
        gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Noto Kufi Arabic Bold 11'
        ;;
    kde)
        # KDE Plasma settings can be more complex and may require manual configuration
        echo "Please set Noto Kufi Arabic as the default font manually in KDE System Settings."
        ;;
    xfce)
        xfconf-query -c xsettings -p /Gtk/FontName -s 'Noto Kufi Arabic 11'
        xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s 'Noto Kufi Arabic 11'
        ;;
    mate)
        gsettings set org.mate.interface font-name 'Noto Kufi Arabic 11'
        gsettings set org.mate.interface document-font-name 'Noto Kufi Arabic 11'
        gsettings set org.mate.interface monospace-font-name 'Noto Kufi Arabic 11'
        gsettings set org.mate.Marco.general titlebar-font 'Noto Kufi Arabic Bold 11'
        ;;
    cinnamon)
        gsettings set org.cinnamon.desktop.interface font-name 'Noto Kufi Arabic 11'
        gsettings set org.cinnamon.desktop.interface document-font-name 'Noto Kufi Arabic 11'
        gsettings set org.cinnamon.desktop.interface monospace-font-name 'Noto Kufi Arabic 11'
        gsettings set org.cinnamon.desktop.wm.preferences titlebar-font 'Noto Kufi Arabic Bold 11'
        ;;
    lxde)
        # LXDE settings can be more complex and may require manual configuration
        echo "Please set Noto Kufi Arabic as the default font manually in LXDE Appearance Settings."
        ;;
    lxqt)
        # LXQt settings can be more complex and may require manual configuration
        echo "Please set Noto Kufi Arabic as the default font manually in LXQt Appearance Settings."
        ;;
    budgie)
        gsettings set org.gnome.desktop.interface font-name 'Noto Kufi Arabic 11'
        gsettings set org.gnome.desktop.interface document-font-name 'Noto Kufi Arabic 11'
        gsettings set org.gnome.desktop.interface monospace-font-name 'Noto Kufi Arabic 11'
        gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Noto Kufi Arabic Bold 11'
        ;;
    openbox|fluxbox)
        # Openbox and Fluxbox settings can be more complex and may require manual configuration
        echo "Please set Noto Kufi Arabic as the default font manually in Openbox/Fluxbox configuration files."
        ;;
    *)
        echo "Unsupported desktop environment. Please set Noto Kufi Arabic as the default font manually."
        ;;
esac

#.......................................................................................

# Apply Arabic locale for the interface

echo " 🌍 Applying Arabic locale settings... "
if command -v update-locale &> /dev/null; then
    sudo update-locale LANG=ar_SA.UTF-8 LANGUAGE=ar_SA
    sudo locale-gen ar_SA.UTF-8
    sudo dpkg-reconfigure locales
elif command -v localectl &> /dev/null; then
    sudo localectl set-locale LANG=ar_SA.UTF-8
    sudo localectl set-x11-keymap us,ar grp:alt_shift_toggle
fi

#.......................................................................................

# Clean up and finalize

echo "Cleaning up..."
if command -v apt &> /dev/null; then
    sudo apt autoremove -y
    sudo apt autoclean
elif command -v dnf &> /dev/null; then
    sudo dnf autoremove -y
elif command -v yum &> /dev/null; then
    sudo yum autoremove -y
elif command -v pacman &> /dev/null; then
    sudo pacman -Rns $(pacman -Qtdq) --noconfirm
elif command -v zypper &> /dev/null; then
    sudo zypper clean
fi

#.......................................................................................

#echo "Configuration completed! Please restart your system to apply all changes."
echo "✅ Arabic support configuration completed! Please restart your system."
