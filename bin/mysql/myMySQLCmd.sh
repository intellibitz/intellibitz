# https://dev.mysql.com/doc/refman/8.0/en/linux-installation-native.html
# https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#apt-repo-fresh-install

## https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html

# https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/
sudo apt-get install mysql-server
systemctl status mysql

# https://dev.mysql.com/doc/refman/8.0/en/starting-server.html
systemctl start mysqld

# https://dev.mysql.com/doc/refman/8.0/en/creating-accounts.html

# To install and use a MySQL binary distribution, the command sequence looks like this:

groupadd mysql
useradd -r -g mysql -s /bin/false mysql
cd /usr/local
tar xvf /path/to/mysql-VERSION-OS.tar.xz
ln -s full-path-to-mysql-VERSION-OS mysql
cd mysql
mkdir mysql-files
chown mysql:mysql mysql-files
chmod 750 mysql-files
bin/mysqld --initialize --user=mysql
bin/mysql_ssl_rsa_setup
bin/mysqld_safe --user=mysql &
# Next command is optional
cp support-files/mysql.server /etc/init.d/mysql.server
