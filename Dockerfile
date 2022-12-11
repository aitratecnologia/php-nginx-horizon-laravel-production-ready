FROM webdevops/php-nginx:8.1
LABEL maintainer="contato@aitra.com.br"
LABEL vendor="aitra.com.br"
ENV WEB_DOCUMENT_ROOT=/app/public
ENV PHP_DISMOD=xdebug
ENV PHP_DATE_TIMEZONE=America/Sao_Paulo
ENV PHP_MEMORY_LIMIT=1024M
WORKDIR /app
COPY ./laravel.ini /usr/local/etc/php/conf.d/laravel.ini
COPY ./services/horizon.conf /opt/docker/etc/supervisor.d/horizon.conf
COPY ./provision/entrypoint.sh /opt/docker/provision/entrypoint.d/entrypoint.sh
COPY ./nginx/vhost/10-general.conf /opt/docker/etc/nginx/vhost.common.d/
RUN docker-service enable cron horizon
RUN docker-cronjob '* * * * * application /usr/local/bin/php /app/artisan schedule:run >> /dev/null 2>&1'
RUN apt-get update -y
RUN apt-get install nano -y
RUN apt-get install default-mysql-client -y