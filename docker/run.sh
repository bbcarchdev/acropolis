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

# Check individual databases are initialised
wait_for_schema spindle com.github.bbcarchdev.spindle.twine 24
wait_for_schema twine com.github.bbcarchdev.twine 1
wait_for_schema anansi com.github.nevali.crawl.db 7
wait_for_schema cluster com.github.bbcarchdev.libcluster 5

# Wait for S3
wait_for_service s3 80

# Ready!
echo "$(date) - services ready.."

# Run the requested command
exec "$@"
