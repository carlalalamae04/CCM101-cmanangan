# UNIVERSITY OF EASTERN PANGASINAN
## College of Information Technology

**CCM101 – Cloud Computing**

# ENTERPRISE CLOUD ARCHITECT
## OPERATIONAL MANUAL

**Project:** Secure Multi-Tier Web Application (WordPress + MySQL)

---

### PREPARED BY

CABIDA, EXCEL JOHN T.  
CARALIPIO, IRIAN A.  
LATORRE, ANDREW G.  
MANANGAN, CARLA MAE G.  
TACOBAN, JOHN PAUL L.

**Section:** BSIT – 4G  
**Instructor:** Jenkielyn C. Torres  
**Date:** October 2026

---

# TABLE OF CONTENTS

1. [Introduction](#1-introduction)
   - 1.1 Purpose of the Manual
   - 1.2 Project Overview
   - 1.3 Objectives
   - 1.4 System Components
   - 1.5 System Architecture
2. [Environment Verification](#2-environment-verification)
   - 2.1 Start the Existing Virtual Machine
   - 2.2 Verify Ubuntu Server
   - 2.3 Verify Docker and Docker Compose
   - 2.4 Confirm the Project Directory
3. [Application Configuration](#3-application-configuration)
   - 3.1 Validate the Docker Compose Configuration
   - 3.2 Verify the Running Containers
   - 3.3 Verify the Application Port
   - 3.4 Verify Persistent Storage
   - 3.5 Reference Deployment Configuration
4. [Application Testing](#4-application-testing)
   - 4.1 Access WordPress
   - 4.2 Check Application Logs
   - 4.3 Verify WordPress and MySQL Operation
   - 4.4 Test Data Persistence
   - 4.5 Testing Results
5. [Security Configuration](#5-security-configuration)
   - 5.1 Review UFW Firewall Status
   - 5.2 Configure Firewall Rules
   - 5.3 Protect MySQL and Credentials
6. [Database Backup and Automation](#6-database-backup-and-automation)
   - 6.1 Create the Backup Directory
   - 6.2 Create the Backup Script
   - 6.3 Make the Script Executable
   - 6.4 Schedule the Backup Using Cron
   - 6.5 Recovery Considerations
7. [System Maintenance and Troubleshooting](#7-system-maintenance-and-troubleshooting)
   - 7.1 Routine Maintenance Commands
   - 7.2 Common Problems and Solutions
8. [Project Repository](#8-project-repository)
9. [Academic Integrity and AI Disclosure](#9-academic-integrity-and-ai-disclosure)
10. [Final Reflection](#final-reflection)

---

# 1. INTRODUCTION

## 1.1 Purpose of the Manual

This operational manual presents the procedures for configuring, testing, securing, and maintaining the Secure Multi-Tier Web Application developed using WordPress and MySQL. It follows the actual demonstration sequence, beginning with configuration verification and continuing through application testing, security, database backup, automation, and maintenance.

Ubuntu Server, Docker, Docker Compose, WordPress, and MySQL are already installed and running. This manual therefore focuses on operating and verifying the deployed environment. The reference configuration used to build the stack is documented in Section 3.5 so that the deployment can be reproduced on a new virtual machine.

## 1.2 Project Overview

The project demonstrates a containerized web application running on Ubuntu Server through Oracle VirtualBox. WordPress serves as the website and content management system, while MySQL stores website content and related data.

Docker Compose manages the services, network configuration, environment variables, and persistent database storage. The Windows host accesses the website through a configured network connection.

## 1.3 Objectives

The project aims to:

- Verify the existing Ubuntu Server, Docker, and Docker Compose environment.
- Document the reference deployment configuration so the stack can be rebuilt.
- Inspect the WordPress and MySQL configuration.
- Test website accessibility, database operation, and data persistence.
- Review firewall rules and basic security practices.
- Perform database backup and configure scheduled automation.
- Demonstrate maintenance and troubleshooting procedures.

## 1.4 System Components

| Component | Description |
|---|---|
| Windows Host | Computer used to manage the virtual machine and access the website. |
| Oracle VirtualBox | Provides the virtual machine environment. |
| Ubuntu Server 24.04 LTS | Hosts Docker and the application services. |
| Docker Engine | Runs the application containers. |
| Docker Compose | Manages the WordPress and MySQL services. |
| WordPress | Provides the website and content management interface. |
| MySQL 8.0 | Stores the WordPress database. |
| UFW | Manages Ubuntu host firewall rules. |
| Bash and Cron | Support backup automation and routine operations. |

## 1.5 System Architecture

The application follows this architecture:

```text
[Windows Host Computer / Web Browser]
         │ (Access via host port 8080)
         ▼
[Oracle VirtualBox / Ubuntu Server 24.04 LTS]
         │ (Runs)
         ▼
[Docker Engine + Docker Compose]
    │                    │
    ▼                    ▼
[WordPress Container]  [MySQL 8.0 Container]
    (Port 80)          (Port 3306)
    │                    │
    └────────┬───────────┘
             │ (Docker Network DB Connection)
             ▼
[Persistent MySQL Volume / Database Storage]
```

---

# 2. ENVIRONMENT VERIFICATION

## 2.1 Start the Existing Virtual Machine

- Open Oracle VirtualBox on the Windows host.
- Start the existing Ubuntu Server virtual machine.
- Log in using the configured Ubuntu account.
- Wait for the terminal to become available.

No new virtual machine or operating system installation is required for this demonstration.

## 2.2 Verify Ubuntu Server

Run:

```bash
lsb_release -a
```

To display the assigned network addresses, run:

```bash
hostname -I
```

These commands show the Ubuntu release information and network addresses.

## 2.3 Verify Docker and Docker Compose

Run:

```bash
docker --version
docker compose version
sudo systemctl status docker
```

The team previously recorded Docker version 29.1.3 and Docker Compose version 2.40.3. The versions displayed during the actual presentation should be used as the final evidence.

If the Docker service is stopped and needs to be started, run:

```bash
sudo systemctl start docker
```

## 2.4 Confirm the Project Directory

The primary Compose file used during the configuration check is located in `/home/ccmfinal`.

Run:

```bash
cd /home/ccmfinal
pwd
ls -la
```

Confirm that `docker-compose.yml` is present before executing Compose commands.

> **Important:** A second Compose project was also identified in `/home/ccmfinal/wordpress-stack`. The team must confirm which project is intended for the presentation. Do not delete containers or volumes while identifying the active project.

---

# 3. APPLICATION CONFIGURATION

## 3.1 Validate the Docker Compose Configuration

From `/home/ccmfinal`, run:

```bash
docker compose config
```

This command displays the resolved configuration and helps identify configuration or syntax errors. Review the following:

- WordPress and MySQL service definitions.
- Database name and credential variable names.
- WordPress database connection settings.
- Docker network configuration.
- Published application port.
- Persistent database volume.

The configuration previously displayed these service names: `wordpress`, `db`. It also displayed the Docker network `ccmfinal_default` and the persistent database volume `ccmfinal_mysql_data`.

Passwords and other secrets must not be included in screenshots or public documentation.

## 3.2 Verify the Running Containers

Run:

```bash
docker compose ps
docker ps
```

The first command displays containers associated with the Compose project loaded from the current directory. The second lists all running containers on the Docker host.

The latest configuration check showed container names `wordpress` and `mysql` for the primary project. Earlier, a separate project was found with containers named `wordpress_app` and `mysql_db`. Use the actual container and service names shown during the demonstration.

## 3.3 Verify the Application Port

Run:

```bash
docker port wordpress
```

For the primary Compose configuration, the expected mapping is:

**Ubuntu host port 8080 → WordPress container port 80**

The VirtualBox NAT forwarding rule must forward Windows host port 8080 to Ubuntu guest port 8080. If the browser cannot reach the website, check the actual Docker port mapping and VirtualBox forwarding configuration.

## 3.4 Verify Persistent Storage

Run:

```bash
docker volume ls
docker volume inspect ccmfinal_mysql_data
```

The Compose configuration uses a named volume for the MySQL data directory `/var/lib/mysql`. Persistent storage helps preserve database data when the container is restarted. The team should not remove the volume during routine testing.

## 3.5 Reference Deployment Configuration

The stack is defined by one Compose file and one environment file kept in `/home/ccmfinal`. The Compose file below is the one used by this project. The mysql_data volume stores the database, and the wordpress_data volume stores themes, plugins, and uploads.

**docker-compose.yml**

```yaml
services:
  db:
    image: mysql:8.0
    container_name: mysql
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    restart: unless-stopped
    depends_on:
      - db
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_NAME: ${MYSQL_DATABASE}
      WORDPRESS_DB_USER: ${MYSQL_USER}
      WORDPRESS_DB_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - wordpress_data:/var/www/html
volumes:
  mysql_data:
  wordpress_data:
```

Passwords are stored in a separate `.env` file in the same folder, not inside the Compose file. Restrict its permissions and keep it out of the repository:

**.env**

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=<strong-password>
MYSQL_ROOT_PASSWORD=<strong-password>
```

Set the file permissions:

```bash
chmod 600 .env
```

To rebuild the stack on a new virtual machine, install Docker, copy the project folder, create the `.env` file, and start the services:

```bash
cd /home/ccmfinal
docker compose up -d
docker compose ps
```

> **Important:** Do not run `docker compose down -v` unless deleting all data is intended, because the `-v` option removes the persistent volume.

---

# 4. APPLICATION TESTING

## 4.1 Access WordPress

**On the Windows host**

- Open a web browser.
- Visit `http://localhost:8080`, provided the VirtualBox port forwarding rule is configured correctly.
- Confirm that the WordPress website, setup page, or login page appears.
- If initial setup is complete, sign in using the authorized project account.

If the page does not load, check the container status, port mapping, VirtualBox networking, and firewall configuration.

## 4.2 Check Application Logs

Run the following commands from the primary project directory:

```bash
docker compose logs --tail 50
```

To inspect the WordPress logs:

```bash
docker logs wordpress --tail 50
```

To inspect the MySQL logs:

```bash
docker logs mysql --tail 30
```

Look for database connection errors, authentication failures, repeated restarts, or other service problems. If the container names differ, identify the correct containers with `docker compose ps` and use their actual names.

## 4.3 Verify WordPress and MySQL Operation

WordPress uses MySQL to store website content, settings, and other data. The primary Compose configuration specifies `db:3306` as the database host.

To test the application:

- Open the WordPress dashboard.
- Create a temporary test page or post.
- Save or publish the content.
- Open the page in the browser.
- Confirm that the saved content can be retrieved.

Successful saving and retrieval of content provide practical evidence that the application is operating. If an error occurs, review the logs and verify the database settings.

## 4.4 Test Data Persistence

After saving the test content, run:

```bash
docker compose restart
docker compose ps
```

Wait for the services to become available. Reopen WordPress and verify that the saved content is still present.

This test checks persistence across a container restart. It does not prove that a database backup can be restored.

## 4.5 Testing Results

| Test | Expected Result |
|---|---|
| Docker verification | Version information is displayed. |
| Compose validation | Configuration displays without errors. |
| Container status | WordPress and MySQL are running. |
| Website access | WordPress loads from the Windows host. |
| Database operation | Test content can be saved and retrieved. |
| Persistence | Content remains after restart. |

---

# 5. SECURITY CONFIGURATION

## 5.1 Review UFW Firewall Status

Run:

```bash
sudo ufw status verbose
```

Review whether UFW is active and inspect the existing rules before making changes.

## 5.2 Configure Firewall Rules

The following commands are examples for an environment that requires SSH administration and WordPress access through Ubuntu port 8080.

**Allow SSH if required:**

```bash
sudo ufw allow 22/tcp
```

**Allow the web application port:**

```bash
sudo ufw allow 8080/tcp
```

**Set the default policies:**

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

**Verify the rules:**

```bash
sudo ufw status numbered
```

If UFW is inactive and the rules have been reviewed, enable it:

```bash
sudo ufw enable
```

Before changing firewall settings, confirm that the SSH rule is appropriate for the environment to avoid losing remote access. Do not expose SSH unnecessarily.

Docker-published ports may interact with UFW differently from ordinary host services. Verify access from the actual host and network rather than assuming that UFW blocks all published container ports.

## 5.3 Protect MySQL and Credentials

The primary Compose configuration does not publish a MySQL host port. WordPress accesses the database through the internal Docker network, so MySQL does not need to be directly exposed for normal operation.

Security practices include:

- Keep database passwords private.
- Do not upload secret environment files to a public repository.
- Avoid publishing MySQL port 3306 unless required.
- Restrict access to the database.
- Keep persistent storage and backups protected.
- Apply appropriate updates to the operating system and application images.

The database passwords appeared in the terminal output used during preparation. Replace exposed credentials before public submission or production use, and remove them from screenshots and public documentation.

---

# 6. DATABASE BACKUP AND AUTOMATION

## 6.1 Create the Backup Directory

From the primary project directory, run:

```bash
cd /home/ccmfinal
mkdir -p backups
ls -ld backups
```

## 6.2 Create the Backup Script

Create the script:

```bash
nano /home/ccmfinal/backup.sh
```

Use the following example:

**backup.sh**

```bash
#!/bin/bash
set -euo pipefail
PROJECT_DIR="/home/ccmfinal"
BACKUP_DIR="$PROJECT_DIR/backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="$BACKUP_DIR/wordpress_${TIMESTAMP}.sql"
TEMP_FILE="${BACKUP_FILE}.tmp"
cd "$PROJECT_DIR"
mkdir -p "$BACKUP_DIR"
if docker compose exec -T db sh -c \
  'exec mysqldump --no-tablespaces -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' \
  > "$TEMP_FILE"; then
    if [ -s "$TEMP_FILE" ]; then
        mv "$TEMP_FILE" "$BACKUP_FILE"
        echo "Database backup completed: $BACKUP_FILE"
    else
        rm -f "$TEMP_FILE"
        echo "ERROR: The backup file is empty."
        exit 1
    fi
else
    rm -f "$TEMP_FILE"
    echo "ERROR: Database backup command failed."
    exit 1
fi
```

Save the file and exit the editor.

This script assumes that the MySQL service has the environment variables MYSQL_USER, MYSQL_PASSWORD, and MYSQL_DATABASE, as shown in the resolved Compose configuration. Verify the actual configuration before running the script.

## 6.3 Make the Script Executable

Run:

```bash
chmod +x /home/ccmfinal/backup.sh
```

Execute the script:

```bash
/home/ccmfinal/backup.sh
```

Check the generated files:

```bash
ls -lh /home/ccmfinal/backups
```

A successful backup should produce a non-empty SQL file. If the script fails, review the terminal output and MySQL logs before reporting success.

For a basic content check, run:

```bash
head -n 20 /home/ccmfinal/backups/wordpress_*.sql
```

Backup files may contain sensitive website data. Keep them in a protected location and do not commit them to a public repository.

## 6.4 Schedule the Backup Using Cron

Open the current user's crontab:

```bash
crontab -e
```

Add this entry to schedule the backup daily at 2:00 AM:

```cron
0 2 * * * /bin/bash /home/ccmfinal/backup.sh >> /home/ccmfinal/backups/cron.log 2>&1
```

Save the entry and verify the schedule:

```bash
crontab -l
```

The entry schedules the backup but does not prove that the task has run successfully. Verify the generated SQL file and review the Cron log after execution.

## 6.5 Recovery Considerations

A database dump protects database content but does not automatically include all WordPress media files or application configuration files.

For a more complete recovery plan:

- Protect and retain database backup files.
- Back up the WordPress uploads directory and relevant configuration files separately.
- Document the restoration procedure.
- Test restoring a backup in a safe environment.
- Verify that the restored website and database work correctly.

To restore a backup in a test environment, replace the timestamp with an existing file name:

```bash
cd /home/ccmfinal
docker compose exec -T db sh -c \
  'exec mysql -u"$MYSQL_USER" \
  -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' \
  < backups/wordpress_YYYYMMDD_HHMMSS.sql
```

To prevent the disk from filling up, remove backups older than seven days:

```bash
find /home/ccmfinal/backups -name 'wordpress_*.sql' \
  -mtime +7 -delete
```

Do not overwrite the active database during the classroom demonstration unless the team has an approved recovery plan.

---

# 7. SYSTEM MAINTENANCE AND TROUBLESHOOTING

## 7.1 Routine Maintenance Commands

Run Compose commands from the directory containing the correct Compose file.

| Task | Command |
|---|---|
| Check Compose services | `docker compose ps` |
| List running containers | `docker ps` |
| View service logs | `docker compose logs --tail 50` |
| Restart services | `docker compose restart` |
| Stop services | `docker compose stop` |
| Start stopped services | `docker compose start` |
| Inspect volumes | `docker volume ls` |
| Check firewall | `sudo ufw status verbose` |

## 7.2 Common Problems and Solutions

### WordPress Does Not Load

- Confirm that the WordPress container is running.
- Verify Docker port mapping and VirtualBox NAT forwarding.
- Check the firewall rules.
- Review the WordPress logs.

### WordPress Cannot Connect to MySQL

- Confirm that the MySQL container is running.
- Verify the database name, username, password, and service hostname.
- Confirm that WordPress uses `db:3306` when using the primary Compose configuration.
- Review WordPress and MySQL logs.

### Docker Compose Cannot Find the Configuration File

- Run `pwd` and `ls -la`.
- Change to the directory containing `docker-compose.yml` or `compose.yaml` before running Compose commands.

### The Backup Script Fails

- Confirm that the MySQL service is running.
- Verify the environment variable names.
- Confirm that the backup directory is writable.
- Review the command output and Cron log.
- Check that a non-empty SQL file was generated.

### Data Appears Missing After Restart

- Confirm that the correct Compose project and persistent volume are being used.
- Inspect the volume configuration and service logs.
- Do not remove volumes or recreate the application before identifying the cause.

---

# 8. PROJECT REPOSITORY

The repository should contain the files required to document the project and its operational procedures.

**Recommended structure:**

```text
Laboratory-10-Enterprise-Cloud-Architect/
├── README.md
├── architecture-diagram.png
├── docker-compose.yml
├── backup.sh
├── operational-manual.md
└── final-reflection.md
```

The README should summarize the project, technology stack, access URL, and operational commands. The architecture diagram should show the Windows host, Oracle VirtualBox, Ubuntu Server, Docker, WordPress, MySQL, network flow, and persistent database volume.

Do not upload database dumps, secret environment files, actual passwords, or other confidential information to a public repository.

---

# 9. ACADEMIC INTEGRITY AND AI DISCLOSURE

The team should accurately disclose any AI tools used for research, writing, configuration review, or troubleshooting according to the instructor's requirements.

All commands and technical explanations must be checked against the actual implementation. Screenshots, terminal outputs, and test results should come from the team's own environment and demonstration. The team remains responsible for understanding, validating, and presenting the submitted work.

---

# FINAL REFLECTION

This project demonstrates how a multi-tier web application can be operated using virtualization, Linux, Docker, and Docker Compose. WordPress provides the website interface, while MySQL stores its content and related data. Network configuration allows the website to be accessed from the host computer, and firewall rules and database access restrictions contribute to the security of the environment.

The testing procedures help verify application availability, database operation, and data persistence. The database backup script and Cron schedule provide a foundation for routine data protection and automation. Maintenance commands and troubleshooting procedures help identify common operational problems.

Through this activity, the team gained practical experience in inspecting configuration files, operating containers, reviewing logs, applying basic security controls, creating backups, and documenting maintenance procedures. These skills are important for operating reliable and maintainable cloud-based services.
