#!/bin/bash

# root check
if [ "$EUID" -ne 0 ]; then
    exit 1
fi

# om inga användare anges
if [ "$#" -eq 0 ]; then
    echo "ange minst en användare"
    exit 1
fi

# befintliga användare
existing_users=$(cut -d: -f1 /etc/passwd)

for username in "$@"
do
    useradd -m "$username" 2>/dev/null

    home="/home/$username"

    mkdir -p "$home/Documents"
    mkdir -p "$home/Downloads"
    mkdir -p "$home/Work"

    chmod 700 "$home/Documents"
    chmod 700 "$home/Downloads"
    chmod 700 "$home/Work"

    echo "Välkommen $username" > "$home/welcome.txt"
    echo "" >> "$home/welcome.txt"
    echo "Andra användare på systemet:" >> "$home/welcome.txt"
    echo "$existing_users" >> "$home/welcome.txt"

    chown -R "$username:$username" "$home"
done
