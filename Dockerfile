FROM webdevops/php-nginx:8.4
LABEL vendor="aitra.pt"

ENV PHP_DISMOD=xdebug

WORKDIR /app


COPY ./php/php.ini /opt/docker/etc/php/php.ini
COPY ./php/fpm/php-fpm.conf /opt/docker/etc/php/fpm/pool.d/application.conf

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/mime.types /etc/nginx/mime.types
COPY ./nginx/vhost.conf /etc/nginx/vhost.conf

COPY ./services/horizon.conf /opt/docker/etc/supervisor.d/horizon.conf
COPY ./services/scheduler.conf /opt/docker/etc/supervisor.d/scheduler.conf

COPY ./provision/entrypoint.sh /opt/docker/provision/entrypoint.d/entrypoint.sh


RUN docker-service enable scheduler horizon
RUN apt-get update -y
RUN apt-get install nano -y
RUN apt-get install default-mysql-client -y