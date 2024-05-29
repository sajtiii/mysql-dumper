#!/bin/bash

# CREATE AND CLEAN TMP DIRECTORY
mkdir -p /tmp/dumps

# READ ALL DATABASES AND DUMP THEM INTO FILES
dbs=( 
    $(mysql --host=$DB_HOST --port=${DB_PORT:-3306} --user=$DB_USERNAME --password=$DB_PASSWORD -s -r -e 'SHOW DATABASES;') 
)
for i in "${dbs[@]}"
do
    # IGNORE SYSTEM DATABASES
    if [ $i != "information_schema" ] && [ $i != "performance_schema" ] && [ $i != "mysql" ] && [ $i != "sys" ]
    then
        echo "Dumping $i ..."
        mysqldump --max_allowed_packet=512M --host=$DB_HOST --port=${DB_PORT:-3306} --user=$DB_USERNAME --password=$DB_PASSWORD $i > /tmp/dumps/$i".sql"
    fi
done

# SAVE THE DIFF TO THE BACKUPS
rdiff-backup backup /tmp/dumps /dumps

# CLEANUP THE DIRECTORIES
rm -rf /tmp/dumps/

# Cleanup rdiff backup
rdiff-backup --api-version 201 --force remove increments --older-than ${KEEP_DAYS:-30}D /dumps

if [ -n "$POST_DUMP_SCRIPT" ] && [ -f "$POST_DUMP_SCRIPT" ]; then
    echo "Running post dump script [$POST_DUMP_SCRIPT] ..."
    chmod +x $POST_DUMP_SCRIPT
    exec $POST_DUMP_SCRIPT
fi
