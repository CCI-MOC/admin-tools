#! /bin/bash

set -e

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$#" -ne 2 ]; then
    echo "Run this as ./create-account.sh PROJECT USER"
    exit 1
fi

su -l $USERNAME
exit

if [ ! -f "/home/$USERNAME/.bashrc" ]; then
    echo "The home directory or bashrc does not exist"
    exit 1
fi

PROJECT=$1
USERNAME=$2
PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)
NETWORK="bmi-pro"

hil project list-networks $PROJECT || (echo "Creating project" && hil project create $PROJECT)
hil user create $USERNAME $PASSWORD regular
hil user project add $USERNAME $PROJECT
hil network grant-access $NETWORK $PROJECT
bmi project create $PROJECT


echo "export HIL_USERNAME=$USERNAME" >> /home/$USERNAME/.bashrc
echo "export HIL_PASSWORD=$PASSWORD" >> /home/$USERNAME/.bashrc
echo "echo 'Your HIL project is $PROJECT. You can remove this message from your bashrc'" >> /home/$USERNAME/.bash_profile
echo "Done"

exit 0
