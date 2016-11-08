#!/bin/bash
set -e

echo Waiting for services...
until nc -z acropolis 80; do
    echo "$(date) - waiting for quilt..."
    sleep 2
done

until nc -z acropolis 8000; do
    echo "$(date) - waiting for twine-remote..."
    sleep 2
done
echo Up!

# Run the requested command
exec "$@"
