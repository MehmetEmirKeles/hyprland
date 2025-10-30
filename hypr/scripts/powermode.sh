#!/bin/bash

# ==========================================================
# GÜÇ PROFİLİ SEÇİM SCRIPT'İ
# Waybar'daki custom/power modülü tarafından çağrılır.
# powerprofilesctl (modern Linux dağıtımları için) kullanır.
# ==========================================================

# 1. Mevcut Güç Profilini Bulma
CURRENT_PROFILE=$(powerprofilesctl get)

# 2. Wofi (veya Yad) ile Menüyü Oluşturma
SELECTION=$(echo -e "Performance\nBalanced\nPower Saving" | wofi --dmenu \
    --prompt "Güç Modu Seç (Aktif: $CURRENT_PROFILE)" \
    --lines 3 \
    --width 300 \
    --height 150 \
    --columns 1)

# Eğer Wofi/Yad kurulu değilse, yukarıdaki satırı bu şekilde güncelleyin:
# SELECTION=$(echo -e "Performance\nBalanced\nPower Saving" | dmenu -p "Güç Modu Seç (Aktif: $CURRENT_PROFILE)")


# 3. Seçime Göre Güç Profilini Ayarlama
case "$SELECTION" in
    "Performance")
        powerprofilesctl set performance
        # Kullanıcıya bildirim gönder (Hyprland ortamı için 'notify-send' kullanılır)
        notify-send "Güç Modu Değişti" "Mod: Yüksek Performans (CPU Limitleri Kaldırıldı)" -i "system-run"
        ;;
    "Balanced")
        powerprofilesctl set balanced
        notify-send "Güç Modu Değişti" "Mod: Dengeli (Normal Kullanım)" -i "system-run"
        ;;
    "Power Saving")
        powerprofilesctl set power-saver
        notify-send "Güç Modu Değişti" "Mod: Güç Tasarrufu (Pil Ömrü Uzatıldı)" -i "system-run"
        ;;
    *)
        # Seçim yapılmazsa veya ESC tuşuna basılırsa bir şey yapma
        exit 0
        ;;
esac

exit 0
