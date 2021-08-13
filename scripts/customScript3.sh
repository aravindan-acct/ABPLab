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
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get -y update

#PHP and dependencies
sudo apt -y install php7.4
sudo apt-get install -y php7.4-{bcmath,bz2,intl,gd,mbstring,mysql,zip,common,dom,curl,soap}

# Modify the php.ini file


sudo systemctl restart apache2

# MySQL Server
sudo  apt-get -y install php7.4-mysql git
sudo apt install -y wget
wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
echo "fc84b8954141ed3c59ac7a1adfc8051c93171bae7ba34d7f9aeecd3b148f1527 mariadb_repo_setup" \
    | sha256sum -c -
chmod +x mariadb_repo_setup
sudo ./mariadb_repo_setup \
   --mariadb-server-version="mariadb-10.2"

export PASSWORD=TiUtpgDKlbVJpXpaADrTiSfhkphDznym
export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $PASSWORD" 

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
# edit apache2.conf file to allow override all