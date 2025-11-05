
LOGO_DIR"$HOME/.config/logos"
WAYBAR_DIR="$HOME/.config/waybar"
KITTY_DIR="$HOME/.config/kitty"
FISH_DIR="$HOME/.config/fish"

LOGO_DIR="$HOME/.config/logos"
THEMES=("def" "red" "pink" "blue" "black" "yellow")

MENU_DATA=""
for theme in "${THEMES[@]}"; do
    LOGO_FILE="$LOGO_DIR/${theme}.png" 
    
    MENU_DATA+="$theme\0icon\x1f$LOGO_FILE\n"
done

CHOSEN_THEME=$(echo -e "$MENU_DATA" | fuzzel --dmenu --prompt "Tema Seçin:")

#CHOSEN_THEME=$(printf "%s\n" "${THEMES[@]}" | fuzzel --dmenu --prompt "Tema Seçin:")

if [ -z "$CHOSEN_THEME" ]; then
    exit 0
fi

THEME_EXT="-$CHOSEN_THEME" 

LOG_FILE="/tmp/theme_switcher_log.txt"
echo "Seçilen tema uzantısı: $THEME_EXT" > "$LOG_FILE"


WAYBAR_SOURCE_FILE="$WAYBAR_DIR/style.css$THEME_EXT"
if cp -f "$WAYBAR_SOURCE_FILE" "$WAYBAR_DIR/style.css"; then
    echo "Waybar güncellendi: $WAYBAR_SOURCE_FILE" >> "$LOG_FILE"
else

    echo "HATA: Waybar dosyası bulunamadı VEYA KOPYALANAMADI: $WAYBAR_SOURCE_FILE" >> "$LOG_FILE"
fi

KITTY_SOURCE_FILE=$(find "$KITTY_DIR" -maxdepth 1 -type f -name "kitty.conf$THEME_EXT*" -print -quit)

if [ -f "$KITTY_SOURCE_FILE" ]; then
    if cp -f "$KITTY_SOURCE_FILE" "$KITTY_DIR/kitty.conf"; then
        echo "Kitty güncellendi: $KITTY_SOURCE_FILE" >> "$LOG_FILE"
    else
        echo "HATA: Kitty kopyalanamadı." >> "$LOG_FILE"
    fi
else
    echo "HATA: Kitty dosyası bulunamadı: $KITTY_DIR/kitty.conf$THEME_EXT" >> "$LOG_FILE"
fi

FISH_SOURCE_FILE="$FISH_DIR/config.fish$THEME_EXT"
if cp -f "$FISH_SOURCE_FILE" "$FISH_DIR/config.fish"; then
    echo "Fish güncellendi." >> "$LOG_FILE"
else
    echo "HATA: Fish dosyası bulunamadı: $FISH_DIR/config.fish$THEME_EXT" >> "$LOG_FILE"
fi


killall -q waybar
sleep 0.3
waybar & 

echo "Başarıyla $CHOSEN_THEME temasına geçildi." >> "$LOG_FILE"



WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

FILE_ROOT="$WALLPAPER_DIR/$CHOSEN_THEME"
FILE_ROOT_UPPER="$WALLPAPER_DIR/${CHOSEN_THEME^}" # Black teması için (eğer gerekirse)

if [ "$CHOSEN_THEME" == "black" ]; then

    FINAL_WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f -name "[Bb]lack.*" -print -quit)
else
    # Diğer temalar için (pink, red, blue)
    FINAL_WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f -name "$CHOSEN_THEME.*" -print -quit)
fi

echo "Duvar kağıdı aranıyor: $FINAL_WALLPAPER" >> "$LOG_FILE"

if [ -f "$FINAL_WALLPAPER" ]; then

    hyprctl hyprpaper preload "$FINAL_WALLPAPER"
    hyprctl hyprpaper wallpaper "eDP-1,$FINAL_WALLPAPER"
    hyprctl hyprpaper wallpaper "HDMI-A-1,$FINAL_WALLPAPER"

    echo "Wallpaper güncellendi." >> "$LOG_FILE"
else
    echo "HATA: Wallpaper dosyası bulunamadı: $FINAL_WALLPAPER" >> "$LOG_FILE"

fi
