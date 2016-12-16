#!/bin/bash

CONTAINER_NAME=site_container
LOCAL_PORT=8080
REMOTE_PORT=80


if [ "$1" = "" ];
  then

    echo -e "-- \e[1mDocker Web Server Container Easy Setup\e[21m --"
    echo "    Rerun the script with one of the available commands:"
    echo "     - build"
    echo "     - run"
    echo "     - stop"

fi

if [ "$1" = "build" ];
  then
    sudo docker build -t louwii/php-apache-simple .
fi

if [ "$1" = "run" ];
  then
    docker run \
     -d \
     --name $CONTAINER_NAME \
     -p $LOCAL_PORT:$REMOTE_PORT \
     -v $(pwd)/server-conf/site.conf:/etc/apache2/sites-enabled/site.conf \
     -v $(pwd)/src:/var/www/site \
     louwii/php-apache-simple
fi
