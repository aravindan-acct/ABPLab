#! /bin/bash


# install Apache2
sudo apt-get -y update
sudo apt install -y apache2
sudo apt install -y unzip
sudo systemctl start apache2
sudo systemctl enable apache2

touch magento.conf

# Apache virtual host - Not working
cat > magento.conf <<EOF

<VirtualHost *:80>
  ServerAdmin admin@domain.com
  DocumentRoot /var/www/html/magento/
  ServerName domain.com
  ServerAlias www.domain.com

  <Directory /var/www/html/magento/>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    allow from all
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/magento_error.log
  CustomLog ${APACHE_LOG_DIR}/magento_access.log combined
  </VirtualHost>

EOF


sudo cp magento.conf /etc/apache2/sites-available/magento.conf

# Rewrite mod
sudo a2ensite magento.conf

sudo a2enmod rewrite

sudo systemctl restart apache2

sudo apt-get -y update
sudo apt -y install software-properties-common
#sudo add-apt-repository -y ppa:ondrej/php
#sudo apt-get -y update

#PHP and dependencies
sudo apt -y install php7.2
sudo apt-get install -y php7.2-{bcmath,bz2,intl,gd,mbstring,mysql,zip,common,dom,curl,soap}

# Modify the php.ini file


sudo systemctl restart apache2

# MySQL Server

sudo apt install -y mariadb-server

sudo systemctl enable mariadb
sudo systemctl start  mariadb
sudo mysqladmin -u root password TiUtpgDKlbVJpXpaADrTiSfhkphDznym
sudo mysql -u root --password=TiUtpgDKlbVJpXpaADrTiSfhkphDznym -e "quit"


# Creating user and password for db 
sudo mysql -u root --password=TiUtpgDKlbVJpXpaADrTiSfhkphDznym  -e  "CREATE DATABASE magentodb; CREATE USER 'wafdemodbuser'@'localhost' IDENTIFIED BY 'h6d7GEujNYW06idiNG1qaeuemqZWzZyO';  GRANT ALL ON magentodb.* TO  wafdemodbuser@localhost; FLUSH PRIVILEGES;"

# Installing composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/bin/ --filename=composer

echo "LAMP and  Composer Installed. Exiting."