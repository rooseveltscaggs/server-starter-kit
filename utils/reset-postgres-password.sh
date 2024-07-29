#!/bin/bash
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

echo "----- Postgres Password Reset -----"
echo " "

echo -n "Username: (Press ENTER for postgres user): "
read pg_user

# If user did not enter a password, generate a random one
if [[ -z "$pg_user" ]]; then
  pg_user="postgres"
fi

echo -n "New database password (Press ENTER for a random password to be generated): "
read -s admin_password

# If user did not enter a password, generate a random one
if [[ -z "$admin_password" ]]; then
  admin_password=$(openssl rand -base64 12)
fi

sudo -u postgres psql -c "ALTER USER $pg_user WITH PASSWORD '$admin_password';"

echo " "
echo "Password reset complete!"
echo "You can use the following credentials to access the database: "
echo " "
echo "Database username: $pg_user"
echo "Database password: $admin_password"