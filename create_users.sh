#!/bin/bash

# kollar root
if [ "$EUID" -ne 0 ]; then
  echo "Måste köras som root"
  exit 1
fi

# kollar argument
if [ "$#" -eq 0 ]; then
  echo "Användning: $0 användare..."
  exit 1
fi

# befintliga användare
existing_users=$(cut -d: -f1 /etc/passwd)

for username in "$@"; do

  # skapa användare
  id "$username" &>/dev/null || useradd -m "$username"

  # FIX: sätt hemkatalog direkt
  home_dir="/home/$username"

  # skapa mappar
  mkdir -p "$home_dir/Documents"
  mkdir -p "$home_dir/Downloads"
  mkdir -p "$home_dir/Work"

  # rättigheter
  chown -R "$username:$username" "$home_dir"
  chmod 700 "$home_dir/Documents"
  chmod 700 "$home_dir/Downloads"
  chmod 700 "$home_dir/Work"

  # welcome
  echo "Välkommen $username" > "$home_dir/welcome.txt"
  echo "" >> "$home_dir/welcome.txt"
  echo "Andra användare på systemet:" >> "$home_dir/welcome.txt"
  echo "$existing_users" >> "$home_dir/welcome.txt"

  chown "$username:$username" "$home_dir/welcome.txt"

done

echo "klart"
