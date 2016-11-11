#!/bin/bash
set -e

db_host=postgres
db_user=postgres

# Wait for Postgres
until nc -z postgres 5432; do
    echo "$(date) - waiting for Postgres..."
    sleep 2
done

for db in anansi spindle cluster; do
  if psql --host=${db_host} --username=${db_user} --dbname=${db} -tAc '';then
    echo Database ${db} Exists
  else
    echo Creating Database ${db}
    psql --host=${db_host} --username=${db_user} -c "CREATE DATABASE \"${db}\""

    if [ "$db" == "spindle" ]; then
      echo Create hstore extension
      psql --host=${db_host} --username=${db_user} --dbname=${db} -c "CREATE EXTENSION \"hstore\""

      echo "Initialising Twine spindle (via twine)"
      # Use twine to migrate the schema for 'spindle'
      twine -d -c /usr/etc/twine.conf -S

      until psql --host=${db_host} --username=${db_user} --dbname=${db} -c "SELECT \"version\" FROM \"_version\" WHERE \"ident\"='com.github.bbcarchdev.spindle.twine';" | grep "24"; do
        echo "$(date) -waiting for the DB spindle schema version 24"
        sleep 1
      done
    fi

    if [ "$db" == "cluster" ]; then
      # Starting a writerd will take care of migrating 'cluster'
      echo "Initialising cluster (via twine-writerd)"
      twine-writerd
      until psql --host=${db_host} --username=${db_user} --dbname=${db} -c "SELECT \"version\" FROM \"_version\" WHERE \"ident\"='com.github.bbcarchdev.libcluster';" | grep "5"; do
        echo "$(date) - waiting for the DB cluster schema version 5"
        sleep 1
      done
      kill -s SIGTERM `pidof twine-writerd`
    fi
  fi
done

# Run the requested command
exec "$@"
