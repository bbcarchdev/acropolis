#!/bin/bash
set -e

# Wait for Postgres
until nc -z postgres 5432; do
    echo "$(date) - waiting for Postgres..."
    sleep 2
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

# Wait until someone has initialised everything
if [ "${DOINIT}" = "true" ]; then
	if [ ! -f /ready ]; then
		echo "$(date) - Create the DBs in Postgres..."
		psql --host=postgres --username=postgres -c "CREATE DATABASE \"anansi\""
		psql --host=postgres --username=postgres -c "CREATE DATABASE \"spindle\""
		psql --host=postgres --username=postgres -c "CREATE DATABASE \"cluster\""
		psql --host=postgres --username=postgres --dbname=spindle -c "CREATE EXTENSION \"hstore\""
		
		echo "$(date) -  Initialising Twine..."
	    twine -d -c /usr/etc/twine.conf -S    
	    
		touch /ready
		
		# Print some doc
		cat /usr/local/src/docker.md
	fi
else
fi

# Run the requested command
exec "$@"
