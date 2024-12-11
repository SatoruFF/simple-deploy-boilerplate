#!/bin/bash

# Load variables from the .env file
export $(grep -v '^#' /root/core/meatIsland/.env | xargs)

# Check that all required variables are set
if [[ -z "$DB_HOST" || -z "$DB_PORT" || -z "$DB_NAME" || -z "$DB_USER" || -z "$DB_PASSWORD" ]]; then
  echo "All required variables (DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD) are not set"
  exit 1
fi

# Create a directory for dumps if it doesn't exist
DUMP_DIR="./dumps/$(date +%Y-%m-%d)"
mkdir -p "$DUMP_DIR"

# Generate the dump file name with the current date and time
DUMP_FILE="$DUMP_DIR/dump_$(date +%H-%M-%S).sql"

# Perform the database dump
PGPASSWORD=$DB_PASSWORD pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME > "$DUMP_FILE"

if [ $? -eq 0 ]; then
  echo "Database dump successfully saved to $DUMP_FILE"
else
  echo "Error occurred while creating the database dump"
  exit 1
fi

# Delete files older than 7 days
find ./dumps/ -type f -name "*.sql" -mtime +7 -exec rm {} \;

# Next steps:
# crontab -e
# 0 0 * * * /path/to/project/dump.sh # e.g., every day at midnight
# chmod +x /path/to/project/dump.sh
# sudo service cron reload
