#!/bin/bash
if [ ! -f /.mysql_admin_created ]; then
  /opt/bin/create_mysql_admin_user.sh
  if [[ $? -ne 0 ]]; then
    echo "failed to create mysql admin user"
    exit 1
  fi
fi

exec supervisord -n
