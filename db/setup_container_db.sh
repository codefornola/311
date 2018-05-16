#!/bin/bash

NOLA311_DB_SUPERUSER=${POSTGRES_USER:-postgres}
NOLA311_DB_SUPERUSER_PASSWORD=${POSTGRES_PASSWORD:-postgres}

echo "localhost:5432:nola311:${NOLA311_DB_SUPERUSER}:${NOLA311_DB_SUPERUSER_PASSWORD}" > /.pgpass

docker-entrypoint.sh
sudo -u postgres postgres

cd /nola311/db && ./setup.sh
