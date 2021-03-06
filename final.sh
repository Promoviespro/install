mkdir /home/public_html/
yum update -y
yum -y install epel-release
yum -y update
yum -y install yum-utils wget nano screen net-tools nload zip unzip htop iotop lshw smartmontools hdparm cpuid dsniff nslookup iperf3 sysstat

yum -y groupinstall 'Development Tools'

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

yum -y install firewalld
systemctl enable firewalld.service
systemctl start firewalld.service
firewall-cmd --permanent --zone=public --add-service=http

firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --permanent --zone=public --add-service=mysql
firewall-cmd --permanent --add-service=ntp
firewall-cmd --permanent --zone=public --add-port=9749/tcp
firewall-cmd --reload


cd /etc/yum.repos.d/ && wget https://repo.b-cdn.net/mariadb-juicycodes.repo
cd ~ && yum -y install MariaDB-server MariaDB-client
rm -f /etc/my.cnf
wget https://raw.githubusercontent.com/Promoviespro/install/master/my.cnf -O /etc/my.cnf
systemctl enable mariadb.service
systemctl start mariadb.service
cd /etc/yum.repos.d/ && wget https://repo.b-cdn.net/nginx-juicycodes.repo
cd ~ && yum -y --disablerepo=epel --enablerepo=nginx install nginx

systemctl enable nginx.service
systemctl start nginx.service
yum -y install geoip geoip-devel

yum -y --disablerepo=epel --enablerepo=nginx install nginx-module-geoip nginx-module-geoip-debuginfo
chown -R nginx:nginx /home

yum erase epel-release -y
yum install epel-release -y
yum install openssl openssl-devel gcc make gcc-c++ libXpm-devel libedit-devel enchant-devel recode-devel libtidy-devel libzip-devel libxml2-devel gd-devel libzip5 libmcrypt-devel libc-client gd-last enca httpd httpd-devel autoconf automake -y

rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y update
yum-config-manager --enable remi-php70
yum install -y php-composer-ca-bundle
yum install php php-pear -y

yum  install -y php-PsrLog php-bcmath php-brotli php-cli php-common php-composer-ca-bundle php-composer-semver php-composer-spdx-licenses php-composer-xdebug-handler php-devel php-enchant php-fedora-autoloader php-fpm php-gd php-gmp php-google-recaptcha php-imap php-intl php-ioncube-loader php-json php-jsonlint php-justinrainbow-json-schema5 php-mbstring php-mcrypt php-mysqlnd php-paragonie-random-compat php-password-compat php-pdo php-pear php-pecl-zip php-phpmyadmin-motranslator php-phpmyadmin-shapefile php-phpmyadmin-sql-parser php-phpseclib php-process php-psr-container php-recode php-seld-phar-utils php-soap php-symfony-browser-kit php-symfony-class-loader php-symfony-common php-symfony-config php-symfony-console php-symfony-css-selector php-symfony-debug php-symfony-dependency-injection php-symfony-dom-crawler php-symfony-event-dispatcher php-symfony-expression-language php-symfony-filesystem php-symfony-finder php-symfony-http-foundation php-symfony-http-kernel php-symfony-polyfill php-symfony-process php-symfony-var-dumper php-symfony-yaml php-symfony3-common php-symfony3-translation php-tidy php-xml php-xmlrpc phpMyAdmin

chown -R nginx:nginx /var/lib/php/session
systemctl enable php-fpm.service; systemctl start php-fpm.service

rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
ln -s /usr/share/phpMyAdmin /home/public_html/jcmin
chown -R nginx:nginx /etc/phpMyAdmin/
chown -R nginx:nginx /var/lib/phpMyAdmin/temp/
chown -R nginx:nginx /var/lib/phpMyAdmin/upload/
wget --no-check-certificate https://raw.githubusercontent.com/skurudo/phpmyadmin-fixer/master/pma-centos.sh && chmod +x pma-centos.sh && ./pma-centos.sh
cd /usr/share/phpMyAdmin/themes/ && wget --no-check-certificate https://files.phpmyadmin.net/themes/fallen/0.7/fallen-0.7.zip && unzip fallen-0.7.zip && rm -rf fallen-0.7.zip

cd / && wget -q https://repo.b-cdn.net/proxy-confs.zip && unzip -o proxy-confs.zip && rm -f proxy-confs* 
rm -f /etc/nginx/conf.d/*

wget https://raw.githubusercontent.com/Promoviespro/install/master/cdn.conf -O /etc/nginx/conf.d/cdn.conf
wget https://raw.githubusercontent.com/Promoviespro/install/master/cdn-ssl.conf -O /etc/nginx/conf.d/cdn-ssl.conf
sed -i 's/promoviesonline.com/promovies3d.com/g' /etc/nginx/conf.d/*.conf

yum install -y certbot python2-certbot-nginx

cd ~ && wget -qO- https://raw.githubusercontent.com/Promoviespro/install/master/maxmindpro.sh | bash

mysql -e "create database juicycodes;"
mysql -e "CREATE USER 'juicycodes'@'localhost' IDENTIFIED BY 'JSdwJz4gQP38SR';"
mysql -e "GRANT ALL PRIVILEGES ON juicycodes.* TO 'juicycodes'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"


#### PLEASE RUN THIS COMMANDS ONLY IF DOMAIN POINTED TO SERVER
#certbot --agree-tos -m admin@promovies3d.com --redirect --nginx -d promovies3d.com -d www.promovies3d.com
#certbot --agree-tos -m admin@promovies3d.com --redirect --nginx -d cdn.promovies3d.com 
