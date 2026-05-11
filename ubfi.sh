#!/bin/bash

# ubfi - Ubuntu Fast Install
# Inspired by archfi (MatMoul) - https://github.com/MatMoul/archfi
# For Ubuntu via debootstrap

apptitle="Ubuntu Fast Install (ubfi)"
MOUNTPOINT="/mnt"
LANG_SEL="en"
# --------------------------------------------------------
# Sprachauswahl / Language Selection
# --------------------------------------------------------

select_language() {
    local sel
    sel=$(dialog --title "Language / Sprache"         --menu "" 0 0 0         "de" "Deutsch"         "en" "English"         3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && sel="en"
    LANG_SEL="${sel:-en}"

    # TTY-Tastaturlayout direkt setzen
    local keymap="us"
    [ "$LANG_SEL" = "de" ] && keymap="de"
    loadkeys "$keymap" 2>/dev/null || loadkeys -C /dev/console "$keymap" 2>/dev/null || true
}

set_language() {
    if [ "$LANG_SEL" = "de" ]; then
        T_MAINMENU="Hauptmenü"
        T_LANGUAGE="Sprache"
        T_LANGUAGE_DESC="Sprache wählen"
        T_KEYMAP="Tastaturlayout"
        T_KEYMAP_DESC="(nur TTY, nicht grafisches Terminal)"
        T_DISK="Disk"
        T_DISK_DESC="Partitionieren, Formatieren, Einhängen"
        T_FORMAT="Formatieren"
        T_SUBVOLS="Subvolumes"
        T_SUBVOLS_DESC="(nur bei btrfs)"
        T_MOUNT="Einhängen"
        T_DEBOOTSTRAP="Debootstrap"
        T_DEBOOTSTRAP_DESC="Ubuntu installieren"
        T_FSTAB="fstab"
        T_FSTAB_DESC="/mnt/etc/fstab erstellen"
        T_CONFIG="Konfigurieren"
        T_CONFIG_DESC="chroot Konfiguration"
        T_REBOOT="Reboot"
        T_REMOUNT="Remount"
        T_REMOUNT_DESC="Partitionen wiedereinhängen (Fortsetzung)"
        T_BACK="Zurück"
        T_QUIT="Beenden"
        T_CONTINUE="Fortfahren?"
        T_PRESSKEY="Drücke eine Taste um fortzufahren..."
        T_WARNING="ACHTUNG"
        T_KEYMAP_TITLE="Tastaturlayout wählen"
        T_KEYMAP_SET="Layout '%s' gesetzt."
        T_KEYMAP_SET_CONSOLE="Layout '%s' gesetzt (via /dev/console)."
        T_KEYMAP_FAIL="Hinweis: Layout konnte nicht gesetzt werden - läuft das Skript in einem grafischen Terminal?\nFür loadkeys bitte in einem TTY (Strg+Alt+F2) ausführen."
        T_PART_TITLE="Partitionieren"
        T_AUTO_GPT="Auto (GPT/EFI)"
        T_AUTO_GPT_DESC="parted - EFI + Root + optional Home"
        T_AUTO_BIOS="Auto (MBR/BIOS)"
        T_AUTO_BIOS_DESC="parted - Root + optional Home (kein EFI)"
        T_MANUAL_CFDISK="Manuell (cfdisk)"
        T_MANUAL_FDISK="Manuell (fdisk)"
        T_MANUAL_DESC="Freie Partitionierung"
        T_HOME_SEPARATE="Separaten Home-Disk verwenden?"
        T_HOME_SEPARATE2="Separaten Home verwenden?"
        T_EFI_SIZE="EFI Partitionsgröße (z.B. 512MiB):"
        T_EFI_SIZE_TITLE="EFI Größe"
        T_DATA_LOST="Alle Daten auf %s werden gelöscht!

Fortfahren?"
        T_FORMAT_TITLE="Formatieren"
        T_FORMAT_CONFIRM="Folgende Partitionen werden formatiert:"
        T_SUBVOL_TITLE="BTRFS Subvolumes"
        T_SUBVOL_NOBTRFS="Root ist nicht BTRFS, keine Subvolumes nötig."
        T_SUBVOL_STD="Standard"
        T_SUBVOL_STD_DESC="@ und @snapshots (Root) + @home (Home falls btrfs)"
        T_SUBVOL_ONLY="Nur @"
        T_SUBVOL_ONLY_DESC="Nur @ als Root-Subvolume"
        T_SUBVOL_SKIP="Überspringen"
        T_SUBVOL_SKIP_DESC="Keine Subvolumes erstellen"
        T_UBUNTU_VERSION="Ubuntu Version"
        T_MIRROR_TITLE="Mirror wählen"
        T_MIRROR_CUSTOM="Eigene"
        T_MIRROR_CUSTOM_DESC="URL manuell eingeben"
        T_MIRROR_INPUT="Mirror URL eingeben:"
        T_DEBOOTSTRAP_CONFIRM="Installiere Ubuntu %s nach /mnt
Mirror: %s

Fortfahren?"
        T_DEBOOTSTRAP_OK="Ubuntu %s erfolgreich installiert!"
        T_DEBOOTSTRAP_FAIL="FEHLER: Debootstrap fehlgeschlagen!
Prüfe deine Internetverbindung und den Mirror."
        T_FSTAB_TITLE="fstab"
        T_FSTAB_CONFIRM="fstab wird erstellt mit:"
        T_CONFIG_TITLE="Konfiguration"
        T_HOSTNAME="Hostname"
        T_HOSTNAME_DESC="/etc/hostname"
        T_LOCALE="Locale"
        T_LOCALE_DESC="/etc/locale.conf, /etc/locale.gen"
        T_TIMEZONE="Zeitzone"
        T_TIMEZONE_DESC="/etc/localtime"
        T_APTSOURCES="apt-sources"
        T_APTSOURCES_DESC="/etc/apt/sources.list"
        T_PACKAGES="Pakete"
        T_PACKAGES_DESC="apt install ..."
        T_ROOTPW="Root-Passwort"
        T_USER="Benutzer"
        T_USER_DESC="adduser ..."
        T_BOOTLOADER="Bootloader"
        T_BOOTLOADER_DESC="systemd-boot / grub"
        T_NM="NetworkManager"
        T_NM_DESC="systemctl enable"
        T_SHELL="Shell"
        T_SHELL_DESC="Manuelle Chroot-Shell"
        T_HOSTNAME_INPUT="Rechnername:"
        T_HOSTNAME_SET="Hostname '%s' gesetzt!"
        T_LOCALE_TITLE="Locale"
        T_TIMEZONE_REGION="Zeitzone - Region"
        T_TIMEZONE_CITY="Zeitzone - Stadt"
        T_TIMEZONE_SET="Zeitzone '%s' gesetzt!"
        T_PKG_BASE="Basis"
        T_PKG_BASE_DESC="linux-generic btrfs-progs efibootmgr sudo"
        T_PKG_DESKTOP="Desktop"
        T_PKG_DESKTOP_DESC="Desktop-Umgebung wählen"
        T_PKG_PROGRAMMES="Programme"
        T_SOFTWARE_DESC="Desktop, Programme, Extras"
        T_PKG_PROGRAMMES_DESC="Firefox, Thunderbird, Chrome"
        T_PKG_EXTRAS="Extras"
        T_PKG_EXTRAS_DESC="Weitere Pakete"
        T_PKG_BOOTSCREEN="Bootscreen"
        T_PKG_BOOTSCREEN_DESC="Plymouth Bootscreen installieren"
        T_PKG_I386="32-Bit Support"
        T_PKG_I386_DESC="i386 Architektur aktivieren"
        T_DESKTOP_TITLE="Desktop"
        T_KDE_BLOAT_TITLE="KDE Bloat"
        T_KDE_BLOAT_MSG="Unnötige KDE Pakete entfernen?"
        T_GNOME_BLOAT_TITLE="GNOME Bloat"
        T_GNOME_BLOAT_MSG="Unnötige GNOME Pakete entfernen?"
        T_BOOTLOADER_TITLE="Bootloader"
        T_SDB_CONFIRM="Installiere systemd-boot
Root UUID: %s

Fortfahren?"
        T_GRUB_EFI_CONFIRM="Installiere GRUB EFI

Fortfahren?"
        T_REBOOT_CONFIRM="System jetzt neu starten?

Partitionen werden ausgehängt."
        T_EOL_MSG="EOL-Release erkannt!
Mirror wird auf old-releases.ubuntu.com umgeleitet."
        T_EOL_TITLE="EOL Release"
        T_NO_KERNEL="WARNUNG: Kein Kernel gefunden!"
        T_NM_OK="NetworkManager aktiviert."
        T_NET_TITLE="Netzwerk"
        T_NET_LAN="LAN (automatisch)"
        T_NET_LAN_DESC="DHCP auf allen Ethernet-Interfaces"
        T_NET_WIFI="WLAN"
        T_NET_WIFI_DESC="SSID und Passwort eingeben"
        T_NET_SKIP="Überspringen"
        T_NET_SKIP_DESC="Ohne Netzwerk fortfahren"
        T_NET_SSID="WLAN Name (SSID):"
        T_NET_PW="WLAN Passwort:"
        T_NET_CONNECTING="Verbinde mit '%s'..."
        T_NET_OK="Verbunden!"
        T_NET_FAIL="Verbindung fehlgeschlagen! Nochmal versuchen?"
        T_NET_LAN_OK="LAN aktiv: %s"
        T_NET_LAN_FAIL="Kein LAN gefunden oder DHCP fehlgeschlagen."
        T_NET_CHECK="Prüfe Netzwerk..."
        T_EXTREPO_CONFIRM="Folgende Pakete werden aus externen Repos installiert:

%s

Externe Repos + Signing Keys werden hinzugefügt.
Fortfahren?"
        T_USER_INPUT="Benutzername:"
        T_DISK_SELECT="EFI + Root Disk wählen"
        T_DISK_SELECT_HOME="Home Disk wählen"
        T_DISK_SELECT_ROOT="Root Disk wählen"
        T_DISK_SELECT_GRUB="Disk für GRUB-Installation wählen"
        T_DISK_SELECT_CFDISK="Disk für cfdisk wählen"
        T_DISK_SELECT_FDISK="Disk für fdisk wählen"
        T_PART_EFI="EFI Partition wählen"
        T_PART_ROOT="Root Partition wählen"
        T_PART_HOME="Home Partition wählen"
        T_FS_ROOT="Root Filesystem"
        T_FS_HOME="Home Filesystem"
    else
        T_MAINMENU="Main Menu"
        T_LANGUAGE="Language"
        T_LANGUAGE_DESC="Select language"
        T_KEYMAP="Keyboard Layout"
        T_KEYMAP_DESC="(TTY only, not graphical terminal)"
        T_DISK="Disk"
        T_DISK_DESC="Partition, Format, Mount"
        T_FORMAT="Format"
        T_SUBVOLS="Subvolumes"
        T_SUBVOLS_DESC="(btrfs only)"
        T_MOUNT="Mount"
        T_DEBOOTSTRAP="Debootstrap"
        T_DEBOOTSTRAP_DESC="Install Ubuntu"
        T_FSTAB="fstab"
        T_FSTAB_DESC="Create /mnt/etc/fstab"
        T_CONFIG="Configure"
        T_CONFIG_DESC="chroot configuration"
        T_REBOOT="Reboot"
        T_REMOUNT="Remount"
        T_REMOUNT_DESC="Remount partitions (continue installation)"
        T_BACK="Back"
        T_QUIT="Quit"
        T_CONTINUE="Continue?"
        T_PRESSKEY="Press any key to continue..."
        T_WARNING="WARNING"
        T_KEYMAP_TITLE="Select Keyboard Layout"
        T_KEYMAP_SET="Layout '%s' set."
        T_KEYMAP_SET_CONSOLE="Layout '%s' set (via /dev/console)."
        T_KEYMAP_FAIL="Note: Layout could not be set - is the script running in a graphical terminal?\nFor loadkeys please run in a TTY (Ctrl+Alt+F2)."
        T_PART_TITLE="Partition"
        T_AUTO_GPT="Auto (GPT/EFI)"
        T_AUTO_GPT_DESC="parted - EFI + Root + optional Home"
        T_AUTO_BIOS="Auto (MBR/BIOS)"
        T_AUTO_BIOS_DESC="parted - Root + optional Home (no EFI)"
        T_MANUAL_CFDISK="Manual (cfdisk)"
        T_MANUAL_FDISK="Manual (fdisk)"
        T_MANUAL_DESC="Free partitioning"
        T_HOME_SEPARATE="Use separate Home disk?"
        T_HOME_SEPARATE2="Use separate Home partition?"
        T_EFI_SIZE="EFI partition size (e.g. 512MiB):"
        T_EFI_SIZE_TITLE="EFI Size"
        T_DATA_LOST="All data on %s will be deleted!

Continue?"
        T_FORMAT_TITLE="Format"
        T_FORMAT_CONFIRM="The following partitions will be formatted:"
        T_SUBVOL_TITLE="BTRFS Subvolumes"
        T_SUBVOL_NOBTRFS="Root is not BTRFS, no subvolumes needed."
        T_SUBVOL_STD="Standard"
        T_SUBVOL_STD_DESC="@ and @snapshots (Root) + @home (Home if btrfs)"
        T_SUBVOL_ONLY="Only @"
        T_SUBVOL_ONLY_DESC="Only @ as root subvolume"
        T_SUBVOL_SKIP="Skip"
        T_SUBVOL_SKIP_DESC="Do not create subvolumes"
        T_UBUNTU_VERSION="Ubuntu Version"
        T_MIRROR_TITLE="Select Mirror"
        T_MIRROR_CUSTOM="Custom"
        T_MIRROR_CUSTOM_DESC="Enter URL manually"
        T_MIRROR_INPUT="Enter mirror URL:"
        T_DEBOOTSTRAP_CONFIRM="Installing Ubuntu %s to /mnt
Mirror: %s

Continue?"
        T_DEBOOTSTRAP_OK="Ubuntu %s successfully installed!"
        T_DEBOOTSTRAP_FAIL="ERROR: Debootstrap failed!
Check your internet connection and mirror."
        T_FSTAB_TITLE="fstab"
        T_FSTAB_CONFIRM="fstab will be created with:"
        T_CONFIG_TITLE="Configuration"
        T_HOSTNAME="Hostname"
        T_HOSTNAME_DESC="/etc/hostname"
        T_LOCALE="Locale"
        T_LOCALE_DESC="/etc/locale.conf, /etc/locale.gen"
        T_TIMEZONE="Timezone"
        T_TIMEZONE_DESC="/etc/localtime"
        T_APTSOURCES="apt-sources"
        T_APTSOURCES_DESC="/etc/apt/sources.list"
        T_PACKAGES="Packages"
        T_PACKAGES_DESC="apt install ..."
        T_ROOTPW="Root Password"
        T_USER="User"
        T_USER_DESC="adduser ..."
        T_BOOTLOADER="Bootloader"
        T_BOOTLOADER_DESC="systemd-boot / grub"
        T_NM="NetworkManager"
        T_NM_DESC="systemctl enable"
        T_SHELL="Shell"
        T_SHELL_DESC="Manual chroot shell"
        T_HOSTNAME_INPUT="Hostname:"
        T_HOSTNAME_SET="Hostname '%s' set!"
        T_LOCALE_TITLE="Locale"
        T_TIMEZONE_REGION="Timezone - Region"
        T_TIMEZONE_CITY="Timezone - City"
        T_TIMEZONE_SET="Timezone '%s' set!"
        T_PKG_BASE="Base"
        T_PKG_BASE_DESC="linux-generic btrfs-progs efibootmgr sudo"
        T_PKG_DESKTOP="Desktop"
        T_PKG_DESKTOP_DESC="Choose desktop environment"
        T_PKG_PROGRAMMES="Programs"
        T_SOFTWARE_DESC="Desktop, Programs, Extras"
        T_PKG_PROGRAMMES_DESC="Firefox, Thunderbird, Chrome"
        T_PKG_EXTRAS="Extras"
        T_PKG_EXTRAS_DESC="Additional packages"
        T_PKG_BOOTSCREEN="Bootscreen"
        T_PKG_BOOTSCREEN_DESC="Install Plymouth bootscreen"
        T_PKG_I386="32-Bit Support"
        T_PKG_I386_DESC="Enable i386 architecture"
        T_DESKTOP_TITLE="Desktop"
        T_KDE_BLOAT_TITLE="KDE Bloat"
        T_KDE_BLOAT_MSG="Remove unnecessary KDE packages?"
        T_GNOME_BLOAT_TITLE="GNOME Bloat"
        T_GNOME_BLOAT_MSG="Remove unnecessary GNOME packages?"
        T_BOOTLOADER_TITLE="Bootloader"
        T_SDB_CONFIRM="Install systemd-boot
Root UUID: %s

Continue?"
        T_GRUB_EFI_CONFIRM="Install GRUB EFI

Continue?"
        T_REBOOT_CONFIRM="Reboot system now?

Partitions will be unmounted."
        T_EOL_MSG="EOL release detected!
Redirecting mirror to old-releases.ubuntu.com."
        T_EOL_TITLE="EOL Release"
        T_NO_KERNEL="WARNING: No kernel found!"
        T_NM_OK="NetworkManager enabled."
        T_NET_TITLE="Network"
        T_NET_LAN="LAN (automatic)"
        T_NET_LAN_DESC="DHCP on all Ethernet interfaces"
        T_NET_WIFI="WiFi"
        T_NET_WIFI_DESC="Enter SSID and password"
        T_NET_SKIP="Skip"
        T_NET_SKIP_DESC="Continue without network"
        T_NET_SSID="WiFi name (SSID):"
        T_NET_PW="WiFi password:"
        T_NET_CONNECTING="Connecting to '%s'..."
        T_NET_OK="Connected!"
        T_NET_FAIL="Connection failed! Try again?"
        T_NET_LAN_OK="LAN active: %s"
        T_NET_LAN_FAIL="No LAN found or DHCP failed."
        T_NET_CHECK="Checking network..."
        T_EXTREPO_CONFIRM="The following packages will be installed from external repos:

%s

External repos + signing keys will be added.
Continue?"
        T_USER_INPUT="Username:"
        T_DISK_SELECT="Select EFI + Root Disk"
        T_DISK_SELECT_HOME="Select Home Disk"
        T_DISK_SELECT_ROOT="Select Root Disk"
        T_DISK_SELECT_GRUB="Select Disk for GRUB installation"
        T_DISK_SELECT_CFDISK="Select Disk for cfdisk"
        T_DISK_SELECT_FDISK="Select Disk for fdisk"
        T_PART_EFI="Select EFI Partition"
        T_PART_ROOT="Select Root Partition"
        T_PART_HOME="Select Home Partition"
        T_FS_ROOT="Root Filesystem"
        T_FS_HOME="Home Filesystem"
    fi
}



efi_part=""
root_part=""
home_part=""
swap_part=""

# Bereits eingehängte Partitionen automatisch erkennen
detect_mounted() {
    local r e h

    # SOURCE liefert z.B. "/dev/nvme0n1p2[/@]" bei btrfs subvols
    # Eckige Klammern und alles danach abschneiden
    r=$(findmnt -n -o SOURCE /mnt 2>/dev/null | sed 's/\[.*//')
    e=$(findmnt -n -o SOURCE /mnt/boot/efi 2>/dev/null | sed 's/\[.*//')
    h=$(findmnt -n -o SOURCE /mnt/home 2>/dev/null | sed 's/\[.*//')

    [ -n "$r" ] && root_part="$r"
    [ -n "$e" ] && efi_part="$e"
    [ -n "$h" ] && home_part="$h"

    # Filesystem erkennen
    [ -n "$root_part" ] && root_fs=$(blkid -s TYPE -o value "$root_part" 2>/dev/null)
    [ -n "$home_part" ] && home_fs=$(blkid -s TYPE -o value "$home_part" 2>/dev/null)
}
detect_mounted
hostname_val="ubuntu"
username_val=""
timezone_val="Europe/Berlin"
locale_val="de_DE"
root_fs="btrfs"
home_fs="btrfs"

# --------------------------------------------------------
pressanykey() {
    read -n1 -p "${T_PRESSKEY}"
    echo ""
}

selectdisk() {
    local title="$1"
    local items result
    items=$(lsblk -d -p -n -l -o NAME,SIZE -e 7,11)
    local options=()
    local IFS_ORIG=$IFS
    IFS=$'\n'
    for item in $items; do
        options+=("${item%% *}" "${item##* }")
    done
    IFS=$IFS_ORIG
    result=$(dialog --backtitle "$apptitle" --title "$title" \
        --cancel-button "$T_BACK" \
        --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return 1
    echo "$result"
}

selectpartition() {
    local title="$1"
    local default="$2"
    local items result
    items=$(lsblk -p -n -l -o NAME,SIZE,TYPE -e 7,11 | grep -E '\bpart\b')
    local options=()
    options+=("none" "-")
    local IFS_ORIG=$IFS
    IFS=$'\n'
    for item in $items; do
        local name size
        name=$(echo "$item" | awk '{print $1}')
        size=$(echo "$item" | awk '{print $2}')
        options+=("$name" "$size")
    done
    IFS=$IFS_ORIG
    result=$(dialog --backtitle "$apptitle" --title "$title" \
        --cancel-button "$T_BACK" \
        --default-item "$default" \
        --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return 1
    echo "$result"
}

selectfilesystem() {
    local title="$1"
    local options=()
    options+=("btrfs" "")
    options+=("ext4"  "")
    options+=("ext3"  "")
    options+=("ext2"  "")
    options+=("xfs"   "")
    local result
    result=$(dialog --backtitle "$apptitle" --title "$title" \
        --cancel-button "$T_BACK" \
        --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return 1
    echo "$result"
}

# --------------------------------------------------------
# Hauptmenü
# --------------------------------------------------------

mainmenu() {
    local nextitem="$T_LANGUAGE"
    while true; do
        local options=()
        options+=("$T_LANGUAGE"  "$T_LANGUAGE_DESC")
        options+=("$T_DISK"      "$T_DISK_DESC")
        options+=("Install"      "Debootstrap + Basispakete")
        options+=("$T_CONFIG"    "$T_CONFIG_DESC")
        options+=("Software"     "$T_SOFTWARE_DESC")
        options+=("Finishing"    "Benutzer, Root-PW, NetworkManager")
        options+=("$T_SHELL"     "$T_SHELL_DESC")
        options+=("$T_REMOUNT"   "$T_REMOUNT_DESC")
        options+=("$T_REBOOT"    "")

        local sel
        sel=$(dialog --backtitle "$apptitle" --title "$T_MAINMENU" \
            --cancel-button "$T_QUIT" \
            --default-item "$nextitem" \
            --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && { clear; chroot_cleanup 2>/dev/null; exit 0; }

        case $sel in
            "$T_LANGUAGE") select_language; set_language; nextitem="$T_DISK";;
            "$T_DISK")     diskmenu;        nextitem="Install";;
            "Install")     debootstrapmenu; nextitem="$T_CONFIG";;
            "$T_CONFIG")   configmenu;      nextitem="Software";;
            "Software")    softwaremenu;    nextitem="Finishing";;
            "Finishing")   finishingmenu;   nextitem="$T_SHELL";;
            "$T_SHELL")    clear; chroot /mnt /usr/bin/env LANG="${locale_val}.UTF-8" LANGUAGE="${locale_val%%_*}:en" /bin/bash;;
            "$T_REMOUNT")  remountmenu;;
            "$T_REBOOT")   rebootmenu;;
        esac
    done
}

