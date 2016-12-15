FROM php:7.0-apache
MAINTAINER louwii@louwii.fr

# Install PHP extensions and PECL modules.
RUN buildDeps=" \
        libbz2-dev \
        libmysqlclient-dev \
        libcurl4-gnutls-dev \
    " \
    runtimeDeps=" \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libpng12-dev \
        libpq-dev \
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && docker-php-ext-install bz2 calendar curl iconv intl mbstring mcrypt mysqli pdo_mysql pdo_pgsql pgsql zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /var/lib/apt/lists/* \
    && a2enmod rewrite
    
# Install Composer (optionnal)
ENV COMPOSER_HOME /root/composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH
