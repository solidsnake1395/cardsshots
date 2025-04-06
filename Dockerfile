FROM php:8.2-cli

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git unzip zip curl libicu-dev libonig-dev libzip-dev libpq-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ✅ ESTO VA ANTES para evitar errores con rutas
WORKDIR /app

# Copiar composer.json y lock para aprovechar la caché de dependencias
COPY composer.json composer.lock ./

# ✅ Ejecutar composer con permisos root habilitados
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader

# Copiar el resto del código
COPY . .

# Exponer el puerto que usará PHP
EXPOSE 8000

# Comando para levantar la app Symfony
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