# --------------------------------------------------------
# Phase 1: Disk Menü
# --------------------------------------------------------

diskmenu() {
    local nextitem="$T_PART_TITLE"
    while true; do
        local options=()
        options+=("$T_PART_TITLE" "")
        options+=("$T_FORMAT"    "")
        options+=("$T_SUBVOLS"   "$T_SUBVOLS_DESC")
        options+=("$T_MOUNT"     "")

        local sel
        sel=$(dialog --backtitle "$apptitle" --title "$T_DISK" \
            --cancel-button "$T_BACK" \
            --default-item "$nextitem" \
            --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && return

        case $sel in
            "$T_PART_TITLE") partmenu;   nextitem="$T_FORMAT";;
            "$T_FORMAT")    formatmenu; nextitem="$T_SUBVOLS";;
            "$T_SUBVOLS")   subvolmenu; nextitem="$T_MOUNT";;
            "$T_MOUNT")     mountmenu;  return;;
        esac
    done
}

# --------------------------------------------------------
# Phase 2: Debootstrap
# --------------------------------------------------------

# --------------------------------------------------------
# Tastaturlayout
# --------------------------------------------------------

keymapmenu() {
    local items result options=()

    items=$(localectl list-keymaps 2>/dev/null)
    if [ -z "$items" ]; then
        items=$(find /usr/share/kbd/keymaps/ -type f -name "*.map.gz" 2>/dev/null \
            | xargs -I{} basename {} .map.gz | sort -u)
    fi
    if [ -z "$items" ]; then
        items="de de-latin1 de-latin1-nodeadkeys us uk fr es it pt nl be pl ru cz sk hu ro tr"
    fi

    for item in $items; do
        options+=("${item}" "")
    done

    result=$(dialog --backtitle "$apptitle" --title "$T_KEYMAP_TITLE" \
        --cancel-button "$T_BACK" \
        --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return
    clear
    echo "loadkeys $result"
    if loadkeys "$result" 2>/dev/null; then
        printf "$T_KEYMAP_SET\n" "$result"
    elif loadkeys -C /dev/console "$result" 2>/dev/null; then
        printf "$T_KEYMAP_SET_CONSOLE\n" "$result"
    else
        echo -e "$T_KEYMAP_FAIL"
    fi
    pressanykey
}

# --------------------------------------------------------
# Partitionieren
# --------------------------------------------------------

partmenu() {
    local nextitem="${1:-.}"
    while true; do
        local options=()
        options+=("$T_AUTO_GPT"  "$T_AUTO_GPT_DESC")
        options+=("$T_AUTO_BIOS"  "$T_AUTO_BIOS_DESC")
        options+=("$T_MANUAL_CFDISK"  "$T_MANUAL_DESC")
        options+=("$T_MANUAL_FDISK"  "$T_MANUAL_DESC")

        local sel
        sel=$(dialog --backtitle "$apptitle" --title "$T_PART_TITLE" \
            --cancel-button "$T_BACK" \
            --default-item "$nextitem" \
            --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && return

        case $sel in
            "$T_AUTO_GPT")   part_auto_efi;  return;;
            "$T_AUTO_BIOS")  part_auto_bios; return;;
            "$T_MANUAL_CFDISK") part_cfdisk;;
            "$T_MANUAL_FDISK")  part_fdisk;;
        esac
    done
}

