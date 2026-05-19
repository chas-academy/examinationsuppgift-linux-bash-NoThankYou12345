#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Detta skript måste köras som root."
    exit 1
fi

# Kontrollera argument
if [ "$#" -eq 0 ]; then
    echo "Användning: $0 användare1 [användare2 ...]"
    exit 1
fi

# Loopar igenom användare
for user in "$@"; do

    # Skapa användare (ta bort skip-logik)
    useradd -m "$user" 2>/dev/null

    home="/home/$user"

    # Skapa mappar
    mkdir -p "$home/Documents"
    mkdir -p "$home/Downloads"
    mkdir -p "$home/Work"

    # Rättigheter
    chmod 700 "$home/Documents"
    chmod 700 "$home/Downloads"
    chmod 700 "$home/Work"

    # Welcome-fil
    echo "Välkommen $user" > "$home/welcome.txt"
    echo "Andra användare på systemet:" >> "$home/welcome.txt"
    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> "$home/welcome.txt"

    # Sätt ägare
    chown "$user:$user" "$home/welcome.txt"
    chown "$user:$user" "$home/Documents" "$home/Downloads" "$home/Work"

done

echo "Klart"
