#!/bin/bash
# skapar användare med mappar och en välkomstfil
# kör såhär: sudo ./create_users.sh Anna Bjorn Charlie

# måste vara root för att köra detta
if [ "$EUID" -ne 0 ]
then
    echo "du måste vara root, kör med sudo"
    exit 1
fi

# kollar att man skrivit in minst ett namn
if [ "$#" -eq 0 ]
then
    echo "skriv in namn såhär: ./create_users.sh Anna Bjorn"
    exit 1
fi

# första loopen - skapar alla användare och mappar
for USERNAME in "$@"
do
    # skapa användaren (ingen skip)
    useradd -m -s /bin/bash "$USERNAME" 2>/dev/null

    # skapar mapparna (safe)
    mkdir -p /home/$USERNAME/Documents
    mkdir -p /home/$USERNAME/Downloads
    mkdir -p /home/$USERNAME/Work

    # sätter rättigheter
    chmod 700 /home/$USERNAME/Documents
    chmod 700 /home/$USERNAME/Downloads
    chmod 700 /home/$USERNAME/Work

    # sätter rätt ägare
    chown -R $USERNAME:$USERNAME /home/$USERNAME

done

# andra loopen - skapar välkomstfiler
for USERNAME in "$@"
do
    echo "Välkommen $USERNAME" > /home/$USERNAME/welcome.txt
    echo "" >> /home/$USERNAME/welcome.txt
    echo "Andra användare på systemet:" >> /home/$USERNAME/welcome.txt

    while IFS=: read -r NAME PASS UID_NUM REST
    do
        if [ "$NAME" != "$USERNAME" ]
        then
            echo "$NAME" >> /home/$USERNAME/welcome.txt
        fi
    done < /etc/passwd

    chown $USERNAME:$USERNAME /home/$USERNAME/welcome.txt
done

echo "klart!"
