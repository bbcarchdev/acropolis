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
until [ -f /ready ]; do
    echo "$(date) - waiting for someone to init everything..."
	sleep 1
	
	if [ ! -f /busy ]; then
		touch /busy
		
		echo "Create the DBs in Postgres..."
		psql --host=postgres --username=postgres -c "CREATE DATABASE \"anansi\""
		psql --host=postgres --username=postgres -c "CREATE DATABASE \"spindle\""
		psql --host=postgres --username=postgres -c "CREATE DATABASE \"cluster\""
		psql --host=postgres --username=postgres --dbname=spindle -c "CREATE EXTENSION \"hstore\""
		
		echo "Initialising Twine..."
	    twine -d -c /usr/etc/twine.conf -S    
	    
		touch /ready
		rm /busy
	fi
done

# Print some doc
cat /usr/local/src/docker.md

# Run the requested command
exec "$@"
