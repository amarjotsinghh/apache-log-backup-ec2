# apache-log-backup-ec2
Here’s a sample `README.md` file for the `backup_logs.sh` script:

```markdown
# Backup Logs Script - `backup_logs.sh`

## Overview

This script automates the process of compressing web server access logs, archiving them to an AWS S3 bucket, and cleaning up older logs to free up disk space on your EC2 instance.

### Features:
- Compresses log files from the specified directory (default: `/var/log/apache2` for Apache).
- Uploads the compressed log archive to an S3 bucket.
- Deletes the compressed archive from the local backup directory after a successful upload.
- Cleans up local log files older than a specified number of days.
- Optional cleanup of old backups in the S3 bucket.

---

## Prerequisites

1. **AWS CLI installed and configured**: Ensure that the AWS CLI is installed and properly configured with the necessary IAM permissions to access the S3 bucket.
   - To install the AWS CLI:  
     ```bash
     sudo apt-get install awscli
     ```
   - To configure the AWS CLI:
     ```bash
     aws configure
     ```
2. **S3 Bucket**: The S3 bucket must already exist where the logs will be archived.
3. **Log Directory**: The directory where your web server stores access logs (default: `/var/log/apache2`).

---

## Script Usage

### 1. Create the Script
On your EC2 instance, create a new file and paste the contents of the `backup_logs.sh` script.

```bash
nano backup_logs.sh
```

### 2. Make the Script Executable
Set executable permissions on the script:
```bash
chmod +x backup_logs.sh
```

### 3. Run the Script Manually
To run the script manually, simply execute:
```bash
./backup_logs.sh
```

### 4. Schedule Automatic Backups (Optional)
You can schedule the script to run automatically at a specified time using cron. For example, to schedule it to run daily at midnight:

```bash
crontab -e
```
Add the following line to the cron file:
```bash
0 0 * * * /path/to/backup_logs.sh >> /var/log/backup_script.log 2>&1
```

---

## Script Breakdown

### Variables:
- **LOG_DIR**: The directory containing the web server logs (default: `/var/log/apache2`).
- **BACKUP_DIR**: The directory where compressed log files will temporarily be stored.
- **S3_BUCKET**: The name of the S3 bucket where logs will be archived.
- **RETENTION_DAYS**: The number of days to keep old logs in the local directory.

### Key Steps:
1. **Compression**: The script compresses log files from the `$LOG_DIR` into a `.tar.gz` archive stored in `$BACKUP_DIR`.
2. **Upload to S3**: The script uploads the compressed archive to the specified S3 bucket.
3. **Cleanup**:
   - After a successful upload, the local archive is deleted from `$BACKUP_DIR`.
   - Logs older than `$RETENTION_DAYS` are deleted from the local log directory.
   - Optionally, older backups can be removed from the S3 bucket (this feature is commented out in the script by default).

---

## Customization

- **S3 Bucket**: Replace `your-s3-bucket-name` in the script with the actual name of your S3 bucket.
- **Log Directory**: Modify the `LOG_DIR` variable if your logs are stored in a directory other than `/var/log/apache2`.
- **Retention Period**: Adjust the `RETENTION_DAYS` variable to control how long old logs are kept locally.
- **Cron Frequency**: Customize the cron schedule as needed for automatic backups.

---

## Example

To backup logs from `/var/log/apache2`, archive them in `s3://my-backup-bucket`, and clean up logs older than 30 days, use the following settings in your script:

```bash
LOG_DIR="/var/log/apache2"
BACKUP_DIR="/var/log/backup_logs"
S3_BUCKET="s3://my-backup-bucket"
RETENTION_DAYS=30
```

---

## Troubleshooting

- **AWS CLI Errors**: Ensure that the AWS CLI is properly configured and that the IAM role or user has sufficient permissions to upload to the specified S3 bucket.
- **Cron Job Issues**: Check the cron logs (`/var/log/syslog` on most systems) for any issues with the scheduled job.

---

## License

This script is released under the MIT License. Feel free to use and modify it as needed.
```

This `README.md` provides a comprehensive guide for users to understand, set up, and customize the `backup_logs.sh` script for their environment.
