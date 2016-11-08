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
if [ "${DOINIT}" == "true" ]; then
	if [ ! -f /ready ]; then
		echo "$(date) - Create the DBs in Postgres..."
		psql --host=postgres --username=postgres -c "CREATE DATABASE \"anansi\""
		psql --host=postgres --username=postgres -c "CREATE DATABASE \"spindle\""
		psql --host=postgres --username=postgres -c "CREATE DATABASE \"cluster\""
		psql --host=postgres --username=postgres --dbname=spindle -c "CREATE EXTENSION \"hstore\""
		
		echo "$(date) -  Initialising Twine..."
		# Use twine to migrate the schema for 'spindle'
	    twine -d -c /usr/etc/twine.conf -S    

		# Starting a writerd will take care of migrating 'cluster'
		twine-writerd
		until psql --host=postgres --username=postgres --dbname=cluster -c "SELECT \"version\" FROM \"_version\" WHERE \"ident\"='com.github.bbcarchdev.libcluster';" | grep "5"; do
			echo "$(date) - waiting for the DB cluster schema version 5"
			sleep 1
		done
		kill -s SIGTERM `pidof twine-writerd`
			    
		touch /ready
		
		# Print some doc
		cat /usr/local/src/docker.md
	fi
else
	# Wait until DB Anansi exists
	until psql --host=postgres --username=postgres -lqt | cut -d \| -f 1 | grep -qw "anansi"; do
		echo "$(date) - waiting for the DB anansi"
		sleep 1
	done

	# Wait until Spindle exists and is at latest version
	until psql --host=postgres --username=postgres -lqt | cut -d \| -f 1 | grep -qw "spindle"; do
		echo "$(date) - waiting for the DB spindle"
		sleep 1
	done
	until psql --host=postgres --username=postgres --dbname=spindle -c "SELECT \"version\" FROM \"_version\" WHERE \"ident\"='com.github.bbcarchdev.spindle.twine';" | grep "24"; do
		echo "$(date) - waiting for the DB spindle schema version 24"
		sleep 1
	done

	# Wait until DB cluster exists and is at latest version
	until psql --host=postgres --username=postgres -lqt | cut -d \| -f 1 | grep -qw "cluster"; do
		echo "$(date) - waiting for the DB cluster"
		sleep 1
	done
	until psql --host=postgres --username=postgres --dbname=cluster -c "SELECT \"version\" FROM \"_version\" WHERE \"ident\"='com.github.bbcarchdev.libcluster';" | grep "5"; do
		echo "$(date) - waiting for the DB cluster schema version 5"
		sleep 1
	done
fi

echo "$(date) - All good :-)"

# Run the requested command
exec "$@"
