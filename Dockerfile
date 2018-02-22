FROM ubuntu:16.04
LABEL maintainer="Kenneth Kitchen <kkitchen@chattanooga.gov>"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    libapache2-mod-php7.0 \
    php7.0 \
    php7.0-cli \
    php7.0-common \
    php7.0-curl \
    php7.0-gd \
    php7.0-json \
    php7.0-mysql \
    php7.0-opcache \
    php7.0-pspell \
    php7.0-sqlite3 \
    php7.0-xml \
    php7.0-xmlrpc \
    php7.0-intl \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-zip \
    apache2 \
    curl

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/bin/composer && \
    chmod a+x /usr/bin/composer

RUN cd /var/www && \
    composer self-update && \
    composer create-project --prefer-dist cakephp/app cakephp && \
    rm /var/www/html/index.html && \
    rmdir /var/www/html && \
    mv /var/www/cakephp /var/www/html && \
    chmod a+x /var/www/html/bin/cake

RUN cd /etc/apache2/sites-available && \
    rm 000-default.conf && \
    cd /etc/apache2 && \
    rm apache2.conf && \
    a2enmod rewrite

ARG SERVER_NAME=localhost

COPY 000-default.conf /etc/apache2/sites-available/
COPY apache2.conf /etc/apache2
COPY setup.sh /tmp
RUN chmod a+x /tmp/setup.sh

EXPOSE 80 443

CMD  /bin/bash -c  ./tmp/setup.sh -s abc.com && \
     /usr/sbin/apache2ctl -D FOREGROUND