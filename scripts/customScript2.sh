#! /bin/bash


# install Apache2
sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2

sudo touch magento.conf
sudo mv magento.conf /etc/apache2/sites-available/magento.conf

# Apache virtual host
{
    sudo cat > /etc/apache2/sites-available/magento.conf <<EOF
    {
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
    }
EOF
  }

# Rewrite mod
sudo a2ensite magento.conf

sudo a2enmod rewrite


#PHP and dependencies
sudo apt install -y php7.2 libapache2-mod-php7.2 php7.2-common php7.2-gmp php7.2-curl php7.2-soap php7.2-bcmath php7.2-intl php7.2-mbstring php7.2-xmlrpc php7.2-mcrypt php7.2-mysql php7.2-gd php7.2-xml php7.2-cli php7.2-zip

# Modify the php.ini file


sudo systemctl restart apache2

# MySQL Server

sudo apt install -y mariadb-server

$db_user = "labuser"
$db_password = "P@ssw0rd@123"
$db_name = "magento"

# DB existance check
$db_exists=$(mysql -u $db_user -p $db_password -e "SHOW DATABASES LIKE '"$db_name"';" | grep "$db_name" > /dev/null; echo "$?")
if [ $db_exists -eq 0 ];then
    echo "A database with the name $db_name already exists"
    exit
else
     echo "Creating database $db_name."
fi

# Creating user and password for db 
mysql -u $db_user -p$db_password -e "create database $db_name;"
echo "Database $db_name created"
mysql -u $db_user -p$db_password -e "CREATE USER $db_user@'localhost' IDENTIFIED BY $db_password;"
mysql -u $db_user -p$db_password -e "GRANT ALL PRIVILEGES ON * . * TO $db_user@'localhost';"
mysql -u $db_user -p$db_password -e "FLUSH PRIVILEGES;"
mysql -u $db_user -p$db_password -e "exit;"


# Installing composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/bin/ --filename=composer


: << 'END'
{
            "name": "[concat(variables('servername'), '/customScript1')]",
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2019-07-01",
            "location": "[resourceGroup().location]",
            "tags": {
                "displayName": "customScript1 for Magento VM"
            },
            "dependsOn": [
                "[resourceId('Microsoft.Compute/virtualMachines', variables('servername'))]"
            ],
            "properties": {
                "publisher": "Microsoft.Azure.Extensions",
                "type": "CustomScript",
                "typeHandlerVersion": "2.1",
                "autoUpgradeMinorVersion": true,
                "settings": {
                    "fileUris": [
                        "https://raw.githubusercontent.com/aravindan-acct/ABPLab/main/scripts/customScript2.sh"
                    ]
                },
                "protectedSettings": {
                    "commandToExecute": "nohup bash customScript2.sh"
                }
            }
        }
END