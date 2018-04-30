#!/bin/bash

cd /usr/local/bin

sudo wget -O /usr/local/bin/gnomeshell-extension-manage "https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/ubuntugnome/gnomeshell-extension-manage"

sudo chmod +x /usr/local/bin/gnomeshell-extension-manage

xargs -a gnome-extensions.txt sudo gnomeshell-extension-manage --install --extension-id % --system

rm -f gnome-extensions.txt

rm -f wrapper-gnome-extensions.sh
