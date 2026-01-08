#!/bin/bash
# Executive Marketing KPI Dashboard - Command Reference
# Quick reference for all deployment and operational commands

# ============================================================================
# CONFIGURATION SETUP
# ============================================================================

# 1. Edit environment configuration
nano .env                    # Linux/macOS
notepad .env                 # Windows

# Template configuration:
# DB_SERVER=localhost
# DB_NAME=MarketingKPIDB
# DB_USER=sa
# DB_PASSWORD=your_password
# EXPORT_FORMAT=csv
# OUTPUT_PATH=./output


# ============================================================================
# DATABASE SETUP
# ============================================================================

# Create database and tables
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -i database/01_schema.sql

# Load sample data (optional)
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -i database/02_sample_data.sql

# Create stored procedures
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -i database/03_stored_procedures.sql

# Verify database creation
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -Q "USE MarketingKPIDB; SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES;"

# List all tables
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -Q "USE MarketingKPIDB; SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;"


# ============================================================================
# PYTHON ENVIRONMENT
# ============================================================================

# Create virtual environment
python -m venv venv

# Activate virtual environment
venv\Scripts\activate       # Windows
source venv/bin/activate    # Linux/macOS

# Install dependencies
pip install -r python/requirements.txt

# Verify installation
pip list

# Deactivate virtual environment
deactivate


# ============================================================================
# ETL PIPELINE EXECUTION
# ============================================================================

# Run with default settings (last 90 days)
python python/main.py

# Run with custom date range
python python/main.py --start-date 2025-01-01 --end-date 2025-03-31

# Export to specific format
python python/main.py --output-format csv
python python/main.py --output-format json
python python/main.py --output-format excel

# Run with debugging enabled
# Set LOG_LEVEL=DEBUG in .env, then:
python python/main.py


# ============================================================================
# DEPLOYMENT VALIDATION
# ============================================================================

# Check deployment status
python deploy.py

# Test database connection
python -c "from python.data_pipeline import DatabaseConnector; db = DatabaseConnector('SERVER', 'DB', 'USER', 'PASS'); print('Connected!' if db.connect() else 'Failed')"

# List generated files
ls -la output/              # Linux/macOS
dir output\                 # Windows

# View logs
tail -f kpi_dashboard.log                    # Linux/macOS
Get-Content kpi_dashboard.log -Wait          # Windows
type kpi_dashboard.log                       # Windows (one-time)


# ============================================================================
# POWER BI OPERATIONS
# ============================================================================

# Export data for Power BI import
python python/main.py --output-format excel

# Run scheduled export
# Create Windows task scheduler or cron job:
# Windows: taskscheduler - Run python/main.py daily at 2 AM
# Linux: crontab -e - Add: 0 2 * * * cd /path && python python/main.py


# ============================================================================
# GIT OPERATIONS (Version Control)
# ============================================================================

# Initialize repository
git init

# Add all files
git add .

# Commit changes
git commit -m "Initial commit: Executive Marketing KPI Dashboard v1.0"

# View status
git status

# View logs
git log --oneline

# Push to remote
git push origin main


# ============================================================================
# TROUBLESHOOTING COMMANDS
# ============================================================================

# Check Python version
python --version

# Check SQL Server connectivity
sqlcmd -S SERVER_NAME -Q "SELECT @@version"

# List ODBC drivers
# Windows:
# Run: odbcad32
# Linux: odbcinst -q -d -n

# Install ODBC Driver 17
# Windows: Download from Microsoft
# macOS: brew install microsoft-odbc-17-for-sql-server
# Linux: apt-get install odbc-odbcsql

# Clear Python cache
find . -type d -name __pycache__ -exec rm -r {} +
find . -type f -name "*.pyc" -delete

# Reset database
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -Q "DROP DATABASE MarketingKPIDB"

# Reinstall dependencies (clean)
pip uninstall -r python/requirements.txt -y
pip install -r python/requirements.txt


# ============================================================================
# MONITORING & MAINTENANCE
# ============================================================================

# Monitor ETL execution
watch -n 60 'tail -10 kpi_dashboard.log'        # Linux/macOS

# Check database size
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -Q "USE MarketingKPIDB; sp_helpdb MarketingKPIDB;"

# Backup database
# SSMS: Right-click Database → Tasks → Backup
# Command:
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -Q "BACKUP DATABASE MarketingKPIDB TO DISK='C:\backup\MarketingKPIDB.bak';"

# Database maintenance
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -Q "USE MarketingKPIDB; DBCC SHRINKFILE (TransactionLog, 100);"


# ============================================================================
# DOCUMENTATION
# ============================================================================

# View available documentation
echo "Primary Documentation:"
echo "  • README.md - Full project guide"
echo "  • QUICKSTART.md - 5-minute setup"
echo "  • DEPLOYMENT.md - Step-by-step deployment"
echo "  • DEPLOYMENT_STATUS.md - Project status"
echo "  • LAUNCH.txt - Quick reference"

# Open documentation in editor
code README.md          # VS Code
gedit README.md         # Linux
open README.md          # macOS
start README.md         # Windows


# ============================================================================
# VS CODE TASKS
# ============================================================================

# Run from VS Code (Ctrl+Shift+B on Windows/Linux, Cmd+Shift+B on macOS):
# - Install Python Dependencies
# - Run ETL Pipeline
# - Create Database
# - Load Sample Data

# Or use command palette (Ctrl+Shift+P):
# Tasks: Run Task
# Select desired task


# ============================================================================
# SCHEDULE AUTOMATED JOBS
# ============================================================================

# Windows Task Scheduler:
# 1. Open Task Scheduler
# 2. Create Basic Task
# 3. Name: "ETL Pipeline"
# 4. Trigger: Daily at 2:00 AM
# 5. Action: Start program
# 6. Program: python
# 7. Arguments: C:\path\to\python\main.py

# Linux Crontab:
# crontab -e
# Add line:
# 0 2 * * * cd /path/to/project && /usr/bin/python3 python/main.py >> kpi_dashboard.log 2>&1

# macOS LaunchAgent:
# Create ~/Library/LaunchAgents/com.marketing.kpi.plist
# Configure to run at desired interval


# ============================================================================
# PROJECT STATISTICS
# ============================================================================

# Count lines of code
find python -name "*.py" | xargs wc -l

# Count documentation lines
wc -l *.md

# List all files
find . -type f | grep -E "\.(py|sql|md|json|env)$"

# Get project size
du -sh .                    # Linux/macOS
dir /s                      # Windows


# ============================================================================
# QUICK START COPY-PASTE
# ============================================================================

# Complete deployment in one go (manual steps required):

# 1. Configure
nano .env

# 2. Create database
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -i database/01_schema.sql

# 3. Load data
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -i database/02_sample_data.sql

# 4. Create procedures
sqlcmd -S SERVER_NAME -U USERNAME -P PASSWORD -i database/03_stored_procedures.sql

# 5. Setup Python
python -m venv venv
venv\Scripts\activate
pip install -r python/requirements.txt

# 6. Run ETL
python python/main.py

# 7. Validate
python deploy.py

# Done! Open Power BI and connect to SQL Server


# ============================================================================
# NOTES
# ============================================================================

# Replace placeholders:
# SERVER_NAME - Your SQL Server instance (e.g., localhost or server.domain.com)
# USERNAME - SQL Server username (e.g., sa)
# PASSWORD - SQL Server password
# PROJECT_PATH - Full path to project directory

# All commands assume current directory is project root
# For different locations, adjust paths accordingly
# Comments use # for bash/Linux and REM for Windows batch files
