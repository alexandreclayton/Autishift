FROM php:7.4.10-fpm-alpine3.12

# Install essential build tools
RUN apk add --no-cache \
    git \
    yarn \
    autoconf \
    g++ \
    make \
    openssl-dev

# Optional, force UTC as server time
RUN echo "UTC" > /etc/timezone

RUN apk update \
    && apk add ca-certificates wget \
    && update-ca-certificates

RUN docker-php-ext-install pdo pdo_mysql mysqli \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/ --filename=composer --no-ansi

# Setup zip extension
RUN apk add --no-cache libzip-dev zip \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-enable zip \
    && rm -rf /tmp/*

# Setup bzip2 extension
RUN apk add --no-cache \
    bzip2-dev \
    && docker-php-ext-install -j$(nproc) bz2 \
    && docker-php-ext-enable bz2 \
    && rm -rf /tmp/*

# Setup GD extension
RUN apk add --no-cache \
      freetype \
      libjpeg-turbo \
      libpng \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && docker-php-ext-configure gd \
      --with-freetype=/usr/include/ \
      # --with-png=/usr/include/ \ # No longer necessary as of 7.4; https://github.com/docker-library/php/pull/910#issuecomment-559383597
      --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && apk del --no-cache \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && rm -rf /tmp/*

# Install intl extension
RUN apk add --no-cache \
    icu-dev \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-enable intl \
    && rm -rf /tmp/*

# Install mbstring extension
RUN apk add --no-cache \
    oniguruma-dev \
    && docker-php-ext-install mbstring \
    && docker-php-ext-enable mbstring \
    && rm -rf /tmp/*


RUN apk add --no-cache \
    && docker-php-ext-install exif \
    && docker-php-ext-enable exif \
    && rm -rf /tmp/* \

ENV PATH="/var/www/html/vendor/bin:${PATH}"

RUN echo '*  *  *  *  *  cd /var/www/html && php artisan schedule:run ' > /var/spool/cron/crontabs/root

RUN echo 'post_max_size = 200M;' >> /usr/local/etc/php/php.ini && \
    echo 'upload_max_filesize = 200M;' >> /usr/local/etc/php/php.ini && \
    echo 'memory_limit = 1000M' >> /usr/local/etc/php/php.ini && \
    echo 'max_execution_time = 300;' >> /usr/local/etc/php/php.ini && \
    echo 'max_input_time = 300;' >> /usr/local/etc/php/php.ini

#CMD ['crond', '-l 2', '-f']
