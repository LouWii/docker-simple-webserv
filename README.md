# Docker Webserver Setup - Easy way to setup a web server in a container

The goal of this setup is to provide a quick and easy to use starting point for creating and handling a PHP webserver in a Docker container.

The container is built with Apache and PHP, based on the `php:7.0-apache` image from the [official PHP images](https://hub.docker.com/_/php/).

We're adding several commonly used PHP extension (easily removable):

* bz2 
* calendar
* curl
* gd
* iconv
* intl
* mbstring
* mcrypt
* mysqli
* opcache
* pdo_mysql
* pdo_pgsql
* pgsql
* xml
* zip

And a script to make your life easier for building and running your container.

## How to use it

Put your code in the `src` folder.

Rename the `server-conf/site.edit-me.conf` to `server-conf/site.conf` and enter your site configuration in there.

*Optionnal* Modify the `container-utils.sh` file (useful settings are at the top) to change the local port, container name...

Run `./container-utils.sh build` to build the container (you will need to run that only once, the container will be cached on your machine for later use).

Run `./container-utils.sh run` to run the container.

The default port pointing to the container is 8080. So you should be able to access the container using `localhost:8080` in any browser.

## Docker Container setup

Everything is in the `Dockerfile`.

If you need to **remove a PHP extension**, just remove it from the Dockerfile. 

If you want to **add a PHP extension**, same thing, add it to the file. However, the PHP extension might have some dependencies that you'll need to install.

## Container utils script

`container-utils.sh` can help you deal with standard operations like building the container and running it (more to come ?).

`./container-utils.sh build` will simply build the `louwii/simple-webserver` container from the `Dockerfile`

`./container-utils.sh run` will run the container with all necessary parameters

There's nothing complex in that script. Do not hesitate to have a look at it and modify it to suit your needs.

## Using `docker-compose`

Docker has its own tool to setup a group of container as a service, called `docker-compose`.

We've created a general `docker-compose.yml` with a `.env` file that will allow you to easily run the db server and web server together. All important variables that needs changing are located in the `.env` file.

The generated containers will be named depending on the project name and service name. If your project name is `site` and the service is `db`, the container will be named `site_db_1`.

Note that the db server is using a **persistent volume**. That means if you stop and delete the db container, the data will stay untouched. You will be able to start a new container and keep the same data (database, tables but also database root password and user login).

If you need to start again with no data, you can either delete the volume or change the volume name in `docker-compose.yml`.

To delete the volume, run `sudo docker volume ls` to list all volumes.

```
DRIVER              VOLUME NAME
local               dockersimplewebserv\_db\_data
```

Run `sudo docker volume rm dockersimplewebserv_db_data` to delete the volume. **All data will be lost**

## License

GNU GPLv3, see [License](LICENSE).
