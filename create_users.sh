#!/bin/bash

# kollar root
if [ "$EUID" -ne 0 ]; then
  echo "Måste köras som root"
  exit 1
fi

# om inga argument skickas
if [ "$#" -eq 0 ]; then
  users=("user1" "user2")
else
  users=("$@")
fi

# befintliga användare
existing_users=$(cut -d: -f1 /etc/passwd)

for username in "${users[@]}"; do

  # skapa användare
  id "$username" &>/dev/null || useradd -m "$username" 2>/dev/null

  # hemkatalog
  home_dir=$(getent passwd "$username" | cut -d: -f6)

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
