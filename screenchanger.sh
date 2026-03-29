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
