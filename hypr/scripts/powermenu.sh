#!/usr/bin/env bash

# wofi ile power menüsü oluştur
OPTIONS="shutdown\nreboot\nsuspend\nlock\nlogout"
CHOICE=$(echo -e "$OPTIONS" | fuzzel -d -p "Power:")

case "$CHOICE" in
    shutdown)
        systemctl poweroff
        ;;
    reboot)
        systemctl reboot
        ;;
    suspend)
        systemctl suspend
        ;;
    lock)
        # Eğer slurp ve grim kurulu ise:
        # slurp | grim -g - ~/Pictures/Screenshots/$(date +%s).png
        # VEYA lockscreen uygulamanız:
        exec swaylock 
        ;;
    logout)
        hyprctl dispatch exit
        ;;
esac
