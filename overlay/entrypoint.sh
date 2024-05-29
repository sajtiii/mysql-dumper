#!/bin/sh

if [ "${ONCE:-false}" == "true" ]; then
    echo "Running dumper only once ..."
    exec /dumper.sh
    exit 0
fi

# Install cron job
CRON_DEFINITION="${SCHEDULE:-0 4 * * *} DISPLAY=:0 /dumper.sh"
echo "Installing cron job [$CRON_DEFINITION] ..."
crontab -l | { cat; echo "$CRON_DEFINITION"; } | crontab -

crond -f