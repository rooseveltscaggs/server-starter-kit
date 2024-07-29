#!/bin/bash
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

echo "----- Docker User Promo -----"
echo " "

echo -n "Username: (Press ENTER for current user): "
read user

# If user did not enter a password, generate a random one
if [[ -z "$user" ]]; then
  user=$(whoami)
fi

sudo usermod -aG docker ${user}

echo "Promotion complete!"
echo "Log out and log back in to update permissions"
echo "Run:  su - $user"