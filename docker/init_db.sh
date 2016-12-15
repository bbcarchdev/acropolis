#!/bin/bash
set -e

# Load the functions
source ./docker/functions.sh

# Set the hostname in the config files
sed -i -e "s|ACROPOLIS_HOSTNAME|${ACROPOLIS_HOSTNAME-localhost}|" /usr/etc/twine.conf
sed -i -e "s|ACROPOLIS_HOSTNAME|${ACROPOLIS_HOSTNAME-localhost}|" /usr/etc/twine-anansi.conf
sed -i -e "s|ACROPOLIS_HOSTNAME|${ACROPOLIS_HOSTNAME-localhost}|" /usr/etc/quilt.conf

# Wait for Postgres
wait_for_service postgres 5432

# Create the DB. They need to be all there before the init is triggered.
do_init=false
for db in anansi spindle cluster twine; do
	if db_exists ${db}; then
	echo "$(date) - database ${db} exists"
	else
		echo "$(date) - creating database ${db}"
		create_db ${db};
		do_init=true
	fi
done

# Do all the init if needed
if [ "${do_init}" = true ] ; then
	echo "$(date) - need to initialise one or more databases"

	# Use twine to migrate the schema for 'spindle'
	echo "$(date) - doing schema migration with Twine"
	twine -c /usr/etc/twine.conf -S >/dev/null 2>&1
	wait_for_schema spindle com.github.bbcarchdev.spindle.twine 24
	wait_for_schema twine com.github.bbcarchdev.twine 1

	# Use twine to migrate the schema for 'spindle'
	echo "$(date) - doing schema migration with Anansi"
	/usr/sbin/crawld -c /usr/etc/crawl.conf -S >/dev/null 2>&1
	wait_for_schema anansi com.github.nevali.crawl.db 7

	# Use twine-writerd to migrate the schema of cluster
	echo "$(date) - spawning a writerd to init the cluster"
	twine-writerd >/dev/null 2>&1
	wait_for_schema cluster com.github.bbcarchdev.libcluster 5

	# Ask the writerd to stop and wait until its process is gone
	kill -s SIGTERM `pidof twine-writerd`
	until [[ -z `pidof twine-writerd` ]]; do
	    echo "$(date) - wait for writerd to finish"
	    sleep 2
	done

	# Probably a first run so we print the doc too
	cat docker.md
fi

# Run the requested command
exec "$@"
