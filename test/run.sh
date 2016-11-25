#!/bin/bash
set -e

echo Waiting for services...
count=0
tries=6
until nc -z acroppolis.localhost 80; do
    echo "$(date) - waiting for quilt..."
    sleep 5
		((count++))
		if [ "$count" -eq "$tries" ]; then
			echo Timeout
			exit 1;
		fi
done

count=0
until nc -z acropolis.localhost 8000; do
    echo "$(date) - waiting for twine-remote..."
    sleep 5
		((count++))
		if [ "$count" -eq "$tries" ]; then
			echo Timeout
			exit 1;
		fi
done
echo Up!

# Run the requested command
exec "$@"
