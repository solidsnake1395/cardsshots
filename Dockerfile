FROM php:8.2-cli

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git unzip zip curl libicu-dev libonig-dev libzip-dev libpq-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instalar Symfony CLI (para auto-scripts)
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Establecer directorio de trabajo
WORKDIR /app

# ⛔ Ya no hagas "composer install" acá todavía...


COPY . .

# ✅ Ahora sí: ejecutar composer con permisos root
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader

# Exponer puerto
EXPOSE 8000

# Comando para iniciar
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
