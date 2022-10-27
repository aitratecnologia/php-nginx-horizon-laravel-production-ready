FROM webdevops/php-nginx:8.1
LABEL maintainer="contato@aitra.com.br"
LABEL vendor="aitra.com.br"
ENV WEB_DOCUMENT_ROOT=/app/public
ENV PHP_DISMOD=xdebug
WORKDIR /app
COPY ./laravel.ini /usr/local/etc/php/conf.d/laravel.ini
COPY ./services/horizon.conf /opt/docker/etc/supervisor.d/horizon.conf
COPY ./provision/entrypoint.sh /opt/docker/provision/entrypoint.d/entrypoint.sh
RUN docker-service enable cron horizon
RUN docker-cronjob '* * * * * application /usr/local/bin/php /app/artisan schedule:run >> /dev/null 2>&1'