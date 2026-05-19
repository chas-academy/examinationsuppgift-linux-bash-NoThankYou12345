#!/bin/bash

# Kollar så scriptet körs som root
if [ "$EUID" -ne 0 ]; then
  echo "Måste köras som root"
  exit 1
fi

# Kollar att man skickar in minst en användare
if [ "$#" -eq 0 ]; then
  echo "Användning: $0 användare..."
  exit 1
fi

# Sparar alla befintliga användare
existing_users=$(cut -d: -f1 /etc/passwd)

# Loopar igenom alla användare som skickas in
for username in "$@"; do

  # Skapar användaren + hemkatalog
  useradd -m "$username" 2>/dev/null

  # Hämtar hemkatalogen
  home_dir=$(eval echo "~$username")

  # Skapar mappar
  mkdir -p "$home_dir/Documents"
  mkdir -p "$home_dir/Downloads"
  mkdir -p "$home_dir/Work"

  # Sätter rätt ägare
  chown -R "$username:$username" "$home_dir"

  # Sätter rättigheter (bara ägaren)
  chmod 700 "$home_dir/Documents"
  chmod 700 "$home_dir/Downloads"
  chmod 700 "$home_dir/Work"

  # Skapar welcome.txt
  welcome_file="$home_dir/welcome.txt"

  echo "Välkommen $username" > "$welcome_file"
  echo "" >> "$welcome_file"
  echo "Andra användare på systemet:" >> "$welcome_file"
  echo "$existing_users" >> "$welcome_file"

  # Sätter rätt ägare på filen också
  chown "$username:$username" "$welcome_file"

done

echo "klart"
