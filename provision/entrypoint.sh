#!/bin/bash
php artisan filament:upgrade
php artisan log-viewer:publish
php artisan package:discover --ansi
chown -R application:application /app