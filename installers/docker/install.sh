#!/bin/bash
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

echo "----- Docker Auto Installer -----"

sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

apt-cache policy docker-ce

sudo apt install docker-ce

echo "Docker has been installed!"

user=$(whoami)
echo -n "Add current user ($user) to Docker group? [Y/n]"
read promote

# If user did not enter a password, generate a random one
if [ ${promote,,} == "y" ]; then
    user=$(whoami)
    sudo usermod -aG docker ${user}
    echo "Promotion complete!"
    echo "Log out and log back in to update permissions"
    echo "Run:  su - $user"
fi

