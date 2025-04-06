FROM php:8.2-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-install \
    pdo_mysql \
    intl \
    zip

# Configurar Apache
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos de la aplicación
COPY . .

# Establecer variables de entorno
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV APP_ENV=prod
ENV APP_DEBUG=0

# Instalar dependencias de Composer
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Crear el directorio var si no existe
RUN mkdir -p var/cache var/log

# Configurar permisos
RUN chmod -R 777 var

# Limpiar caché manualmente para el entorno de producción
RUN php bin/console cache:clear --env=prod --no-debug || true

# Exponemos el puerto 80
EXPOSE 80

# Comando de inicio
CMD ["apache2-foreground"]