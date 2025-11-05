#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
CONFIG_DEST="$HOME/.config"
PICS_DEST=$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")

mkdir -p "$CONFIG_DEST"

CONFIG_FOLDERS=(
    "hypr"
    "kitty"
    "waybar"
    "gtklock"
)

for folder in "${CONFIG_FOLDERS[@]}"; do
    SOURCE_PATH="$SCRIPT_DIR/$folder"
    DEST_PATH="$CONFIG_DEST/$folder"
    
    if [ -d "$SOURCE_PATH" ]; then
        
        if [ -d "$DEST_PATH" ] || [ -L "$DEST_PATH" ]; then
            mv "$DEST_PATH" "$DEST_PATH.bak" || { echo "HATA: Yedekleme basarisiz: $DEST_PATH"; exit 1; }
        fi
        
        cp -r "$SOURCE_PATH" "$CONFIG_DEST/"
    fi
done

PICS_SOURCE="$SCRIPT_DIR/pictures"

if [ -d "$PICS_SOURCE" ]; then
    mkdir -p "$PICS_DEST"
    cp -rn "$PICS_SOURCE"/* "$PICS_DEST/"
fi
