#!/bin/bash
cd /var/www/doar && \
#runuser -l www composer install && \
composer install && \
php artisan config:clear && \
php artisan route:clear && \
php artisan view:clear && \
chmod -R 777 storage && \
cp .env.example .env && \
service apache2 start && \
echo ":: Init script finished ::"
