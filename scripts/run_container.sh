#!/usr/bin/env bash
function install_mysql_client {
  echo '-----> install mysql client'
  command -v mysql 2>&1 1>/dev/null
  if [[ $? -eq 0 ]]; then
    echo "      mysql client already installed"
    return
  fi
  sudo apt-get install -qqy mysql-client
  command -v mysql 2>&1 1>/dev/null
  if [[ $? -ne 0 ]]; then
    echo "      mysql client failed to install" 1>&2
    exit 1
  fi
  echo "       mysql client installed"
}
ADMIN_PASSWORD="root" # set default mysql admin user password
HOST_SSH_PORT=1111
CONTAINER_SSH_PORT=22
HOST_MYSQL_PORT=3306
CONTAINER_MYSQL_PORT=3306
WAIT_SECONDS=2
CONTAINER_NAME="mysql-container"
IMAGE_NAME="mysql"


install_mysql_client
cd /vagrant/app # navigate to directory containing Dockerfile

echo "-----> run mysql server in docker container"
COMMAND="docker run \
  -name $CONTAINER_NAME \
  -p $HOST_SSH_PORT:$CONTAINER_SSH_PORT \
  -p $HOST_MYSQL_PORT:$CONTAINER_MYSQL_PORT \
  -e ADMIN_PASSWORD=$ADMIN_PASSWORD \
  -d \
  $IMAGE_NAME"
echo "       docker run command: $COMMAND"
ID=$($COMMAND)
echo "      container running with id $ID"
echo "      admin password: $ADMIN_PASSWORD"
echo "      wait $WAIT_SECONDS seconds for mysql server to start"

# wait a few seconds then inspect the container logs
sleep "$WAIT_SECONDSs"
docker logs $ID
echo "       you can connect to mysql with command: \"mysql -h127.0.0.1 -p3306 -uadmin -p$ADMIN_PASSWORD\""
