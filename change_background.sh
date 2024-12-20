#!/bin/bash

# Ask for permission to change the background
read -p "Do you want to change the background to the specified image? (y/n): " permission

if [ "$permission" != "y" ]; then
    echo "Permission denied. Exiting..."
    exit 1
fi

# Download the image
image_url="https://m.media-amazon.com/images/I/7142W-rWKyL._AC_UF1000,1000_QL80_.jpg"
image_path="$HOME/Downloads/background.jpg"
curl -o "$image_path" "$image_url"

# Open the image to see what it is
open "$image_path"

# Ask for confirmation to change the background
read -p "Do you want to set this image as your background? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "Background change cancelled. Exiting..."
    exit 1
fi

# Change the desktop background
osascript -e "tell application \"System Events\" to set picture of every desktop to \"$image_path\""

echo "Background changed successfully."
