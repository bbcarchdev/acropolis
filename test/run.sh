#!/bin/bash
set -e

echo Waiting for services...
count=6
until nc -z acropolis.localhost 80; do
    echo "$(date) - (${count}) waiting for quilt..."
		count=$((count-1))
		if [ "$count" -eq "0" ]; then
			echo Timeout
			exit 1;
		fi
    sleep 5
done

count=6
until nc -z acropolis.localhost 8000; do
    echo "$(date) - (${count}) waiting for twine-remote..."
		count=$((count-1))
		if [ "$count" -eq "0" ]; then
			echo Timeout
			exit 1;
		fi
    sleep 5
done
echo Up!

# Run the requested command
exec "$@"
