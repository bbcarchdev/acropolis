#!/bin/bash

# Wait until we can remote control Twine
until nc -z twine 8000; do
    echo "$(date) - waiting for Twine remote control..."
    sleep 2
done
echo "The remote control seems to be up"

# Run the requested command
exec "$@"