part_auto_efi() {
    local disk
    disk=$(selectdisk "$T_DISK_SELECT")
    [ "$?" != "0" ] || [ -z "$disk" ] && return

    local use_home
    dialog --backtitle "$apptitle" --title "Home" \
        --yesno "$T_HOME_SEPARATE" 0 0
    use_home=$?

    local homedisk=""
    if [ "$use_home" = "0" ]; then
        homedisk=$(selectdisk "$T_DISK_SELECT_HOME")
        [ "$?" != "0" ] && return
    fi

    local efi_size
    while true; do
        efi_size=$(dialog --backtitle "$apptitle" --title "$T_EFI_SIZE_TITLE" \
            --inputbox "$T_EFI_SIZE" 0 0 "512MiB" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && return
        # Validierung: muss Zahl + Einheit sein (z.B. 512MiB, 1GiB, 256MB)
        if echo "$efi_size" | grep -qE '^[0-9]+(\.[0-9]+)?(MiB|GiB|MB|GB|MiB)$'; then
            break
        else
            dialog --backtitle "$apptitle" --title "$T_WARNING" \
                --msgbox "Ungültige EFI-Größe: '${efi_size}'\nBitte Format wie '512MiB' oder '1GiB' verwenden." 0 0
        fi
    done

    # Swap fragen
    local swap_size_mib=0
    dialog --backtitle "$apptitle" --title "Swap" \
        --yesno "Swap-Partition anlegen?\n\nRAM-Größe: $(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 ))MiB" 0 0
    [ "$?" = "0" ] && swap_size_mib=$(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 ))

    dialog --backtitle "$apptitle" --title "$T_PART_TITLE" \
        --defaultno --yesno \
        "ACHTUNG: Alle Daten auf ${disk}$([ -n "$homedisk" ] && echo " und $homedisk") werden gelöscht!\n\nFortfahren?" 0 0
    [ "$?" != "0" ] && return

    clear
    echo "==> Hänge ${disk} aus und wipe..."
    chroot_cleanup 2>/dev/null
    umount -R -l /mnt 2>/dev/null
    for part in "${disk}"p{1..9} "${disk}"{1..9}; do
        if [ -b "$part" ]; then
            fuser -km "$part" 2>/dev/null
            umount -l "$part" 2>/dev/null
            swapoff "$part" 2>/dev/null
        fi
    done
    fuser -km "$disk" 2>/dev/null
    sleep 1
    partprobe "$disk" 2>/dev/null
    sleep 1
    wipefs -a "$disk"

    echo "==> Partitioniere ${disk} (EFI + Root)..."
    parted -s "$disk" mklabel gpt
    parted -s "$disk" mkpart EFI fat32 1MiB "${efi_size}"
    parted -s "$disk" set 1 esp on

    if [ "$swap_size_mib" -gt 0 ]; then
        local disk_mib
        disk_mib=$(( $(lsblk -b -d -n -o SIZE "$disk") / 1024 / 1024 ))
        local root_end_mib=$(( disk_mib - swap_size_mib ))
        parted -s "$disk" mkpart Root "${root_fs}" "${efi_size}" "${root_end_mib}MiB"
        parted -s "$disk" mkpart Swap linux-swap "${root_end_mib}MiB" 100%
    else
        parted -s "$disk" mkpart Root "${root_fs}" "${efi_size}" 100%
    fi
    partprobe "$disk" 2>/dev/null; sleep 1

    if [[ "$disk" == *"nvme"* ]] || [[ "$disk" == *"mmcblk"* ]]; then
        efi_part="${disk}p1"
        root_part="${disk}p2"
        [ "$swap_size_mib" -gt 0 ] && swap_part="${disk}p3"
    else
        efi_part="${disk}1"
        root_part="${disk}2"
        [ "$swap_size_mib" -gt 0 ] && swap_part="${disk}3"
    fi

    echo "==> Nuke Partition-Signaturen..."
    wipefs -a "$efi_part" 2>/dev/null
    wipefs -a "$root_part" 2>/dev/null
    [ -n "$swap_part" ] && wipefs -a "$swap_part" 2>/dev/null

    if [ -n "$homedisk" ]; then
        echo "==> Hänge ${homedisk} aus und wipe..."
        for part in "${homedisk}"p{1..9} "${homedisk}"{1..9}; do
            if [ -b "$part" ]; then
                fuser -km "$part" 2>/dev/null
                umount -l "$part" 2>/dev/null
                swapoff "$part" 2>/dev/null
            fi
        done
        fuser -km "$homedisk" 2>/dev/null
        sleep 1
        partprobe "$homedisk" 2>/dev/null
        sleep 1
        wipefs -a "$homedisk"
        echo "==> Partitioniere ${homedisk} (Home)..."
        parted -s "$homedisk" mklabel gpt
        parted -s "$homedisk" mkpart Home "${home_fs}" 1MiB 100%
        partprobe "$homedisk" 2>/dev/null; sleep 1
        if [[ "$homedisk" == *"nvme"* ]] || [[ "$homedisk" == *"mmcblk"* ]]; then
            home_part="${homedisk}p1"
        else
            home_part="${homedisk}1"
        fi
        echo "==> Nuke Home-Partition-Signaturen..."
        wipefs -a "$home_part" 2>/dev/null
    fi

    echo ""
    echo "EFI:  ${efi_part}"
    echo "Root: ${root_part}"
    [ -n "$swap_part" ] && echo "Swap: ${swap_part} (${swap_size_mib}MiB)"
    [ -n "$home_part" ] && echo "Home: ${home_part}"
    pressanykey
}

part_auto_bios() {
    local disk
    disk=$(selectdisk "$T_DISK_SELECT_ROOT")
    [ "$?" != "0" ] || [ -z "$disk" ] && return

    local use_home
    dialog --backtitle "$apptitle" --title "Home" \
        --yesno "$T_HOME_SEPARATE" 0 0
    use_home=$?

    local homedisk=""
    if [ "$use_home" = "0" ]; then
        homedisk=$(selectdisk "$T_DISK_SELECT_HOME")
        [ "$?" != "0" ] && return
    fi

    # Swap fragen (vor dem Wipe)
    local swap_size_mib=0
    dialog --backtitle "$apptitle" --title "Swap" \
        --yesno "Swap-Partition anlegen?\n\nRAM-Größe: $(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 ))MiB" 0 0
    [ "$?" = "0" ] && swap_size_mib=$(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 ))

    dialog --backtitle "$apptitle" --title "$T_PART_TITLE" \
        --defaultno --yesno \
        "$(printf "$T_DATA_LOST" "${disk}$([ -n "$homedisk" ] && echo " und $homedisk")")" 0 0
    [ "$?" != "0" ] && return

    clear
    echo "==> Hänge ${disk} aus und wipe..."
    chroot_cleanup 2>/dev/null
    umount -R -l /mnt 2>/dev/null
    for part in "${disk}"p{1..9} "${disk}"{1..9}; do
        if [ -b "$part" ]; then
            fuser -km "$part" 2>/dev/null
            umount -l "$part" 2>/dev/null
            swapoff "$part" 2>/dev/null
        fi
    done
    fuser -km "$disk" 2>/dev/null
    sleep 1
    partprobe "$disk" 2>/dev/null
    sleep 1
    wipefs -a "$disk"

    echo "==> Partitioniere ${disk} (MBR/BIOS Root)..."
    parted -s "$disk" mklabel msdos

    if [ "$swap_size_mib" -gt 0 ]; then
        parted -s "$disk" mkpart primary "${root_fs}" 1MiB "-${swap_size_mib}MiB"
        parted -s "$disk" set 1 boot on
        parted -s "$disk" mkpart primary linux-swap "-${swap_size_mib}MiB" 100%
    else
        parted -s "$disk" mkpart primary "${root_fs}" 1MiB 100%
        parted -s "$disk" set 1 boot on
    fi
    partprobe "$disk" 2>/dev/null; sleep 1

    if [[ "$disk" == *"nvme"* ]] || [[ "$disk" == *"mmcblk"* ]]; then
        root_part="${disk}p1"
        [ "$swap_size_mib" -gt 0 ] && swap_part="${disk}p2"
    else
        root_part="${disk}1"
        [ "$swap_size_mib" -gt 0 ] && swap_part="${disk}2"
    fi
    efi_part=""
    BOOT_MODE="bios"

    echo "==> Nuke Partition-Signaturen..."
    wipefs -a "$root_part" 2>/dev/null
    [ -n "$swap_part" ] && wipefs -a "$swap_part" 2>/dev/null

    if [ -n "$homedisk" ]; then
        echo "==> Hänge ${homedisk} aus und wipe..."
        for part in "${homedisk}"p{1..9} "${homedisk}"{1..9}; do
            if [ -b "$part" ]; then
                fuser -km "$part" 2>/dev/null
                umount -l "$part" 2>/dev/null
                swapoff "$part" 2>/dev/null
            fi
        done
        fuser -km "$homedisk" 2>/dev/null
        sleep 1
        partprobe "$homedisk" 2>/dev/null
        sleep 1
        wipefs -a "$homedisk"
        echo "==> Partitioniere ${homedisk} (Home)..."
        parted -s "$homedisk" mklabel msdos
        parted -s "$homedisk" mkpart primary "${home_fs}" 1MiB 100%
        partprobe "$homedisk" 2>/dev/null; sleep 1
        if [[ "$homedisk" == *"nvme"* ]] || [[ "$homedisk" == *"mmcblk"* ]]; then
            home_part="${homedisk}p1"
        else
            home_part="${homedisk}1"
        fi
        echo "==> Nuke Home-Partition-Signaturen..."
        wipefs -a "$home_part" 2>/dev/null
    fi

    echo ""
    echo "Root: ${root_part}"
    [ -n "$swap_part" ] && echo "Swap: ${swap_part} (${swap_size_mib}MiB)"
    [ -n "$home_part" ] && echo "Home: ${home_part}"
    pressanykey
}

