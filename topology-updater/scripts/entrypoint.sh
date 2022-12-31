#!/bin/bash

# if [ -z "$SCHEDULER_ENVIRONMENT" ]; then
#    echo "SCHEDULER_ENVIRONMENT not set, assuming Development"
#    SCHEDULER_ENVIRONMENT="development"
# fi

SCHEDULER_ENVIRONMENT="production"

# Select the crontab file based on the environment
CRON_FILE="crontab.$SCHEDULER_ENVIRONMENT"

echo "Loading crontab file: $CRON_FILE"

# Load the crontab file
crontab $CRON_FILE

# Start cron
echo "Starting cron..."
cron -f