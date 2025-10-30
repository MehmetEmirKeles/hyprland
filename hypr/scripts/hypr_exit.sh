#!/bin/bash
# hyprlock uygulamasını arka planda başlatır
hyprlock &
# Kilit ekranının çizilmesi için 1 saniye bekler
sleep 1
# Sistemi systemd aracılığıyla askıya alır
systemctl suspend
