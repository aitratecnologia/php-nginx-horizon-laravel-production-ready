#!/bin/bash
/usr/local/bin/composer install --working-dir /app
/usr/local/bin/php /app/artisan optimize:clear
chown -R application:application /app