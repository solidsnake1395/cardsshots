FROM php:8.2-cli

# Instala dependencias necesarias para Symfony
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libzip-dev libpq-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip

# Instala Composer desde imagen oficial
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Establece un directorio de trabajo seguro para evitar conflictos
WORKDIR /app


COPY . .

# Instala dependencias PHP (modo producción, sin scripts)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Expone el puerto 8000 (Render redirige automáticamente)
EXPOSE 8000

# Comando para iniciar el servidor integrado de PHP apuntando a la carpeta public/
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
