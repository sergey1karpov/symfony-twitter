FROM php:8.0-fpm

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
build-essential \
libzip-dev \
libpng-dev \
libpq-dev \
libjpeg62-turbo-dev \
libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev \
libfreetype6 \
libfreetype6-dev \
locales \
zip \
jpegoptim optipng pngquant gifsicle \
vim \
unzip \
git \
curl

RUN docker-php-ext-install gd

RUN docker-php-ext-install sockets

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install zip exif pcntl pdo mysqli pdo_mysql pdo_pgsql

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server

EXPOSE 9000