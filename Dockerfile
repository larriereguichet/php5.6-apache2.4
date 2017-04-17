FROM ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive

# Install basics
RUN apt-get update
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y --force-yes curl git

# Install PHP 5.6
RUN apt-get install -y --allow-unauthenticated php5.6 php5.6-mysql php5.6-mcrypt php5.6-cli php5.6-gd php5.6-curl

# Install Apache 2.x
RUN apt-get install -y --force-yes apache2
RUN a2enmod php5 rewrite

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

ADD vhost.conf /etc/apache2/sites-availables/vhost.conf
RUN a2ensite vhost

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/sbin/apache2"]
CMD ["-D", "FOREGROUND"]

RUN mkdir /app
WORKDIR /app
