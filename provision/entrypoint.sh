#!/bin/bash
cd /app
php artisan filament:upgrade
php artisan log-viewer:publish
php artisan package:discover --ansi
rm -r -f ./public/storage
php artisan storage:link
chown -R application:application /app 
find /app -type f -print0 | xargs -0 chmod 644
find /app -type d -print0 | xargs -0 chmod 755
chmod a+x /app/vendor/h4cc/wkhtmltopdf-amd64/bin/wkhtmltopdf-amd64
php artisan migrate --force
php artisan optimize:clear
php artisan optimize
php artisan icons:cache
php artisan config:clear