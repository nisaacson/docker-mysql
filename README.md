Docker mysql
===========

Builds a docker image for `mysqld`

# Usage


```bash
# start a solo mysql server
vagrant up --provision
vagrant ssh
mysql -h127.0.0.1 -p3306 -uadmin -proot
```

# Building

To build a docker image, use the included Vagrantfile to launch up a virtual machine with docker already installed. The Vagrantfile uses the [vagrant docker provisioner](http://docs.vagrantup.com/v2/provisioning/docker.html) to install docker

**Requirements**

* [Vagrant](http://www.vagrantup.com/)

To launch the vagrant virtual machine

```bash
cd /path/to/this/repo
vagrant up
```

Once the virtual machine is running you can test out the `Dockerfile` via

```bash
# log into the virtual machine
vagrant ssh
# go to the mounted shared folder
cd /vagrant/app

# build a docker image from the Dockerfile
docker build -t mysql .

# ensure that the image exists, you should see the `mysql` image in the list output
docker images

# run the container, mapping ports on the host virtual machine to the same ports inside the container
$ID=$(docker run -name mysql-container -p 1111:22 -p 3306:3306 -e ADMIN_PASSWORD=root -d mysql)

# wait a few seconds and then check container logs. You should see the output from mysql starting up.
docker logs $ID

# connect to the mysql service running in the container via mysql client interface
mysql -h127.0.0.1 -p3306 -uadmin -proot

# You can connect to the running container via the mapped ssh port
# password: root
ssh -p 1111 root@localhost
```

# Notes

> TODO: Add support for mounted data volumes. The following is included for reference only

To use a custom mysql data configuration and data folder, use the [volumes](http://docs.docker.io/en/latest/use/working_with_volumes/) feature of docker to mount the mysql data folder inside the container at `/var/lib/mysql/mysql`.

```bash
# volumes
HOST_MYSQL_VOLUME=/home/vagrant/mysql_data
CONTAINER_mysql_VOLUME=/var/lib/mysql/data

# ports
HOST_SSH_PORT=1111
CONTAINER_SSH_PORT=22

HOST_MYSQL_PORT=3306
CONTAINER_mysql_PORT=22



docker run \
  -d # run in detached mode
  -name "mysql-container"
  -p $HOST_SSH_PORT:$CONTAINER_SSH_PORT    \
  -p $HOST_mysql_PORT:$CONTAINER_mysql_PORT  \
  -v $HOST_mysql_VOLUME:$CONTAINER_mysql_VOLUME
  mysql:latest # format is <image name>:<tag>
```

