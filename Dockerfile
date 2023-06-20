FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    sudo \
    && curl -sSL https://packages.sury.org/nginx-mainline/README.txt | bash -x \
    && apt install -y nginx nginx-full \
    && apt-get clean

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN { \
  usermod -aG sudo -s /bin/bash www-data; \
  usermod -d /srv www-data; \
  chown -R www-data:www-data /srv; \
  echo "www-data ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/www-data; \
}

RUN { \
  rm -f /etc/nginx/sites-enabled/default; \
  rm -f /etc/nginx/conf.d/default; \
}

COPY docker/devops-project.conf /etc/nginx/conf.d/devops-project.conf

WORKDIR /srv/app

COPY --chown=www-data:www-data . .

RUN chmod +x docker-entrypoint.sh

USER www-data

ENTRYPOINT ["/srv/app/docker-entrypoint.sh"]