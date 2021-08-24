#!/bin/bash
#
# installs the important programs that I user

if command -v pacman &> /dev/null
then
   sudo pacman -S yay
   pacaur -S rofi pscircle

   # flutter and dart sdk
   git clone https://github.com/flutter/flutter.git ~/tools/flutter
   flutter doctor
   flutter channel beta
   flutter upgrade
   flutter config --enable-web

   systemctl --user daemon-reload
   # pscircle
   systemctl --user enable pscircle.service
   systemctl --user start pscircle.service
fi
