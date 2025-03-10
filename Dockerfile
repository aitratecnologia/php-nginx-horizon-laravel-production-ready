FROM webdevops/php-nginx:8.4
LABEL vendor="aitra.pt"

ENV WEB_DOCUMENT_ROOT=/app/public
ENV PHP_DISMOD=xdebug
ENV PHP_DATE_TIMEZONE=America/Sao_Paulo

WORKDIR /app


COPY ./php/php.ini /opt/docker/etc/php/php.ini
COPY ./php/fpm/php-fpm.conf /opt/docker/etc/php/fpm/php-fpm.conf

COPY ./nginx/global.conf /opt/docker/etc/nginx/global.conf
COPY ./nginx/vhost.conf /opt/docker/etc/nginx/vhost.conf
COPY ./nginx/mime.types /opt/docker/etc/nginx/mime.types

COPY ./services/horizon.conf /opt/docker/etc/supervisor.d/horizon.conf
COPY ./services/scheduler.conf /opt/docker/etc/supervisor.d/scheduler.conf

COPY ./provision/entrypoint.sh /opt/docker/provision/entrypoint.d/entrypoint.sh


RUN docker-service enable scheduler horizon
RUN apt-get update -y
RUN apt-get install nano -y
RUN apt-get install default-mysql-client -y