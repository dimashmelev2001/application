#!/bin/bash
set -e

if [ $# -eq 0 ]; then
  echo "Start php-fpm...."
  php-fpm -D
  echo "Start nginx...."
  sudo nginx -g 'daemon off;'
fi

exec "$@"