#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
  echo "Fel: Scriptet måste köras som root."
  exit 1
fi

# Kontrollera argument
if [ "$#" -eq 0 ]; then
  echo "Användning: $0 användare1 användare2 ..."
  exit 1
fi

# Hämta befintliga användare
existing_users=$(cut -d: -f1 /etc/passwd)

for username in "$@"; do

  useradd -m "$username" 2>/dev/null

  home_dir="/home/$username"

  mkdir -p "$home_dir/Documents"
  mkdir -p "$home_dir/Downloads"
  mkdir -p "$home_dir/Work"

  chown -R "$username:$username" "$home_dir"

  chmod 700 "$home_dir/Documents"
  chmod 700 "$home_dir/Downloads"
  chmod 700 "$home_dir/Work"

  welcome_file="$home_dir/welcome.txt"

  {
    echo "Välkommen $username"
    echo ""
    echo "Andra användare på systemet:"
    echo "$existing_users"
  } > "$welcome_file"

  chown "$username:$username" "$welcome_file"

done

echo "Klart."
