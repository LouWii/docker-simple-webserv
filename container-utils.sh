#!/bin/bash

# Site container config
SITE_CONTAINER_NAME="site_container"
LOCAL_PORT=8080
REMOTE_PORT=80

# Db container config
DB_CONTAINER_NAME="db_container"
DB_DATABASE_NAME="the_database_name"
DB_ROOT_PASSWORD="A!Complexe&Passphrase#"
#DB_FILE_STORAGE_ON_HOST_PATH="/home/user/mysql_dbs/site"
DB_USER=""
DB_PASSWORD=""

if [ "$1" = "" ]
then

  echo -e "-- \e[1mDocker Web Server Container Easy Setup\e[21m --"
  echo "    Rerun the script with one of the available commands:"
  echo "     - sitebuild"
  echo "     - siterun"
  echo "     - dbrun"
  echo "     - dbbash"
  echo "     - dblog"

fi

## SITE COMMANDS

if [ "$1" = "sitebuild" ]
then
  sudo docker build -t louwii/simple-webserver .
fi

if [ "$1" = "siterun" ]
then
  sudo docker run \
    -d \
    --name $SITE_CONTAINER_NAME \
    -p $LOCAL_PORT:$REMOTE_PORT \
    -v $(pwd)/server-conf/site.conf:/etc/apache2/sites-enabled/site.conf \
    -v $(pwd)/src:/var/www/site \
    --link $DB_CONTAINER_NAME:mysql \
    louwii/simple-webserver
fi

## DB COMMANDS

# Run DB Docker container
if [ "$1" = "dbrun" ]
then

  if [ "$DB_FILE_STORAGE_ON_HOST_PATH" = "" ]
  then
    FILES_ON_HOST=""
  else
    FILES_ON_HOST="-v $DB_FILE_STORAGE_ON_HOST_PATH:/var/lib/mysql"
  fi

  if [ "$DB_USER" = "" ]
  then
    DB_USER_SETUP=""
  else
    DB_USER_SETUP="-e MYSQL_USER=$DB_USER"
  fi

  if [ "$DB_PASSWORD" = "" ]
  then
    DB_PASS_SETUP=""
  else
    DB_PASS_SETUP="-e MYSQL_PASSWORD=$DB_PASSWORD"
  fi

  sudo docker run \
    -d \
    --name $DB_CONTAINER_NAME \
    -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD \
    -e MYSQL_DATABASE=$DB_DATABASE_NAME \
    $DB_USER_SETUP \
    $DB_PASS_SETUP \
    -v $(pwd)/database-conf:/etc/mysql/conf.d \
    -v $(pwd)/database-init:/docker-entrypoint-initdb.d \
    $FILES_ON_HOST \
    mysql:5.7
fi

# Get a bash in the DB container
if [ "$1" = "dbbash" ]
then
  sudo docker exec -it $DB_CONTAINER_NAME bash
fi

# Access database logs
if [ "$1" = "dblog" ]
then
  sudo docker logs $DB_CONTAINER_NAME
fi