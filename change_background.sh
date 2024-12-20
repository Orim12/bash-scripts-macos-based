#!/bin/bash

# Functie om de achtergrond in te stellen
set_background() {
    local image_path="$1"

    # Gebruik AppleScript om de desktopachtergrond in te stellen
    osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$image_path\""
}

# Controleer of een URL of bestandslocatie is opgegeven
if [ "$#" -ne 1 ]; then
    echo "Gebruik: $0 <url-of-pad-naar-afbeelding>"
    exit 1
fi

INPUT="$1"
TEMP_FILE="/tmp/macos_new_background.jpg"

# Controleer of het een URL is
if [[ "$INPUT" =~ ^https?:// ]]; then
    echo "De afbeelding wordt gedownload vanaf: $INPUT"
    
    # Download de afbeelding
    curl -o "$TEMP_FILE" "$INPUT" --fail
    if [ $? -ne 0 ]; then
        echo "Fout: Kon de afbeelding niet downloaden. Controleer de URL."
        exit 1
    fi

    IMAGE_PATH="$TEMP_FILE"
else
    # Controleer of het een lokaal bestand is
    if [ ! -f "$INPUT" ]; then
        echo "Fout: Bestand '$INPUT' bestaat niet."
        exit 1
    fi

    IMAGE_PATH="$INPUT"
fi

# Toon de afbeelding voor goedkeuring
echo "De afbeelding wordt geopend ter preview. Bevestig of je deze wilt gebruiken."
open "$IMAGE_PATH"

# Vraag om goedkeuring van de gebruiker
while true; do
    read -p "Wil je deze afbeelding instellen als bureaubladachtergrond? (Y/N): " RESPONSE
    case "$RESPONSE" in
        Y)
            set_background "$IMAGE_PATH"
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

# Verwijder tijdelijke bestanden indien nodig
if [ "$IMAGE_PATH" == "$TEMP_FILE" ]; then
    rm "$TEMP_FILE"
fi

exit 0
