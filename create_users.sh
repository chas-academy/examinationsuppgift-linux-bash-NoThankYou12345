#!/bin/bash

# kolla root
if [ "$EUID" -ne 0 ]; then
  echo "Måste köras som root"
  exit 1
fi

# kolla argument
if [ "$#" -eq 0 ]; then
  echo "Användning: $0 användare..."
  exit 1
fi

# hämta befintliga användare
existing_users=$(cut -d: -f1 /etc/passwd)

for username in "$@"; do

  # skapa användare + hemkatalog
  useradd -m "$username"

  # hemkatalog (enkelt, inget krångel)
  home_dir="/home/$username"

  # skapa mappar
  mkdir "$home_dir/Documents"
  mkdir "$home_dir/Downloads"
  mkdir "$home_dir/Work"

  # rättigheter
  chown -R "$username:$username" "$home_dir"
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