part_cfdisk() {
    local disk
    disk=$(selectdisk "$T_DISK_SELECT_CFDISK")
    [ "$?" != "0" ] || [ -z "$disk" ] && return
    clear
    cfdisk "$disk"
}

part_fdisk() {
    local disk
    disk=$(selectdisk "$T_DISK_SELECT_FDISK")
    [ "$?" != "0" ] || [ -z "$disk" ] && return
    clear
    fdisk "$disk"
}

# --------------------------------------------------------
# Formatieren
# --------------------------------------------------------

formatmenu() {
    # 1. Erst alle Partitionen auswählen
    local p
    if [ "${BOOT_MODE:-efi}" != "bios" ]; then
        p=$(selectpartition "$T_PART_EFI" "${efi_part:-none}")
        [ "$?" != "0" ] && return
        if [ "$p" = "none" ]; then efi_part=""; else efi_part="$p"; fi
    fi

    p=$(selectpartition "$T_PART_ROOT" "${root_part:-none}")
    [ "$?" != "0" ] && return
    if [ "$p" = "none" ]; then root_part=""; else root_part="$p"; fi

    p=$(selectpartition "$T_PART_HOME" "${home_part:-none}")
    [ "$?" != "0" ] && return
    if [ "$p" = "none" ]; then home_part=""; else home_part="$p"; fi

    p=$(selectpartition "Swap Partition" "${swap_part:-none}")
    [ "$?" != "0" ] && return
    if [ "$p" = "none" ]; then swap_part=""; else swap_part="$p"; fi

    # 2. Dann Filesysteme abfragen
    if [ -n "$root_part" ]; then
        root_fs=$(selectfilesystem "$T_FS_ROOT")
        [ "$?" != "0" ] && return
    fi

    if [ -n "$home_part" ]; then
        home_fs=$(selectfilesystem "$T_FS_HOME")
        [ "$?" != "0" ] && return
    fi

    [ -z "$efi_part" ] && [ -z "$root_part" ] && [ -z "$home_part" ] && return

    local msg="Folgende Partitionen werden formatiert:\n\n"
    [ -n "$efi_part" ]  && msg+="EFI:  ${efi_part} -> fat32\n"
    [ -n "$root_part" ] && msg+="Root: ${root_part} -> ${root_fs}\n"
    [ -n "$home_part" ] && msg+="Home: ${home_part} -> ${home_fs}\n"
    [ -n "$swap_part" ] && msg+="Swap: ${swap_part} -> swap\n"

    dialog --backtitle "$apptitle" --title "$T_FORMAT_TITLE" \
        --yesno "$msg\n$T_CONTINUE" 0 0
    [ "$?" != "0" ] && return

    clear
    if [ "${BOOT_MODE:-efi}" != "bios" ] && [ -n "$efi_part" ]; then
        echo "==> Formatiere EFI: ${efi_part} -> fat32"
        mkfs.fat -F32 "$efi_part"
    fi

    echo "==> Formatiere Root: ${root_part} -> ${root_fs}"
    case $root_fs in
        btrfs)  mkfs.btrfs -f -L root "$root_part";;
        ext4)   mkfs.ext4 -F -E lazy_itable_init=1,lazy_journal_init=1 -L root "$root_part";;
        ext3)   mkfs.ext3 -F -L root "$root_part";;
        ext2)   mkfs.ext2 -F -L root "$root_part";;
        xfs)    mkfs.xfs -f -L root "$root_part";;
    esac
    partprobe 2>/dev/null; sleep 2

    if [ -n "$home_part" ]; then
        echo "==> Formatiere Home: ${home_part} -> ${home_fs}"
        case $home_fs in
            btrfs)  mkfs.btrfs -f -L home "$home_part";;
            ext4)   mkfs.ext4 -F -E lazy_itable_init=1,lazy_journal_init=1 -L home "$home_part";;
            ext3)   mkfs.ext3 -F -L home "$home_part";;
            ext2)   mkfs.ext2 -F -L home "$home_part";;
            xfs)    mkfs.xfs -f -L home "$home_part";;
        esac
        partprobe 2>/dev/null; sleep 2
    fi

    if [ -n "$swap_part" ]; then
        echo "==> Formatiere Swap: ${swap_part}"
        mkswap -L swap "$swap_part"
        partprobe 2>/dev/null; sleep 1
    fi

    echo ""
    echo "Formatierung abgeschlossen!"
    pressanykey
}

# --------------------------------------------------------
# BTRFS Subvolumes
# --------------------------------------------------------

subvolmenu() {
    [ "$root_fs" != "btrfs" ] && {
        dialog --backtitle "$apptitle" --title "$T_SUBVOL_TITLE" \
            --msgbox "$T_SUBVOL_NOBTRFS" 0 0
        return
    }

    local options=()
    options+=("$T_SUBVOL_STD"  "$T_SUBVOL_STD_DESC")
    options+=("$T_SUBVOL_ONLY"  "$T_SUBVOL_ONLY_DESC")
    options+=("$T_SUBVOL_SKIP"  "$T_SUBVOL_SKIP_DESC")

    local sel
    sel=$(dialog --backtitle "$apptitle" --title "$T_SUBVOL_TITLE" \
        --cancel-button "$T_BACK" \
        --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return

    clear
    case $sel in
        "$T_SUBVOL_STD")
            echo "==> Erstelle Root-Subvolumes (@, @snapshots)..."
            mount "$root_part" /mnt
            btrfs subvolume create /mnt/@
            btrfs subvolume create /mnt/@snapshots
            umount /mnt

            if [ -n "$home_part" ] && [ "$home_fs" = "btrfs" ]; then
                echo "==> Erstelle Home-Subvolume (@home)..."
                mount "$home_part" /mnt
                btrfs subvolume create /mnt/@home
                umount /mnt
            fi
            USE_SUBVOLS=1
            ;;
        "$T_SUBVOL_ONLY")
            echo "==> Erstelle Root-Subvolume (@)..."
            mount "$root_part" /mnt
            btrfs subvolume create /mnt/@
            umount /mnt

            if [ -n "$home_part" ] && [ "$home_fs" = "btrfs" ]; then
                echo "==> Erstelle Home-Subvolume (@home)..."
                mount "$home_part" /mnt
                btrfs subvolume create /mnt/@home
                umount /mnt
            fi
            USE_SUBVOLS=2
            ;;
        "$T_SUBVOL_SKIP")
            USE_SUBVOLS=0
            ;;
    esac

    echo ""
    echo "Fertig!"
    pressanykey
}

# --------------------------------------------------------
# Einhängen
# --------------------------------------------------------

mountmenu() {
    clear
    echo "==> Hänge Root ein..."
    if [ "$root_fs" = "btrfs" ] && [ "${USE_SUBVOLS:-0}" -ge "1" ]; then
        mount -o defaults,compress=zstd,subvol=@ "$root_part" /mnt
    else
        mount "$root_part" /mnt
    fi

    if [ -n "$home_part" ]; then
        mkdir -p /mnt/home
    fi
    if [ "$root_fs" = "btrfs" ] && [ "${USE_SUBVOLS:-0}" = "1" ]; then
        mkdir -p /mnt/.snapshots
        mount -o defaults,compress=zstd,subvol=@snapshots "$root_part" /mnt/.snapshots
    fi

    if [ -n "$home_part" ]; then
        echo "==> Hänge Home ein..."
        if [ "$home_fs" = "btrfs" ] && [ "${USE_SUBVOLS:-0}" -ge "1" ]; then
            mount -o defaults,compress=zstd,subvol=@home "$home_part" /mnt/home
        else
            mount "$home_part" /mnt/home
        fi
    fi

    if [ "${BOOT_MODE:-efi}" != "bios" ] && [ -n "$efi_part" ]; then
        mkdir -p /mnt/boot/efi
        echo "==> Hänge EFI ein..."
        mount "$efi_part" /mnt/boot/efi
    fi

    echo ""
    echo "Eingehängt:"
    lsblk
    pressanykey
}

# --------------------------------------------------------
# Debootstrap
# --------------------------------------------------------

