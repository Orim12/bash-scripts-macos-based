#!/bin/bash

# Functie om de achtergrond in te stellen
set_background() {
    local image_path="$1"

    # Controleer of de gebruiker toestemming moet geven
    echo "Toestemming kan nodig zijn om de achtergrond te wijzigen."
    osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$image_path\""
}

# Controleer of er voldoende argumenten zijn
if [ "$#" -lt 2 ]; then
    echo "Gebruik: $0 <url-of-pad-naar-afbeelding> <Y/N>"
    exit 1
fi

INPUT="$1"
APPROVAL="$2"
TEMP_FILE="/tmp/macos_new_background.jpg"

# Controleer of goedkeuring geldig is
if [[ "$APPROVAL" != "Y" && "$APPROVAL" != "N" ]]; then
    echo "Fout: Alleen 'Y' of 'N' is toegestaan als tweede parameter."
    exit 1
fi

# Controleer of het een URL is en download indien nodig
if [[ "$INPUT" =~ ^https?:// ]]; then
    echo "De afbeelding wordt gedownload vanaf: $INPUT"
    
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

# Stel de achtergrond in of annuleer op basis van goedkeuring
if [ "$APPROVAL" == "Y" ]; then
    set_background "$IMAGE_PATH"
    echo "Bureaubladachtergrond is succesvol bijgewerkt!"
else
    echo "Bewerking geannuleerd. De achtergrond is niet gewijzigd."
fi

# Verwijder tijdelijke bestanden indien nodig
if [ "$IMAGE_PATH" == "$TEMP_FILE" ]; then
    rm "$TEMP_FILE"
fi

exit 0
