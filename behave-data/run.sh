#!/bin/sh
set -e

sed -i -e "s|ACROPOLIS_HOSTNAME|${ACROPOLIS_HOSTNAME}|" features/config.py

echo Waiting for services...
count=20
until nc -z ${ACROPOLIS_HOSTNAME} 80; do
    echo "$(date) - (${count}) waiting for quilt..."
		count=$((count-1))
		if [ "$count" -eq "0" ]; then
			echo Timeout
			exit 1;
		fi
    sleep 5
done

count=15
until nc -z ${ACROPOLIS_HOSTNAME} 8000; do
    echo "$(date) - (${count}) waiting for twine-remote..."
		count=$((count-1))
		if [ "$count" -eq "0" ]; then
			echo Timeout
			exit 1;
		fi
    sleep 5
done
echo Up!
echo Starting test suite run...

# Run the requested command
exec "$@"

