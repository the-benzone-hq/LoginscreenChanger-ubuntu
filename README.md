# Loginscreen changer - GDM Wallpaper Changer

A simple bash script to set a custom wallpaper on the **GDM (GNOME Display Manager) login screen** on Ubuntu systems — no `machinectl` required.

## How It Works

GDM runs as its own isolated user (`gdm`) and cannot read files from your home directory. This script works around that by:

1. Copying your image to `/usr/share/backgrounds/gdm/` — a system path GDM can access.
2. Writing wallpaper settings directly into the **system dconf database**, bypassing the need for an active DBus session or `machinectl`.

## Requirements

- Ubuntu (tested on Ubuntu 20.04+)
- GNOME Display Manager (GDM3)
- `sudo` privileges
- `dconf` (pre-installed on Ubuntu with GNOME)

## Installation

```bash
# Clone or download the script, then make it executable
chmod +x change.sh
```

## Usage

```bash
sudo ./change.sh /path/to/your/image.jpg
```

**Example:**

```bash
sudo ./change.sh ~/Pictures/my-wallpaper.png
```

Supported image formats: `.jpg`, `.jpeg`, `.png`, `.webp`, and other formats supported by GNOME.

## What the Script Does

```bash
#!/bin/bash
sudo mkdir -p /usr/share/backgrounds/gdm
sudo cp "$1" /usr/share/backgrounds/gdm/gdm-wallpaper

# Create dconf profile for gdm
sudo mkdir -p /etc/dconf/profile
echo -e "user-db:user\nsystem-db:gdm" | sudo tee /etc/dconf/profile/gdm

# Create the dconf keyfile
sudo mkdir -p /etc/dconf/db/gdm.d
sudo tee /etc/dconf/db/gdm.d/01-wallpaper << EOF
[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/gdm/gdm-wallpaper'
picture-options='zoom'

[com/ubuntu/login-screen]
background-picture-uri='file:///usr/share/backgrounds/gdm/gdm-wallpaper'
background-size='cover'
EOF

# Apply the changes
sudo dconf update
```

| Step | Description |
|------|-------------|
| `mkdir -p /usr/share/backgrounds/gdm` | Creates the target directory if it doesn't exist |
| `cp "$1" ...` | Copies your image to a GDM-accessible path |
| `/etc/dconf/profile/gdm` | Tells GDM to load settings from the system dconf database |
| `/etc/dconf/db/gdm.d/01-wallpaper` | Keyfile containing the wallpaper settings |
| `dconf update` | Compiles the keyfile into the binary dconf database |

## Changing the Wallpaper Again

Simply run the script again with a new image. The file is always copied to the same path (`gdm-wallpaper`), so no cleanup is needed.

```bash
sudo ./change.sh /path/to/new-image.jpg
```

## Reverting to Default

To remove the custom wallpaper and restore GDM defaults:

```bash
sudo rm /etc/dconf/db/gdm.d/01-wallpaper
sudo rm /etc/dconf/profile/gdm
sudo dconf update
```

## Troubleshooting

**Changes not showing up after running the script?**
- Make sure you ran `sudo dconf update` — the script does this automatically, but it's worth confirming there were no errors.
- Log out and back in, or reboot to see the GDM login screen.

**Image looks stretched or cropped?**
- Change `picture-options` in the script from `zoom` to `scaled`, `stretched`, `centered`, or `wallpaper` depending on your preference.

**Script fails with "command not found: dconf"?**
- Install it with: `sudo apt install dconf-cli`


## License

MIT — do whatever you want with it.
