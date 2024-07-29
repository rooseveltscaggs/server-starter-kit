#!/bin/bash
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

echo "----- Postgres Auto Installer -----"
echo " "
echo "This installer: "
echo " * Opens port 5432"
echo " * Sets all addresses as listen addresses"
echo " * Generates a random password / sets specified admin password" 
echo " * Enables Postgres network authentication"
echo " "

echo -n "Set database password (Press ENTER for a random password to be generated): "
read admin_password

# If user did not enter a password, generate a random one
if [[ -z "$admin_password" ]]; then
  admin_password=$(openssl rand -base64 12)
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
USER=$(whoami)
# Example: /Users/rscaggs/git/anti-hero
WORKDIR=$(pwd)
old_text="TEXTDIR"
old_listen_address="#listen_addresses = 'localhost'"
new_listen_address="listen_addresses = '*'"
sudo apt update
sudo apt -y install postgresql postgresql-contrib
sudo systemctl start postgresql.service
cd /var/lib/postgresql


sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$admin_password';"
sudo ufw allow 5432/tcp

PG_DIR=$(find /etc/postgresql/ -maxdepth 1 -name "?[0-9]" -type d | head -1)
sudo sed -i "s|$old_listen_address|$new_listen_address|" "$PG_DIR/main/postgresql.conf"
sudo cp -rf "$SCRIPT_DIR/pg_hba.conf" $PG_DIR/main/pg_hba.conf
sudo service postgresql restart

echo " "
echo "Installation complete!"
echo "You can use the following credentials to access the database: "
echo " "
echo "Database username: postgres"
echo "Database password: $admin_password"