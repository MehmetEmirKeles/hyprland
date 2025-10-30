#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# 1. Zenity ile görsel önizlemeli dosya seçiciyi aç
# --file-selection: Dosya seçme modu
# --filename="$WALLPAPER_DIR": Başlangıç dizinini ayarla
# --title="Duvar Kağıdı Seçin": Pencere başlığı
SELECTED_FILE=$(zenity --file-selection \
    --title="Duvar Kağıdı Seçin" \
    --filename="$WALLPAPER_DIR/" \
    --file-filter="Görsel Dosyaları | *.jpg *.jpeg *.png *.webp"
)

# Eğer bir seçim yapıldıysa
if [[ -n "$SELECTED_FILE" ]]; then
    FULL_PATH="$SELECTED_FILE" # Zenity tam yolu verir
    
    # 2. Eski duvar kağıdını bul
    CURRENT_WALL=$(hyprctl hyprpaper listloaded | awk -F', ' '{print $2}' | head -n 1)

    # 3. Yeni duvar kağıdını ayarla
    hyprctl hyprpaper preload "$FULL_PATH"
    hyprctl hyprpaper wallpaper ",$FULL_PATH"
    
    # 4. Eski duvar kağıdını bellekten boşalt (opsiyonel)
    if [[ -n "$CURRENT_WALL" ]]; then
        hyprctl hyprpaper unload "$CURRENT_WALL"
    fi
    
    echo "Duvar kağıdı ayarlandı: $FULL_PATH"
else
    echo "Seçim iptal edildi."
fi
