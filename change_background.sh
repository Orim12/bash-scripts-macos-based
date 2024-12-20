#!/bin/bash

# Functie om de achtergrond in te stellen
set_background() {
    local image_path="$1"

    # Gebruik AppleScript om de desktopachtergrond in te stellen
    osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$image_path\""
}

# Download de afbeelding naar een tijdelijke locatie
TEMP_FILE="/tmp/macos_new_background.jpg"
IMAGE_URL="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTp1ragbkK9hB77RPraPErKgBT7wHNjOhMkXyx_jXUf4WVSHs7NKcVqU1zIVDDQaMQzG8s&usqp=CAU"

echo "De afbeelding wordt gedownload vanaf: $IMAGE_URL"
curl -o "$TEMP_FILE" "$IMAGE_URL" --fail
if [ $? -ne 0 ]; then
    echo "Fout: Kon de afbeelding niet downloaden. Controleer de URL."
    exit 1
fi

# Toon de afbeelding voor goedkeuring
echo "De afbeelding wordt geopend ter preview. Bevestig of je deze wilt gebruiken."
open "$TEMP_FILE"

# Vraag om goedkeuring van de gebruiker
while true; do
    read -p "Wil je deze afbeelding instellen als bureaubladachtergrond? (Y/N): " RESPONSE
    case "$RESPONSE" in
        Y)
            set_background "$TEMP_FILE"
            echo "Bureaubladachtergrond is succesvol bijgewerkt!"
            break
            ;;
        N)
            echo "Bewerking geannuleerd. De achtergrond is niet gewijzigd."
            break
            ;;
        *)
            echo "Ongeldige invoer. Typ 'Y' voor ja of 'N' voor nee."
            ;;
    esac
done

# Verwijder tijdelijke bestanden
rm "$TEMP_FILE"