debootstrapmenu() {
    local options=()
    options+=("resolute"  "Ubuntu 26.04 LTS")
    options+=("questing"  "Ubuntu 25.10")
    options+=("plucky"    "Ubuntu 25.04")
    options+=("oracular"  "Ubuntu 24.10")
    options+=("noble"     "Ubuntu 24.04 LTS")
    options+=("mantic"    "Ubuntu 23.10 (EOL)")
    options+=("lunar"     "Ubuntu 23.04 (EOL)")
    options+=("kinetic"   "Ubuntu 22.10 (EOL)")
    options+=("jammy"     "Ubuntu 22.04 LTS")
    options+=("impish"    "Ubuntu 21.10 (EOL)")
    options+=("hirsute"   "Ubuntu 21.04 (EOL)")
    options+=("groovy"    "Ubuntu 20.10 (EOL)")
    options+=("focal"     "Ubuntu 20.04 LTS")
    options+=("eoan"      "Ubuntu 19.10 (EOL)")
    options+=("disco"     "Ubuntu 19.04 (EOL)")
    options+=("cosmic"    "Ubuntu 18.10 (EOL)")
    options+=("bionic"    "Ubuntu 18.04 LTS (EOL)")
    options+=("artful"    "Ubuntu 17.10 (EOL)")
    options+=("zesty"     "Ubuntu 17.04 (EOL)")
    options+=("yakkety"   "Ubuntu 16.10 (EOL)")
    options+=("xenial"    "Ubuntu 16.04 LTS (EOL)")
    options+=("wily"      "Ubuntu 15.10 (EOL)")
    options+=("vivid"     "Ubuntu 15.04 (EOL)")
    options+=("utopic"    "Ubuntu 14.10 (EOL)")
    options+=("trusty"    "Ubuntu 14.04 LTS (EOL)")

    local release
    release=$(dialog --backtitle "$apptitle" --title "$T_UBUNTU_VERSION" \
        --cancel-button "$T_BACK" \
        --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return

    local mirror_options=()
    mirror_options+=("http://archive.ubuntu.com/ubuntu"                    "Canonical (Global)")
    mirror_options+=("http://de.archive.ubuntu.com/ubuntu"                 "Deutschland (Offiziell)")
    mirror_options+=("https://mirror.de.leaseweb.net/ubuntu"               "LeaseWeb Frankfurt (DE)")
    mirror_options+=("https://ftp.fau.de/ubuntu"                           "FAU Erlangen / RRZE (DE)")
    mirror_options+=("https://ftp.halifax.rwth-aachen.de/ubuntu"           "RWTH Aachen (DE)")
    mirror_options+=("http://ftp.tu-chemnitz.de/pub/linux/ubuntu"          "TU Chemnitz (DE)")
    mirror_options+=("http://ubuntu.mirror.tudos.de/ubuntu"                "TU Dresden (DE)")
    mirror_options+=("http://mirror.netcologne.de/ubuntu"                  "NetCologne (DE)")
    mirror_options+=("$T_MIRROR_CUSTOM"  "$T_MIRROR_CUSTOM_DESC")

    local mirror
    mirror=$(dialog --backtitle "$apptitle" --title "$T_MIRROR_TITLE" \
        --cancel-button "$T_BACK" \
        --menu "" 0 0 0 "${mirror_options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return

    if [ "$mirror" = "$T_MIRROR_CUSTOM" ]; then
        mirror=$(dialog --backtitle "$apptitle" --title "$T_MIRROR_CUSTOM" \
            --inputbox "$T_MIRROR_INPUT" 0 0 "http://" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && return
    fi

    dialog --backtitle "$apptitle" --title "Debootstrap" \
        --yesno "$(printf "$T_DEBOOTSTRAP_CONFIRM" "$release" "$mirror")" 0 0
    [ "$?" != "0" ] && return

    # EOL-Releases auf old-releases.ubuntu.com umleiten falls nötig
    local eol_releases="trusty utopic vivid wily xenial yakkety zesty artful bionic cosmic disco eoan groovy hirsute impish kinetic lunar mantic"
    local use_mirror="$mirror"
    UBUNTU_MIRROR="$mirror"
    for eol in $eol_releases; do
        if [ "$release" = "$eol" ] && echo "$mirror" | grep -q "archive.ubuntu.com"; then
            use_mirror="http://old-releases.ubuntu.com/ubuntu"
            UBUNTU_MIRROR="$use_mirror"
            dialog --backtitle "$apptitle" --title "$T_EOL_TITLE"                 --msgbox "$T_EOL_MSG" 0 0
            break
        fi
    done

    clear
    echo "==> Prüfe Mirror-Erreichbarkeit für ${release}..."
    if ! curl -sf --max-time 10 "${use_mirror}/dists/${release}/Release" -o /dev/null; then
        dialog --backtitle "$apptitle" --title "$T_WARNING" \
            --msgbox "Mirror nicht erreichbar oder Release '${release}' noch nicht verfügbar:\n${use_mirror}\n\nBitte anderen Mirror wählen oder später erneut versuchen." 0 0
        return
    fi
    echo "==> Mirror OK, starte debootstrap..."
    debootstrap --no-check-gpg --arch=amd64 "$release" /mnt "$use_mirror"

    if [ "$?" = "0" ]; then
        UBUNTU_RELEASE="$release"
        UBUNTU_MIRROR="$use_mirror"
        chroot_prepare
        config_aptsources
        echo ""
        echo "==> Installiere Basispakete..."
        pkg_base
    else
        dialog --backtitle "$apptitle" --title "Debootstrap" \
            --msgbox "$T_DEBOOTSTRAP_FAIL" 0 0
    fi
}

# --------------------------------------------------------
# fstab
# --------------------------------------------------------

fstabmenu() {
    udevadm settle
    local uuid_root uuid_efi uuid_home uuid_swap
    uuid_root=$(blkid -s UUID -o value "$root_part" 2>/dev/null)
    uuid_efi=$(blkid -s UUID -o value "$efi_part" 2>/dev/null)
    [ -n "$home_part" ] && uuid_home=$(blkid -s UUID -o value "$home_part" 2>/dev/null)
    [ -n "$swap_part" ] && uuid_swap=$(blkid -s UUID -o value "$swap_part" 2>/dev/null)

    local msg="fstab wird erstellt mit:\n\n"
    msg+="Root UUID: ${uuid_root}\n"
    msg+="EFI  UUID: ${uuid_efi}\n"
    [ -n "$uuid_home" ] && msg+="Home UUID: ${uuid_home}\n"
    [ -n "$uuid_swap" ] && msg+="Swap UUID: ${uuid_swap}\n"

    dialog --backtitle "$apptitle" --title "$T_FSTAB_TITLE" \
        --yesno "$msg\n$T_CONTINUE" 0 0
    [ "$?" != "0" ] && return

    # Root-Eintrag
    if [ "$root_fs" = "btrfs" ] && [ "${USE_SUBVOLS:-0}" -ge "1" ]; then
        echo "UUID=${uuid_root}  /  btrfs  defaults,compress=zstd,subvol=@  0 0" > /mnt/etc/fstab
        if [ "${USE_SUBVOLS:-0}" = "1" ]; then
            echo "UUID=${uuid_root}  /.snapshots  btrfs  defaults,compress=zstd,subvol=@snapshots  0 0" >> /mnt/etc/fstab
        fi
    else
        echo "UUID=${uuid_root}  /  ${root_fs}  defaults  0 1" > /mnt/etc/fstab
    fi

    # Home-Eintrag
    if [ -n "$home_part" ] && [ -n "$uuid_home" ]; then
        if [ "$home_fs" = "btrfs" ] && [ "${USE_SUBVOLS:-0}" -ge "1" ]; then
            echo "UUID=${uuid_home}  /home  btrfs  defaults,compress=zstd,subvol=@home  0 0" >> /mnt/etc/fstab
        else
            echo "UUID=${uuid_home}  /home  ${home_fs}  defaults  0 2" >> /mnt/etc/fstab
        fi
    fi

    # Swap-Eintrag
    if [ -n "$swap_part" ] && [ -n "$uuid_swap" ]; then
        echo "UUID=${uuid_swap}  none  swap  sw  0 0" >> /mnt/etc/fstab
    fi

    # EFI-Eintrag nur bei EFI-System
    if [ "${BOOT_MODE:-efi}" != "bios" ] && [ -n "$uuid_efi" ]; then
        echo "UUID=${uuid_efi}  /boot/efi  vfat  umask=0077  0 1" >> /mnt/etc/fstab
    fi

    dialog --backtitle "$apptitle" --title "$T_FSTAB_TITLE" \
        --msgbox "$(cat /mnt/etc/fstab)" 0 0
}

# --------------------------------------------------------
# Chroot Konfiguration
# --------------------------------------------------------

chroot_prepare() {
    mkdir -p /mnt/dev /mnt/dev/pts /mnt/dev/shm /mnt/proc /mnt/sys /mnt/run /mnt/tmp
    mount --bind /dev /mnt/dev 2>/dev/null
    mount -t devpts devpts /mnt/dev/pts -o gid=5,mode=620 2>/dev/null
    mount -t tmpfs tmpfs /mnt/dev/shm 2>/dev/null
    mount -t proc proc /mnt/proc 2>/dev/null
    mount -t sysfs sysfs /mnt/sys 2>/dev/null
    mount --bind /sys/firmware/efi/efivars /mnt/sys/firmware/efi/efivars 2>/dev/null
    mount --bind /run /mnt/run 2>/dev/null
    mount -t tmpfs tmpfs /mnt/tmp 2>/dev/null
    local lang_code="${locale_val%%_*}"
    export LANG="${locale_val}.UTF-8"
    export LANGUAGE="${lang_code}:en"
}

chroot_cleanup() {
    umount /mnt/tmp 2>/dev/null
    umount /mnt/run 2>/dev/null
    umount /mnt/sys/firmware/efi/efivars 2>/dev/null
    umount /mnt/sys 2>/dev/null
    umount /mnt/proc 2>/dev/null
    umount /mnt/dev/shm 2>/dev/null
    umount /mnt/dev/pts 2>/dev/null
    umount /mnt/dev 2>/dev/null
}

configmenu() {
    local nextitem="$T_HOSTNAME"
    while true; do
        local options=()
        options+=("$T_HOSTNAME"       "$T_HOSTNAME_DESC")
        options+=("$T_LOCALE"         "$T_LOCALE_DESC")
        options+=("$T_TIMEZONE"       "$T_TIMEZONE_DESC")
        options+=("$T_FSTAB"          "$T_FSTAB_DESC")
        options+=("$T_BOOTLOADER"     "$T_BOOTLOADER_DESC")
        options+=("$T_PKG_BOOTSCREEN" "$T_PKG_BOOTSCREEN_DESC")
        options+=("$T_PKG_I386"       "$T_PKG_I386_DESC")

        local sel
        sel=$(dialog --backtitle "$apptitle" --title "$T_CONFIG_TITLE" \
            --cancel-button "$T_BACK" \
            --default-item "$nextitem" \
            --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && break

        case $sel in
            "$T_HOSTNAME")       config_hostname;  nextitem="$T_LOCALE";;
            "$T_LOCALE")         config_locale;    nextitem="$T_TIMEZONE";;
            "$T_TIMEZONE")       config_timezone;  nextitem="$T_FSTAB";;
            "$T_FSTAB")          fstabmenu;        nextitem="$T_BOOTLOADER";;
            "$T_BOOTLOADER")     bootloadermenu;   nextitem="$T_PKG_BOOTSCREEN";;
            "$T_PKG_BOOTSCREEN") pkg_bootscreen;   nextitem="$T_PKG_I386";;
            "$T_PKG_I386")       pkg_i386;         nextitem="$T_PKG_I386";;
        esac
    done
}

finishingmenu() {
    local nextitem="$T_ROOTPW"
    while true; do
        local options=()
        options+=("$T_ROOTPW" "")
        options+=("$T_USER"   "$T_USER_DESC")
        options+=("$T_NM"     "$T_NM_DESC")

        local sel
        sel=$(dialog --backtitle "$apptitle" --title "Finishing Touches" \
            --cancel-button "$T_BACK" \
            --default-item "$nextitem" \
            --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && break

        case $sel in
            "$T_ROOTPW") config_rootpw; nextitem="$T_USER";;
            "$T_USER")   config_user;   nextitem="$T_NM";;
            "$T_NM")     config_nm;     nextitem="$T_NM";;
        esac
    done
}


softwaremenu() {
    local nextitem="$T_PKG_DESKTOP"
    while true; do
        local options=()
        options+=("$T_PKG_DESKTOP"     "$T_PKG_DESKTOP_DESC")
        options+=("$T_PKG_PROGRAMMES"  "$T_PKG_PROGRAMMES_DESC")
        options+=("$T_PKG_EXTRAS"      "$T_PKG_EXTRAS_DESC")

        local sel
        sel=$(dialog --backtitle "$apptitle" --title "Software" \
            --cancel-button "$T_BACK" \
            --default-item "$nextitem" \
            --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && return

        case $sel in
            "$T_PKG_DESKTOP")    pkg_desktop;    nextitem="$T_PKG_PROGRAMMES";;
            "$T_PKG_PROGRAMMES") pkg_programmes; nextitem="$T_PKG_EXTRAS";;
            "$T_PKG_EXTRAS")     pkg_extras;     nextitem="$T_PKG_DESKTOP";;
        esac
    done
}

