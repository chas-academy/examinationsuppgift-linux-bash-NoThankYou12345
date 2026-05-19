#!/bin/bash

# kollar admin
if [ "$UID" != 0 ]; then 
    echo "måste vara root"
    exit 1
fi

# hämtar users
existing_users=$(cut -d: -f1 /etc/passwd)

# loop
for användare in "$@"
do  
    useradd -m "$användare" 2>/dev/null

    # rätt namn + -p
    mkdir -p /home/$användare/Documents
    mkdir -p /home/$användare/Downloads
    mkdir -p /home/$användare/Work

    # rättigheter
    chmod 700 /home/$användare/Documents
    chmod 700 /home/$användare/Downloads
    chmod 700 /home/$användare/Work

    # korrekt welcome
    echo "Välkommen $användare" > /home/$användare/welcome.txt
    echo "" >> /home/$användare/welcome.txt
    echo "Andra användare på systemet:" >> /home/$användare/welcome.txt
    echo "$existing_users" >> /home/$användare/welcome.txt

    # viktigt
    chown -R $användare:$användare /home/$användare

    echo "$användare klar"
done
