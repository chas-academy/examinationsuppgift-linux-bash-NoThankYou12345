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

# sparar befintliga användare
existing_users=$(cut -d: -f1 /etc/passwd)

for username in "$@"; do

  # skapa användare (fixad rad)
  id "$username" &>/dev/null || useradd -m "$username"

  # hämta hemkatalog (fixad rad)
  home_dir=$(getent passwd "$username" | cut -d: -f6)

  # skapa mappar
  mkdir -p "$home_dir/Documents"
  mkdir -p "$home_dir/Downloads"
  mkdir -p "$home_dir/Work"

  # sätt ägare
  chown -R "$username:$username" "$home_dir"

  # rättigheter
  chmod 700 "$home_dir/Documents"
  chmod 700 "$home_dir/Downloads"
  chmod 700 "$home_dir/Work"

  # welcome-fil
  echo "Välkommen $username" > "$home_dir/welcome.txt"
  echo "" >> "$home_dir/welcome.txt"
  echo "Andra användare på systemet:" >> "$home_dir/welcome.txt"
  echo "$existing_users" >> "$home_dir/welcome.txt"

  chown "$username:$username" "$home_dir/welcome.txt"

done

echo "klart"
