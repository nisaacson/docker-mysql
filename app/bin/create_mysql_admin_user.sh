#!/bin/bash

echo "-----> Creating MySQL admin user if needed"
if [ -f /.mysql_admin_created ]; then
  echo "MySQL 'admin' user already created!"
  exit 0
fi


if [[ -z $ADMIN_PASSWORD ]]; then
  echo "ADMIN_PASSWORD environment variable is required but not set"
  exit 1
fi
echo "       Creating MySQL admin user with password specified by ADMIN_PASSWORD env variable"

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
  sleep "2s"
  mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$ADMIN_PASSWORD'"
  RET=$?
done

mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

mysqladmin -uroot shutdown

echo "       Done!"
touch /.mysql_admin_created

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -uadmin -p***** -h<host> -P<port>"
echo ""
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"
