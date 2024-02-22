# Start with the PHP image that includes the necessary extensions for WordPress
FROM wordpress:php8.1-fpm

# Set environment variables for PHP Opcache for better performance
ENV PHP_OPCACHE_ENABLE=1 \
    PHP_OPCACHE_ENABLE_CLI=0 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
    PHP_OPCACHE_REVALIDATE_FREQ=0

# Install additional system dependencies required by WordPress or your custom plugins/themes
RUN apt-get update && apt-get install -y \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure and install additional PHP extensions that are frequently used in WordPress projects
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql bcmath curl opcache mbstring zip

# If you use Composer for managing WordPress plugins or themes, install Composer in the image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# No need to copy PHP and Nginx configuration files as we're using php-fpm image
# If you need custom PHP configurations, you can uncomment the COPY line below and adjust accordingly
# COPY ./php.ini /usr/local/etc/php/conf.d/custom.ini

# Set the working directory to the root of your WordPress installation
WORKDIR /var/www/html

# Copy the WordPress content if you're building a custom WordPress image
# This step is optional and mainly for customizations or pre-loading your WordPress site
# COPY . /var/www/html

# Change ownership of the WordPress files to the www-data user
# This step ensures that the WordPress installation has the correct permissions
RUN chown -R www-data:www-data /var/www/html

# You can customize this Dockerfile further based on your specific needs

# Use the CMD command from the base image, which starts PHP-FPM
CMD ["php-fpm"]