config_hostname() {
    local result
    result=$(dialog --backtitle "$apptitle" --title "$T_HOSTNAME" \
        --inputbox "$T_HOSTNAME_INPUT" 0 0 "${hostname_val}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return
    hostname_val="$result"
    echo "$hostname_val" > /mnt/etc/hostname
    cat > /mnt/etc/hosts <<EOF
127.0.0.1 localhost
127.0.1.1 ${hostname_val}
EOF
    dialog --backtitle "$apptitle" --title "$T_HOSTNAME" \
        --msgbox "$(printf "$T_HOSTNAME_SET" "$hostname_val")" 0 0
}

config_locale() {
    local items result options=()
    items=$(ls /mnt/usr/share/i18n/locales 2>/dev/null || ls /usr/share/i18n/locales)
    for item in $items; do
        options+=("$item" "")
    done
    result=$(dialog --backtitle "$apptitle" --title "$T_LOCALE_TITLE" \
        --default-item "${locale_val}" \
        --cancel-button "$T_BACK" \
        --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return
    locale_val="$result"
    clear
    local lang_code="${locale_val%%_*}"
    # Erst language-pack installieren (bringt locale-Definitionen mit)
    chroot /mnt apt install -y "language-pack-${lang_code}" "language-pack-${lang_code}-base" 2>/dev/null || true
    chroot /mnt apt install -y "manpages-${lang_code}" 2>/dev/null || true
    # Dann locale generieren
    echo "${locale_val}.UTF-8 UTF-8" >> /mnt/etc/locale.gen
    chroot /mnt locale-gen
    # Dann Konfigurationsdateien schreiben
    echo "LANG=${locale_val}.UTF-8" > /mnt/etc/locale.conf
    mkdir -p /mnt/etc/default
    cat > /mnt/etc/default/locale <<EOF
LANG=${locale_val}.UTF-8
LANGUAGE=${lang_code}
LC_CTYPE=${locale_val}.UTF-8
LC_NUMERIC=${locale_val}.UTF-8
LC_TIME=${locale_val}.UTF-8
LC_COLLATE=${locale_val}.UTF-8
LC_MONETARY=${locale_val}.UTF-8
LC_MESSAGES=${locale_val}.UTF-8
LC_PAPER=${locale_val}.UTF-8
LC_NAME=${locale_val}.UTF-8
LC_ADDRESS=${locale_val}.UTF-8
LC_TELEPHONE=${locale_val}.UTF-8
LC_MEASUREMENT=${locale_val}.UTF-8
LC_IDENTIFICATION=${locale_val}.UTF-8
EOF
    chroot /mnt update-locale LANG="${locale_val}.UTF-8"

    # Hunspell Dictionary installieren
    local hunspell_pkg
    case "$lang_code" in
        de) hunspell_pkg="hunspell-de-de" ;;
        pt) hunspell_pkg="hunspell-pt-pt" ;;
        en) hunspell_pkg="hunspell-en-us" ;;
        *) hunspell_pkg="hunspell-${lang_code}" ;;
    esac
    chroot /mnt apt install -y "$hunspell_pkg" 2>/dev/null || true

    pressanykey
}

