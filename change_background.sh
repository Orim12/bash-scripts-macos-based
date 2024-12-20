#!/bin/bash

# Ask for permission to change the background
read -p "Do you want to change the background to the specified image? (y/n): " permission

if [ "$permission" != "y" ]; then
    echo "Permission denied. Exiting..."
    exit 1
fi

# Download the image
image_url="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTp1ragbkK9hB77RPraPErKgBT7wHNjOhMkXyx_jXUf4WVSHs7NKcVqU1zIVDDQaMQzG8s&usqp=CAU"
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
