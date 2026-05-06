<h2>Ubuntu Fast Installer (ubfi)</h2>

<p>
  Ubuntu used to offer a minimal ISO that worked similar to Debian. This option was dropped years ago,
  and today the only real alternative is the Server ISO. Unfortunately, it does not properly support
  language packs. You can download and install them, but the system does not apply them correctly.
</p>

<p>
  I even submitted a ticket to Ubuntu, but the issue was never addressed. Because of that, I decided
  to build my own installation tool.
</p>

<p>
  <strong>ubfi</strong> is based on <strong>Archfi (Arch Fast Installer)</strong> and works in a similar way,
  but with options made specifically for Ubuntu. It supports a wide range of Ubuntu versions, from EOL
  releases up to <strong>26.04</strong>.
</p>

<p>
  You can also choose which bootloader to install, and optionally install <strong>Firefox</strong> and
  <strong>Thunderbird</strong> as <strong>.deb packages</strong> instead of using Snap.
</p>

<h3>Features</h3>

<ul>
  <li>Network setup at boot, LAN (auto DHCP) or WiFi (SSID + password)</li>
  <li>Choose your Ubuntu version, 14.04 LTS up to 26.04</li>
  <li>Partitioning, GPT/BIOS auto or manual via <strong>cfdisk / fdisk</strong></li>
  <li>Filesystem support: <strong>btrfs, ext4, ext3, ext2, xfs</strong></li>
  <li>Installs via <strong>debootstrap</strong> directly from your chosen mirror</li>
  <li>Automatically sets up locale and language packs</li>
  <li>Desktop options: <strong>KDE Plasma</strong>, <strong>GNOME</strong>, or <strong>none</strong></li>
  <li>You can choose to use systemd-boot or GRUB as your default bootloader</li>
  <li>Optional Firefox / Thunderbird installation as <strong>.deb</strong> (no Snap required)</li>
  <li>🇩🇪 Deutsch / 🇬🇧 English</li>
</ul>
