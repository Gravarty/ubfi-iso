Ubuntu Fast Installer
Ubuntu used to offer a minimal ISO that worked similar to Debian. This option was dropped years ago, and today the only real alternative is the Server ISO. Unfortunately, it does not properly support language packs. You can download and install them, but the system often does not apply them correctly.
I even submitted a ticket to Ubuntu, but the issue was never addressed. Because of that, I decided to build my own installation tool.
ubfi is based on Archfi (Arch Fast Installer) and works in a similar way, but with options made for Ubuntu. It supports a wide range of Ubuntu versions, from EOL releases up to 26.04.
You can also choose which bootloader to install, and optionally install Firefox and Thunderbird as .deb packages instead of using Snap.

Features

Network setup at boot — LAN (auto DHCP) or WiFi (SSID + password)
Choose your Ubuntu version — 22.04 LTS up to 26.04
Partition: GPT/BIOS auto or manual via cfdisk / fdisk
Filesystem: btrfs, ext4, ext3, ext2, xfs
Installs via debootstrap directly from your chosen mirror
Locale + language packs configured correctly from day one
Desktop: KDE Plasma, GNOME, or none
GRUB bootloader included
🇩🇪 Deutsch / 🇬🇧 English

