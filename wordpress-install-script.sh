#!/bin/bash

# Update Ubuntu
sudo apt update
sudo apt upgrade -y

# Install LAMP stack
sudo apt-get install lamp-server^ -y

# Prompt user for MySQL root password
read -p "Enter MySQL root password: " mysql_root_password

# Prompt user for database name, username, and password
read -p "Enter database name: " db_name
read -p "Enter database username: " db_user
read -s -p "Enter database password: " db_password

# Create database and user
sudo mysql -u root -p$mysql_root_password <<EOF
CREATE DATABASE $db_name;
CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_password';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download and extract WordPress
read -p "Enter website name (no spaces or special characters): " website_name
sudo wget -P /tmp https://wordpress.org/latest-nl_NL.tar.gz
sudo tar -zxvf /tmp/latest-nl_NL.tar.gz -C /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo mv /var/www/html/wordpress /var/www/html/$website_name

# Create website configuration file
cat << EOF | sudo tee /etc/apache2/sites-available/$website_name.conf > /dev/null
<VirtualHost *:80>
    ServerName $website_name
    DocumentRoot /var/www/html/$website_name
    <Directory /var/www/html/$website_name>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Enable website and reload Apache
sudo a2ensite $website_name.conf
sudo systemctl reload apache2

echo "LAMP stack installation and WordPress setup completed successfully!"
