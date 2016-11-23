#!/bin/bash
set -e

# Wait for Acropolis remote control
until nc -z acropolis 8000; do
    echo "$(date) - waiting for Acropolis remote control..."
    sleep 2
done

# Wait for Acropolis web site
until nc -z acropolis 80; do
    echo "$(date) - waiting for Acropolis web interface..."
    sleep 2
done

echo "$(date) - All good :-)"

# Run the requested command
exec "$@"
