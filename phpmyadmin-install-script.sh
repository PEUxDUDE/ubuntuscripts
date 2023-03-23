#!/bin/bash

# Update the system package lists
sudo apt update

# Install Apache, PHP, MySQL, and the PHP MySQL extension
sudo apt install apache2 php mysql-server php-mysql -y

# Download the latest version of phpMyAdmin from the official website
cd /tmp
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.tar.gz

# Extract the downloaded archive and move the contents to the Apache web root directory
tar xf phpMyAdmin-5.1.1-all-languages.tar.gz
sudo mv phpMyAdmin-5.1.1-all-languages /var/www/html/phpmyadmin

# Set up the necessary permissions for phpMyAdmin
sudo chown -R www-data:www-data /var/www/html/phpmyadmin
sudo chmod -R 755 /var/www/html/phpmyadmin

# Create a new Apache configuration file for phpMyAdmin
sudo tee /etc/apache2/conf-available/phpmyadmin.conf > /dev/null <<EOF
Alias /phpmyadmin /var/www/html/phpmyadmin

<Directory /var/www/html/phpmyadmin>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride all
    Require all granted
</Directory>
EOF

# Enable the new configuration and restart Apache
sudo a2enconf phpmyadmin
sudo systemctl restart apache2

# Output a message indicating that phpMyAdmin has been installed
echo "phpMyAdmin has been installed. You can access it by going to http://localhost/phpmyadmin in your web browser."
