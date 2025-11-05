#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

SELECTED_FILE=$(zenity --file-selection \
    --title="Duvar Kağıdı Seçin" \
    --filename="$WALLPAPER_DIR/" \
    --file-filter="Görsel Dosyaları | *.jpg *.jpeg *.png *.webp"
)

if [[ -n "$SELECTED_FILE" ]]; then
    FULL_PATH="$SELECTED_FILE" # Zenity tam yolu verir
    
    CURRENT_WALL=$(hyprctl hyprpaper listloaded | awk -F', ' '{print $2}' | head -n 1)

    hyprctl hyprpaper preload "$FULL_PATH"
    hyprctl hyprpaper wallpaper ",$FULL_PATH"
    
    if [[ -n "$CURRENT_WALL" ]]; then
        hyprctl hyprpaper unload "$CURRENT_WALL"
    fi
    
    echo "Duvar kağıdı ayarlandı: $FULL_PATH"
else
    echo "Seçim iptal edildi."
fi
