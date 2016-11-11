#!/bin/bash
set -e

db_host=postgres
db_user=postgres

# Wait for Postgres
until nc -z postgres 5432; do
    echo "$(date) - waiting for Postgres..."
    sleep 2
done

# Check individual databases are initialised
for db in anansi spindle cluster; do
  if psql --host=${db_host} --username=${db_user} --dbname=${db} -tAc '';then
    echo Database ${db} Exists
    sleep 5
  else
    echo "$(date) - waiting for database ${db} to be initialised"
    sleep 2
  fi
done


# Wait for S3
until nc -z s3 80; do
    echo "$(date) - waiting for S3..."
    sleep 2
done

# Wait for 4Store
until nc -z fourstore 9000; do
    echo "$(date) - waiting for 4Store..."
    sleep 2
done

echo "$(date) - Services Ready.."

# Run the requested command
exec "$@"
