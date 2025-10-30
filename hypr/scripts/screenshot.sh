#!/bin/bash

SAVE_DIR="$HOME/Pictures/Screenshots"

FILENAME="$(date +'%Y-%m-%d_%H-%M-%S').png"

mkdir -p "$SAVE_DIR"

FULL_PATH="$SAVE_DIR/$FILENAME"

grim -g "$(slurp)" "$FULL_PATH"

notify-send "📸 Ekran Görüntüsü Alındı" "Kaydedildi:\n$FILENAME"
