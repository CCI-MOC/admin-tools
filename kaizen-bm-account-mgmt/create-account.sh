#! /bin/bash

set -ex

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$#" -ne 2 ]; then
    echo "Run this as ./create-account.sh PROJECT USER"
    exit 1
fi

USERNAME=$2
echo $USERNAME

PROJECT=$1
PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)
echo $PASSWORD
NETWORK="bmi-pro"

hil project list-networks $PROJECT || (echo "Creating project" && hil project create $PROJECT)
hil user create $USERNAME $PASSWORD regular
hil user project add $USERNAME $PROJECT
hil network grant-access $NETWORK $PROJECT || true
sudo -E bmi project create $PROJECT


echo "export HIL_USERNAME=$USERNAME" |sudo tee -a /home/$USERNAME/.bashrc
echo "export HIL_PASSWORD=$PASSWORD" |sudo tee -a  /home/$USERNAME/.bashrc
echo "echo 'Your HIL project is $PROJECT. You can remove this message from your bashrc'" |sudo tee -a /home/$USERNAME/.bashrc
echo "Done"

exit 0
