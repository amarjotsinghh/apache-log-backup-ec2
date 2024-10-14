#!/bin/bash

# Variables
LOG_DIR="/var/log/apache2"  # Replace with your web server's log directory if different
BACKUP_DIR="/var/log/backup_logs"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="apache_logs_$TIMESTAMP.tar.gz"
S3_BUCKET="s3://your-s3-bucket-name"  # Replace with your S3 bucket name
RETENTION_DAYS=30  # Number of days to keep old backups

# Create a backup directory if not exists
mkdir -p $BACKUP_DIR

# Compress the log files
tar -czf $BACKUP_DIR/$ARCHIVE_NAME -C $LOG_DIR .

# Upload the compressed file to S3
aws s3 cp $BACKUP_DIR/$ARCHIVE_NAME $S3_BUCKET/

# Verify upload was successful
if [ $? -eq 0 ]; then
  echo "Log backup successful and uploaded to $S3_BUCKET."
else
  echo "Failed to upload backup to S3. Exiting."
  exit 1
fi

# Delete compressed file from local backup directory after upload
rm -f $BACKUP_DIR/$ARCHIVE_NAME

# Clean up log files older than retention days in local backup directory
find $LOG_DIR -type f -name "*.log" -mtime +$RETENTION_DAYS -exec rm -f {} \;

echo "Old logs older than $RETENTION_DAYS days cleaned up."

# Optional: Clear older backups in S3 after a certain period (uncomment if needed)
# aws s3 ls $S3_BUCKET/ --recursive | awk '$1 <= "'$(date --date="$RETENTION_DAYS days ago" +%Y-%m-%d)'" {print $4}' | while read -r file; do
#     aws s3 rm "$S3_BUCKET/$file"
# done
