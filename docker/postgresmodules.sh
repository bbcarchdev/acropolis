#!/bin/bash
# Init script for postgres that enables some modules

set -e

psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "CREATE EXTENSION \"hstore\""