config_timezone() {
    local zones result options=()
    zones=$(ls /mnt/usr/share/zoneinfo/ | grep -v "posix\|right\|leap")
    for z in $zones; do
        options+=("$z" "")
    done
    local region
    region=$(dialog --backtitle "$apptitle" --title "$T_TIMEZONE_REGION" \
        --cancel-button "$T_BACK" \
        --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return

    local cities options2=()
    cities=$(ls /mnt/usr/share/zoneinfo/"$region"/ 2>/dev/null)
    if [ -n "$cities" ]; then
        for c in $cities; do
            options2+=("$c" "")
        done
        local city
        city=$(dialog --backtitle "$apptitle" --title "$T_TIMEZONE_CITY" \
            --cancel-button "$T_BACK" \
            --menu "" 0 0 0 "${options2[@]}" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && return
        timezone_val="${region}/${city}"
    else
        timezone_val="$region"
    fi

    chroot /mnt ln -sf "/usr/share/zoneinfo/${timezone_val}" /etc/localtime
    echo "$timezone_val" > /mnt/etc/timezone
    dialog --backtitle "$apptitle" --title "Zeitzone" \
        --msgbox "$(printf "$T_TIMEZONE_SET" "$timezone_val")" 0 0
}

config_aptsources() {
    local release="${UBUNTU_RELEASE:-questing}"
    local mirror="${UBUNTU_MIRROR:-http://archive.ubuntu.com/ubuntu}"
    local eol_releases="trusty utopic vivid wily xenial yakkety zesty artful bionic cosmic disco eoan groovy hirsute impish kinetic lunar mantic"
    local use_mirror="$mirror"
    local security_mirror="http://security.ubuntu.com/ubuntu"
    for eol in $eol_releases; do
        if [ "$release" = "$eol" ]; then
            use_mirror="http://old-releases.ubuntu.com/ubuntu"
            security_mirror="http://old-releases.ubuntu.com/ubuntu"
            break
        fi
    done
    clear
    cat > /mnt/etc/apt/sources.list <<EOF
deb ${use_mirror} ${release} main restricted universe multiverse
deb ${use_mirror} ${release}-updates main restricted universe multiverse
deb ${security_mirror} ${release}-security main restricted universe multiverse
EOF
    echo "==> sources.list für ${release} erstellt (Mirror: ${use_mirror})"
    chroot /mnt apt update
}

pkg_base() {
    clear
    local pkgs="linux-generic efibootmgr sudo network-manager"

    # Filesystem-Tools nur wenn nötig
    if [ "$root_fs" = "btrfs" ] || [ "$home_fs" = "btrfs" ]; then
        pkgs="$pkgs btrfs-progs"
    fi
    if [ "$root_fs" = "xfs" ] || [ "$home_fs" = "xfs" ]; then
        pkgs="$pkgs xfsprogs"
    fi

    echo "==> Installiere: $pkgs"
    chroot /mnt apt install -y $pkgs
    echo "==> Regeneriere initramfs..."
    chroot /mnt update-initramfs -u -k all
    pressanykey
}

pkg_desktop() {
    local options=()
    options+=("kde-plasma-desktop" "KDE Plasma (minimal, kein Bloat)")
    options+=("gnome-shell"        "GNOME (minimal, kein Bloat)")
    options+=("mate-desktop"       "MATE Desktop (minimal, kein Bloat)")
    options+=("tde-trinity"        "TDE Trinity Desktop (KDE 3.5 Fork)")

    local sel
    sel=$(dialog --backtitle "$apptitle" --title "$T_DESKTOP_TITLE" \
        --cancel-button "$T_BACK" \
        --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return
    clear

    if [ "$sel" = "gnome-shell" ]; then
        local lang_code="${locale_val%%_*}"
        local gnome_pkgs="gnome-shell gnome-session gdm3 gnome-terminal nautilus gnome-text-editor file-roller gnome-calculator gnome-disk-utility gnome-screenshot eog gnome-tweaks gnome-shell-extension-manager fonts-noto gstreamer1.0-plugins-good gstreamer1.0-plugins-base gstreamer1.0-alsa gstreamer1.0-pulseaudio gstreamer1.0-libav gstreamer1.0-vaapi gnome-system-monitor language-pack-gnome-${lang_code} language-pack-gnome-${lang_code}-base"
        local gnome_bloat="yelp* yaru-theme-gnome-shell"
        chroot /mnt apt install -y $gnome_pkgs
        dialog --backtitle "$apptitle" --title "$T_GNOME_BLOAT_TITLE" \
            --yesno "$T_GNOME_BLOAT_MSG\n\n${gnome_bloat}" 0 0
        if [ "$?" = "0" ]; then
            clear
            chroot /mnt apt purge -y --ignore-missing $gnome_bloat
            chroot /mnt apt autoremove -y
            echo "==> Fertig!"
        fi
    elif [ "$sel" = "kde-plasma-desktop" ]; then
        local kde_pkgs="kde-plasma-desktop sddm-theme-breeze ark gwenview kcalc"
        local kde_bloat="plasma-discover plasma-discover-backend-snap plasma-discover-notifier plasma-discover-backend-fwupd plasma-discover-common kwalletmanager partitionmanager khelpcenter plasma-thunderbolt plasma-vault plasma-browser-integration plasma-activities-bin plasma-disks kup-backup kde-inotify-survey budgie-sddm-theme qrca"
        chroot /mnt apt install -y $kde_pkgs
        grep -q "GTK_USE_PORTAL" /mnt/etc/environment 2>/dev/null || \
            echo "GTK_USE_PORTAL=1" >> /mnt/etc/environment
        dialog --backtitle "$apptitle" --title "$T_KDE_BLOAT_TITLE" \
            --yesno "$T_KDE_BLOAT_MSG\n\n${kde_bloat}" 0 0
        if [ "$?" = "0" ]; then
            clear
            chroot /mnt apt purge -y --ignore-missing $kde_bloat
            chroot /mnt apt autoremove -y
            echo "==> Fertig!"
        fi
    elif [ "$sel" = "mate-desktop" ]; then
        local mate_pkgs="mate-session-manager mate-utils engrampa pluma mate-terminal mate-calc mate-system-monitor mate-control-center mate-themes mate-media mate-power-manager pipewire-pulse mate-tweak debian-mate-default-settings fonts-noto xdg-desktop-portal-gtk gstreamer1.0-plugins-good gstreamer1.0-plugins-base gstreamer1.0-alsa gstreamer1.0-pulseaudio gstreamer1.0-libav gstreamer1.0-vaapi slick-greeter"
        chroot /mnt apt install -y --no-install-recommends mate-panel
        chroot /mnt apt install -y $mate_pkgs
        # slick-greeter als Standard-Greeter setzen
        sed -i 's/^#greeter-session=.*/greeter-session=slick-greeter/' /mnt/etc/lightdm/lightdm.conf
        grep -q "^greeter-session=" /mnt/etc/lightdm/lightdm.conf || \
            sed -i '/^\[Seat:\*\]/a greeter-session=slick-greeter' /mnt/etc/lightdm/lightdm.conf
    elif [ "$sel" = "tde-trinity" ]; then
        local lang_code="${locale_val%%_*}"
        local tde_lang="$lang_code"
        [ "$locale_val" = "en_GB" ] && tde_lang="engb"

        echo "==> Füge Trinity Desktop Keyring hinzu..."
        chroot /mnt /bin/bash -c "wget -q -O /tmp/trinity-keyring.deb http://mirror.ppa.trinitydesktop.org/trinity/deb/trinity-keyring.deb && dpkg -i /tmp/trinity-keyring.deb"

        echo "==> Füge Trinity Desktop Repository hinzu..."
        cat > /mnt/etc/apt/sources.list.d/trinity.list <<EOF
deb http://mirror.ppa.trinitydesktop.org/trinity/deb/trinity-r14.1.x ${UBUNTU_RELEASE} main deps
deb-src http://mirror.ppa.trinitydesktop.org/trinity/deb/trinity-r14.1.x ${UBUNTU_RELEASE} main deps
EOF

        chroot /mnt apt update
        echo "==> Installiere TDE Trinity Desktop..."
        chroot /mnt apt install -y tdebase-trinity gtk-qt-engine-trinity gtk3-tqt-engine-trinity gstreamer1.0-plugins-good gstreamer1.0-plugins-base gstreamer1.0-alsa gstreamer1.0-pulseaudio gstreamer1.0-libav gstreamer1.0-vaapi pipewire-pulse kmix-trinity kcalc-trinity ark-trinity kolourpaint-trinity kgtk-qt3-trinity
        chroot /mnt apt install -y --no-install-recommends gwenview-trinity gwenview-i18n-trinity

        if [ -n "$tde_lang" ] && [ "$tde_lang" != "en" ]; then
            echo "==> Installiere TDE Sprachpaket: tde-i18n-${tde_lang}-trinity..."
            chroot /mnt apt install -y "tde-i18n-${tde_lang}-trinity" 2>/dev/null || \
                echo "Hinweis: tde-i18n-${tde_lang}-trinity nicht verfügbar."
        fi

        local tde_bloat="alacritty kregexpeditor-trinity"
        dialog --backtitle "$apptitle" --title "TDE Bloat" \
            --yesno "Unnötige TDE Pakete entfernen?\n\n${tde_bloat}" 0 0
        if [ "$?" = "0" ]; then
            clear
            chroot /mnt apt purge -y --ignore-missing $tde_bloat
            chroot /mnt apt autoremove -y
            echo "==> Fertig!"
        fi
    else
        chroot /mnt apt install -y "$sel" sddm-theme-breeze
        grep -q "GTK_USE_PORTAL" /mnt/etc/environment 2>/dev/null || \
            echo "GTK_USE_PORTAL=1" >> /mnt/etc/environment
    fi

    pressanykey
}

pkg_i386() {
    clear
    echo "==> Aktiviere i386 Architektur..."
    chroot /mnt dpkg --add-architecture i386
    chroot /mnt apt update
    echo "==> 32-Bit Support aktiviert!"
    pressanykey
}

pkg_bootscreen() {
    clear
    echo "==> Installiere Plymouth..."
    chroot /mnt apt install -y plymouth plymouth-themes

    echo "==> Konfiguriere Plymouth Theme (bgrt)..."
    mkdir -p /mnt/etc/plymouth
    cat > /mnt/etc/plymouth/plymouthd.conf << 'PLEOF'
[Daemon]
Theme=bgrt
ShowDelay=0
DeviceTimeout=8
PLEOF

    echo "==> Setze kernel cmdline für Bootscreen..."
    mkdir -p /mnt/etc/kernel
    local current=""
    [ -f /mnt/etc/kernel/cmdline ] && current=$(cat /mnt/etc/kernel/cmdline)
    # Plymouth-Optionen ergänzen falls noch nicht vorhanden
    local plymouth_opts="quiet splash loglevel=0 rd.udev.log_priority=0 vt.global_cursor_default=0"
    # quiet/splash aus bestehender cmdline entfernen und neu setzen
    current=$(echo "$current" | sed 's/quiet//g; s/splash//g' | xargs)
    echo "${current} ${plymouth_opts}" | xargs > /mnt/etc/kernel/cmdline

    echo "==> Regeneriere initramfs..."
    chroot /mnt update-initramfs -u -k all

    echo "==> Fertig!"
    pressanykey
}

pkg_extras() {
    local options=()
    options+=("vim"              "" off)
    options+=("nano"             "" off)
    options+=("git"              "" off)
    options+=("curl"             "" off)
    options+=("wget"             "" off)
    options+=("htop"             "" off)
    options+=("bash-completion"  "" off)
    options+=("fastfetch"        "" off)
    options+=("openssh-server"   "" off)

    local sel
    sel=$(dialog --backtitle "$apptitle" --title "Extras" \
        --checklist "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return
    [ -z "$sel" ] && return
    clear
    local pkgs
    pkgs=$(echo "$sel" | tr -d '"')
    chroot /mnt apt install -y $pkgs
    pressanykey
}


pkg_programmes() {
    local options=()
    options+=("firefox"          "Firefox (ohne Snap, Mozilla PPA)" on)
    options+=("thunderbird"      "Thunderbird (ohne Snap, Mozilla PPA)" on)
    options+=("google-chrome"    "Google Chrome (Google Repo)" off)
    options+=("google-earth"     "Google Earth Pro (Google Repo)" off)
    options+=("spotify"          "Spotify (Spotify Repo)" off)

    local sel
    sel=$(dialog --backtitle "$apptitle" --title "$T_PKG_PROGRAMMES" \
        --checklist "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return
    [ -z "$sel" ] && return

    clear

    # Mozilla PPA (Firefox / Thunderbird)
    if echo "$sel" | grep -qE "firefox|thunderbird"; then
        echo "==> Installiere software-properties-common..."
        chroot /mnt apt install -y software-properties-common
        echo "==> Füge Mozilla PPA hinzu..."
        chroot /mnt add-apt-repository -y ppa:mozillateam/ppa

        if echo "$sel" | grep -q "firefox"; then
            echo "==> Setze Firefox Pin..."
            cat > /mnt/etc/apt/preferences.d/mozilla-firefox << 'EOF'
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox
Pin: version 1:1snap*
Pin-Priority: -1
EOF
            chroot /mnt apt install -y firefox
        fi

        if echo "$sel" | grep -q "thunderbird"; then
            echo "==> Setze Thunderbird Pin..."
            cat > /mnt/etc/apt/preferences.d/thunderbird << 'EOF'
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: thunderbird
Pin: version 2:1snap*
Pin-Priority: -1
EOF
            chroot /mnt apt install -y thunderbird
            local tb_lang="${locale_val%%_*}"
            if [ -n "$tb_lang" ] && [ "$tb_lang" != "en" ]; then
                echo "==> Installiere Thunderbird Language Pack: thunderbird-locale-${tb_lang}..."
                chroot /mnt apt install -y "thunderbird-locale-${tb_lang}" 2>/dev/null || \
                    echo "Hinweis: thunderbird-locale-${tb_lang} nicht verfügbar."
            fi
        fi
    fi

    # Externe Repos (Chrome, Earth, Spotify) — einmaliger Bestätigungs-Dialog
    local want_chrome=0 want_earth=0 want_spotify=0
    echo "$sel" | grep -q "google-chrome" && want_chrome=1
    echo "$sel" | grep -q "google-earth"  && want_earth=1
    echo "$sel" | grep -q "spotify"       && want_spotify=1

    if [ "$want_chrome" = "1" ] || [ "$want_earth" = "1" ] || [ "$want_spotify" = "1" ]; then
        local extrepo_list=""
        [ "$want_chrome"  = "1" ] && extrepo_list="${extrepo_list}- Google Chrome (dl.google.com)\n"
        [ "$want_earth"   = "1" ] && extrepo_list="${extrepo_list}- Google Earth Pro (dl.google.com)\n"
        [ "$want_spotify" = "1" ] && extrepo_list="${extrepo_list}- Spotify (repository.spotify.com)\n"

        dialog --backtitle "$apptitle" --title "Externe Repos" \
            --yesno "$(printf "$T_EXTREPO_CONFIRM" "$extrepo_list")" 0 0
        if [ "$?" = "0" ]; then
            if [ "$want_chrome" = "1" ] || [ "$want_earth" = "1" ]; then
                echo "==> Füge Google Signing Key hinzu..."
                chroot /mnt /bin/bash -c "wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | tee /etc/apt/trusted.gpg.d/google.asc >/dev/null"
            fi
            if [ "$want_chrome" = "1" ]; then
                echo "==> Füge Google Chrome Repo hinzu..."
                echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /mnt/etc/apt/sources.list.d/google-chrome.list
                echo "==> Installiere Google Chrome..."
                chroot /mnt apt update
                chroot /mnt apt install -y google-chrome-stable
            fi
            if [ "$want_earth" = "1" ]; then
                echo "==> Füge Google Earth Pro Repo hinzu..."
                printf "### THIS FILE IS AUTOMATICALLY CONFIGURED ###\n# You may comment out this entry, but any other modifications may be lost.\ndeb [arch=amd64] http://dl.google.com/linux/earth/deb/ stable main\n" > /mnt/etc/apt/sources.list.d/google-earth-pro.list
                echo "==> Installiere Google Earth Pro..."
                chroot /mnt apt update
                chroot /mnt apt install -y xdg-utils google-earth-pro-stable
            fi
            if [ "$want_spotify" = "1" ]; then
                echo "==> Füge Spotify Signing Key hinzu..."
                chroot /mnt /bin/bash -c "curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg"
                echo "==> Füge Spotify Repo hinzu..."
                echo "deb https://repository.spotify.com stable non-free" > /mnt/etc/apt/sources.list.d/spotify.list
                echo "==> Installiere Spotify..."
                chroot /mnt apt update
                chroot /mnt apt install -y spotify-client
            fi
        fi
    fi

    pressanykey
}


config_rootpw() {
    clear
    echo "==> Root-Passwort setzen:"
    chroot /mnt passwd root
    pressanykey
}

config_user() {
    local result
    result=$(dialog --backtitle "$apptitle" --title "Benutzer anlegen" \
        --inputbox "$T_USER_INPUT" 0 0 "" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return
    [ -z "$result" ] && return
    username_val="$result"
    clear
    chroot /mnt adduser "$username_val"
    chroot /mnt usermod -aG sudo "$username_val"
    pressanykey
}

config_nm() {
    clear
    chroot /mnt systemctl enable NetworkManager
    # Entferne "strictly unmanaged" Konfig die debootstrap hinterlässt
    rm -f /mnt/etc/NetworkManager/conf.d/10-globally-managed-devices.conf
    # Stelle sicher dass NM alle Interfaces verwaltet
    mkdir -p /mnt/etc/NetworkManager/conf.d
    printf "[keyfile]\nunmanaged-devices=none\n" > /mnt/etc/NetworkManager/conf.d/10-managed.conf
    echo "$T_NM_OK"
    pressanykey
}

# --------------------------------------------------------
# Bootloader
# --------------------------------------------------------

bootloadermenu() {
    local options=()
    if [ "${BOOT_MODE:-efi}" != "bios" ]; then
        options+=("systemd-boot"  "Recommended for EFI / Empfohlen für EFI")
        options+=("grub-efi"     "GRUB EFI")
    else
        options+=("grub-bios"    "GRUB BIOS/MBR")
    fi

    local sel
    sel=$(dialog --backtitle "$apptitle" --title "$T_BOOTLOADER_TITLE" \
        --cancel-button "$T_BACK" \
        --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
    [ "$?" != "0" ] && return

    case $sel in
        "systemd-boot") bootloader_systemd;;
        "grub-efi")     bootloader_grub_efi;;
        "grub-bios")    bootloader_grub_bios;;
    esac
}

bootloader_systemd() {
    local uuid_root
    uuid_root=$(blkid -s UUID -o value "$root_part")

    dialog --backtitle "$apptitle" --title "systemd-boot" \
        --yesno "$(printf "$T_SDB_CONFIRM" "$uuid_root")" 0 0
    [ "$?" != "0" ] && return

    clear
    echo "==> Entferne GRUB vollständig..."
    chroot /mnt apt-get purge -y grub-efi-amd64 grub-efi-amd64-bin grub-efi-amd64-signed         grub-common grub2-common grub-pc grub-pc-bin 2>/dev/null
    chroot /mnt apt-get autoremove -y 2>/dev/null
    rm -rf /mnt/boot/grub 2>/dev/null
    rm -rf /mnt/boot/efi/EFI/ubuntu 2>/dev/null

    echo "==> Blockiere GRUB/Shim Dependencies..."
    cat > /mnt/etc/apt/preferences.d/no-grub << 'EOF'
Package: grub-efi-amd64 grub-efi-amd64-bin grub-efi-amd64-signed grub-efi-amd64-unsigned grub2-common grub-common grub-pc grub-pc-bin shim-signed secureboot-db mokutil os-prober sbsigntool
Pin: release *
Pin-Priority: -1
EOF

    echo "==> Installiere systemd-boot + initramfs-tools + btrfs-progs..."
    chroot /mnt apt install -y --no-install-recommends systemd-boot systemd-boot-tools initramfs-tools btrfs-progs

    echo "==> Entferne GRUB Block wieder..."
    rm -f /mnt/etc/apt/preferences.d/no-grub

    echo "==> Setze kernel cmdline..."
    mkdir -p /mnt/etc/kernel
    # Bestehende cmdline lesen (z.B. von pkg_bootscreen) und root= ergänzen
    local existing=""
    [ -f /mnt/etc/kernel/cmdline ] && existing=$(cat /mnt/etc/kernel/cmdline)
    existing=$(echo "$existing" | sed 's/root=[^ ]*//g; s/rootflags=[^ ]*//g' | xargs)
    local root_opts="root=UUID=${uuid_root} rw"
    # Subvolume @ direkt auf der Partition prüfen (unabhängig von USE_SUBVOLS)
    if [ "$root_fs" = "btrfs" ]; then
        local tmp_check=$(mktemp -d)
        mount "$root_part" "$tmp_check" 2>/dev/null
        if btrfs subvolume list "$tmp_check" 2>/dev/null | grep -q "path @$"; then
            root_opts="root=UUID=${uuid_root} rootflags=subvol=@ rw"
        fi
        umount "$tmp_check" 2>/dev/null
        rmdir "$tmp_check" 2>/dev/null
    fi
    echo "${root_opts} ${existing}" | xargs > /mnt/etc/kernel/cmdline
    echo "==> cmdline: $(cat /mnt/etc/kernel/cmdline)"

    echo "==> Regeneriere initramfs..."
    chroot /mnt update-initramfs -u -k all

    echo "==> Installiere systemd-boot in EFI..."
    chroot /mnt bootctl install

    echo "==> Generiere Boot-Eintrag..."
    local kernel
    kernel=$(ls /mnt/boot/vmlinuz-* 2>/dev/null | head -1 | xargs basename | sed 's/vmlinuz-//')
    if [ -n "$kernel" ]; then
        chroot /mnt kernel-install add "$kernel" "/boot/vmlinuz-${kernel}"
        echo ""
        echo "Boot-Eintrag:"
        cat /mnt/boot/efi/loader/entries/*.conf 2>/dev/null
    else
        echo "$T_NO_KERNEL"
    fi
    pressanykey
}

bootloader_grub_efi() {
    clear
    echo "==> Stelle sicher dass btrfs-progs und initramfs-tools installiert sind..."
    chroot /mnt apt install -y btrfs-progs initramfs-tools
    echo "==> Regeneriere initramfs..."
    chroot /mnt update-initramfs -u -k all
    echo "==> Installiere GRUB EFI..."
    chroot /mnt apt install -y grub-efi-amd64
    chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu
    chroot /mnt update-grub
    pressanykey
}

bootloader_grub_bios() {
    local disk
    disk=$(selectdisk "$T_DISK_SELECT_GRUB")
    [ "$?" != "0" ] && return
    clear
    echo "==> Stelle sicher dass btrfs-progs und initramfs-tools installiert sind..."
    chroot /mnt apt install -y btrfs-progs initramfs-tools
    echo "==> Regeneriere initramfs..."
    chroot /mnt update-initramfs -u -k all
    echo "==> Installiere GRUB BIOS auf ${disk}..."
    chroot /mnt apt install -y grub-pc
    chroot /mnt grub-install --target=i386-pc "$disk"
    chroot /mnt update-grub
    pressanykey
}

# --------------------------------------------------------
# Netzwerk-Setup (vor dem Hauptmenü)
# --------------------------------------------------------

net_wait_dhcp() {
    # Wartet bis zu 10 Sekunden auf eine IP auf dem Interface $1
    local iface="$1"
    local i=0
    while [ $i -lt 10 ]; do
        if ip addr show "$iface" 2>/dev/null | grep -q "inet "; then
            return 0
        fi
        sleep 1
        i=$((i+1))
    done
    return 1
}

net_connect_wifi() {
    while true; do
        clear
        local ssid pw
        ssid=$(dialog --backtitle "$apptitle" --title "$T_NET_TITLE" \
            --inputbox "$T_NET_SSID" 0 0 "" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && return 1

        pw=$(dialog --backtitle "$apptitle" --title "$T_NET_TITLE" \
            --insecure --passwordbox "$T_NET_PW" 0 0 "" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && return 1

        clear
        printf "$T_NET_CONNECTING\n" "$ssid"
        if nmcli device wifi connect "$ssid" password "$pw" 2>&1; then
            echo "$T_NET_OK"
            sleep 1
            return 0
        else
            dialog --backtitle "$apptitle" --title "$T_NET_TITLE" \
                --defaultno --yesno "$T_NET_FAIL" 0 0
            [ "$?" != "0" ] && return 1
            # Ja = nochmal versuchen → Schleife läuft weiter
        fi
    done
}

net_connect_lan() {
    clear
    echo "$T_NET_CHECK"

    # NM-Autoconnect für alle Ethernet-Interfaces sicherstellen
    mkdir -p /etc/NetworkManager/conf.d
    cat > /etc/NetworkManager/conf.d/10-auto-ethernet.conf << 'EOF'
[main]
no-auto-default=
EOF

    # NM neu starten falls noch nicht aktiv
    if ! systemctl is-active --quiet NetworkManager; then
        systemctl start NetworkManager 2>/dev/null
    fi
    sleep 2

    # Alle Ethernet-Interfaces explizit hochbringen
    for iface in $(ip -o link show | awk -F': ' '$2 !~ /^lo$/ {print $2}'); do
        local type
        type=$(cat /sys/class/net/"$iface"/type 2>/dev/null)
        # type 1 = Ethernet
        [ "$type" = "1" ] || continue
        echo "  --> $iface hochbringen..."
        ip link set "$iface" up 2>/dev/null
        nmcli device connect "$iface" 2>/dev/null
    done

    # Bis zu 30 Sekunden auf eine IP warten
    local waited=0
    local iface ip
    while [ $waited -lt 30 ]; do
        iface=$(ip route show default 2>/dev/null | awk 'NR==1{print $5}')
        ip=$(ip addr show "$iface" 2>/dev/null | awk '/inet / {print $2; exit}')
        if [ -n "$ip" ]; then
            printf "$T_NET_LAN_OK\n" "$iface: $ip"
            sleep 1
            return 0
        fi
        sleep 1
        waited=$((waited + 1))
        echo "  warte... ${waited}s"
    done

    echo "$T_NET_LAN_FAIL"
    sleep 2
    return 1
}

networkmenu() {
    while true; do
        local options=()
        options+=("$T_NET_LAN"  "$T_NET_LAN_DESC")
        options+=("$T_NET_WIFI" "$T_NET_WIFI_DESC")
        options+=("$T_NET_SKIP" "$T_NET_SKIP_DESC")

        local sel
        sel=$(dialog --backtitle "$apptitle" --title "$T_NET_TITLE" \
            --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
        [ "$?" != "0" ] && return

        case $sel in
            "$T_NET_LAN")
                net_connect_lan && return
                ;;
            "$T_NET_WIFI")
                net_connect_wifi && return
                ;;
            "$T_NET_SKIP")
                return
                ;;
        esac
    done
}



remountmenu() {
    # Partitionen auswählen (Defaults aus detect_mounted oder vorheriger Session)
    local p
    p=$(selectpartition "$T_PART_ROOT" "${root_part:-none}")
    [ "$?" != "0" ] && return
    [ "$p" = "none" ] || [ -z "$p" ] && return
    root_part="$p"
    root_fs=$(blkid -s TYPE -o value "$root_part" 2>/dev/null)

    p=$(selectpartition "$T_PART_EFI" "${efi_part:-none}")
    [ "$?" != "0" ] && return
    [ "$p" = "none" ] && efi_part="" || efi_part="$p"

    p=$(selectpartition "$T_PART_HOME" "${home_part:-none}")
    [ "$?" != "0" ] && return
    [ "$p" = "none" ] && home_part="" || home_part="$p"
    [ -n "$home_part" ] && home_fs=$(blkid -s TYPE -o value "$home_part" 2>/dev/null)

    clear
    # Bereits eingehängte /mnt Mounts sauber entfernen
    chroot_cleanup 2>/dev/null
    umount -R /mnt 2>/dev/null

    echo "==> Hänge Root ein: ${root_part} (${root_fs})"
    if [ "$root_fs" = "btrfs" ]; then
        local tmp_check
        tmp_check=$(mktemp -d)
        mount "$root_part" "$tmp_check" 2>/dev/null
        local has_at=0
        btrfs subvolume list "$tmp_check" 2>/dev/null | grep -q "path @$" && has_at=1
        umount "$tmp_check" 2>/dev/null
        rmdir "$tmp_check" 2>/dev/null
        if [ "$has_at" = "1" ]; then
            mount -o defaults,compress=zstd,subvol=@ "$root_part" /mnt
            USE_SUBVOLS=1
        else
            mount "$root_part" /mnt
            USE_SUBVOLS=0
        fi
    else
        mount "$root_part" /mnt
    fi

    if [ -n "$home_part" ]; then
        echo "==> Hänge Home ein: ${home_part} (${home_fs})"
        mkdir -p /mnt/home
        if [ "$home_fs" = "btrfs" ]; then
            local tmp_home
            tmp_home=$(mktemp -d)
            mount "$home_part" "$tmp_home" 2>/dev/null
            local has_home=0
            btrfs subvolume list "$tmp_home" 2>/dev/null | grep -q "path @home$" && has_home=1
            umount "$tmp_home" 2>/dev/null
            rmdir "$tmp_home" 2>/dev/null
            if [ "$has_home" = "1" ]; then
                mount -o defaults,compress=zstd,subvol=@home "$home_part" /mnt/home
            else
                mount "$home_part" /mnt/home
            fi
        else
            mount "$home_part" /mnt/home
        fi
    fi

    if [ -n "$efi_part" ]; then
        echo "==> Hänge EFI ein: ${efi_part}"
        mkdir -p /mnt/boot/efi
        mount "$efi_part" /mnt/boot/efi
        BOOT_MODE="efi"
    fi

    # UBUNTU_RELEASE und UBUNTU_MIRROR aus installiertem System lesen
    if [ -z "$UBUNTU_RELEASE" ] && [ -f /mnt/etc/apt/sources.list ]; then
        UBUNTU_RELEASE=$(grep -m1 "^deb " /mnt/etc/apt/sources.list 2>/dev/null | awk '{print $3}')
        UBUNTU_MIRROR=$(grep -m1 "^deb " /mnt/etc/apt/sources.list 2>/dev/null | awk '{print $2}')
    fi
    # Hostname lesen
    [ -f /mnt/etc/hostname ] && hostname_val=$(cat /mnt/etc/hostname)
    # Locale lesen
    if [ -f /mnt/etc/default/locale ]; then
        local lv
        lv=$(grep "^LANG=" /mnt/etc/default/locale | cut -d= -f2 | cut -d. -f1)
        [ -n "$lv" ] && locale_val="$lv"
    fi

    chroot_prepare

    echo ""
    echo "==> Eingehängt:"
    lsblk
    echo ""
    echo "Release : ${UBUNTU_RELEASE:-unbekannt}"
    echo "Mirror  : ${UBUNTU_MIRROR:-unbekannt}"
    echo "Hostname: ${hostname_val}"
    pressanykey
}

rebootmenu() {
    dialog --backtitle "$apptitle" --title "Reboot" \
        --defaultno --yesno "$T_REBOOT_CONFIRM" 0 0
    [ "$?" != "0" ] && return
    clear
    echo "==> Hänge alles aus..."
    chroot_cleanup
    umount -R /mnt
    reboot
}

# --------------------------------------------------------
# Start
# --------------------------------------------------------

if [ "$EUID" -ne 0 ]; then
    echo "Fehler: ubfi muss als root ausgeführt werden!"
    echo "Bitte starte mit: sudo bash ubfi.sh"
    exit 1
fi

trap 'clear; echo "==> Unterbrochen, räume auf..."; chroot_cleanup 2>/dev/null; exit 1' INT TERM

echo "Initialisiere ubfi, bitte warten..."
if ! command -v dialog >/dev/null 2>&1 || ! command -v debootstrap >/dev/null 2>&1; then
    apt-get update -qq
    apt-get install -y dialog debootstrap
fi

# Standardsprache setzen (wird im Hauptmenü änderbar)
set_language

# Fehlende debootstrap-Scripts für neue/beta Releases nachladen
for release_script in resolute questing; do
    if [ ! -f "/usr/share/debootstrap/scripts/${release_script}" ]; then
        echo "==> debootstrap-Script fuer ${release_script} fehlt, erstelle Fallback..."
        if [ -f "/usr/share/debootstrap/scripts/noble" ]; then
            cp /usr/share/debootstrap/scripts/noble \
               /usr/share/debootstrap/scripts/${release_script}
        elif [ -f "/usr/share/debootstrap/scripts/jammy" ]; then
            cp /usr/share/debootstrap/scripts/jammy \
               /usr/share/debootstrap/scripts/${release_script}
        else
            echo "WARNUNG: Kein Fallback-Script gefunden fuer ${release_script}!"
        fi
        echo "==> Script fuer ${release_script} erstellt."
    fi
done

clear
networkmenu
clear
mainmenu
