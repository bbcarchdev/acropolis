#!/bin/bash
set -e

# Load the functions
source ./docker/functions.sh

# Wait for Postgres
wait_for_service postgres 5432

# Check individual databases are initialised
wait_for_schema spindle com.github.bbcarchdev.spindle.twine 24
wait_for_schema anansi com.github.nevali.crawl.db 7
wait_for_schema cluster com.github.bbcarchdev.libcluster 5

# Wait for S3
wait_for_service s3 80

# Wait for 4Store
wait_for_service fourstore 9000

# Ready!
echo "$(date) - services ready.."

# Run the requested command
exec "$@"
