FROM ubuntu

LABEL maintainer="Chris Wiegman <contact@chriswiegman.com>"

ENV DEBIAN_FRONTEND noninteractive

ARG PIWIGO_VERSION="2.9.5"

RUN  apt-get update && \
     apt-get install -yy software-properties-common && \
     add-apt-repository ppa:ondrej/php -y && \
     apt-get update \
     && apt-get install -yy \
            apache2 \
            libapache2-mod-php \
            php7.3-gd \
            php7.3-curl \
            php7.3-mysql \
            php7.3-mbstring \
            php7.3-xml \
            php7.3-imagick \
            wget \
            unzip \
     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -q -O piwigo.zip http://piwigo.org/download/dlcounter.php?code=$PIWIGO_VERSION && \
    unzip piwigo.zip && \
    rm /var/www/* -rf && \
    mv piwigo/* /var/www/ && \
    rm -r piwigo* && \
    mkdir /template && \
    mv /var/www/galleries /template/ && \
    mv /var/www/themes /template/ && \
    mv /var/www/plugins /template/ && \
    mv /var/www/local /template/ && \
    mkdir -p /var/www/_data/i /config && \
    chown -R www-data:www-data /var/www

ADD php.ini /etc/php/7.3/apache2/php.ini
VOLUME ["/var/www/galleries", "/var/www/themes", "/var/www/plugins", "/var/www/local", "/var/www/_data/i", "/config"]

ADD entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
EXPOSE 80
