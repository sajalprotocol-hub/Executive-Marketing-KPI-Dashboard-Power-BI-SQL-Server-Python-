# DEPLOYMENT GUIDE

## Executive Marketing KPI Dashboard - Complete Deployment Instructions

---

## Project Status: ✅ READY FOR DEPLOYMENT

All components have been created and verified. The project is ready to be deployed to a live environment.

---

## Deployment Checklist

### ✅ Completed
- [x] Project directory structure created
- [x] Database schema and stored procedures
- [x] Python ETL pipeline with all modules
- [x] Power BI configuration and DAX measures
- [x] Comprehensive documentation
- [x] Environment configuration templates
- [x] VS Code development setup
- [x] Python dependencies configured
- [x] Deployment validation scripts

### ⏳ Required Before Running
- [ ] Update `.env` with SQL Server credentials
- [ ] Create SQL Server database
- [ ] Load sample data
- [ ] Create stored procedures
- [ ] Run ETL pipeline
- [ ] Connect Power BI
- [ ] Configure report refresh schedule

---

## Step-by-Step Deployment

### Step 1: Configure Environment Variables

**File:** `.env`

```bash
# SQL Server Configuration
DB_SERVER=your_server_name_or_localhost
DB_NAME=MarketingKPIDB
DB_USER=your_username
DB_PASSWORD=your_secure_password

# Output Configuration
EXPORT_FORMAT=csv
OUTPUT_PATH=./output
ARCHIVE_PATH=./archive

# Logging Configuration
LOG_LEVEL=INFO
LOG_FILE=./logs/kpi_dashboard.log

# Data Refresh Configuration
REFRESH_INTERVAL_MINUTES=60
AUTO_REFRESH_ENABLED=true

# Report Configuration
REPORT_EMAIL_ENABLED=false
REPORT_EMAIL_RECIPIENTS=
```

**⚠️ Important:** Never commit `.env` file to version control. Use `.env.example` as template.

---

### Step 2: Create SQL Server Database

#### Option A: Using SQL Server Management Studio (Recommended)

1. Open **SQL Server Management Studio (SSMS)**
2. Connect to your SQL Server instance
3. In Object Explorer, right-click **Databases** → **New Database**
4. Enter database name: `MarketingKPIDB`
5. Click OK
6. Open a new query window (Ctrl+N)
7. Open `database/01_schema.sql` (File → Open → File)
8. Press **F5** to execute
9. Repeat steps 6-8 for `02_sample_data.sql`
10. Repeat steps 6-8 for `03_stored_procedures.sql`

#### Option B: Using Command Line (sqlcmd)

```bash
# Create schema and tables
sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -i database/01_schema.sql

# Load sample data (optional)
sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -i database/02_sample_data.sql

# Create stored procedures
sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -i database/03_stored_procedures.sql
```

#### Verification

```bash
# Test database creation
sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -Q "SELECT @@version; USE MarketingKPIDB; SELECT COUNT(*) as TableCount FROM INFORMATION_SCHEMA.TABLES;"
```

Expected output:
```
Microsoft SQL Server 2019 (...)
(6 rows affected)
```

---

### Step 3: Verify Database Installation

```bash
# List all tables
sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -Q "USE MarketingKPIDB; SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;"
```

Should show:
- Campaigns
- CampaignPerformance
- Leads
- Revenue
- DailyMetrics
- TeamMetrics

---

### Step 4: Run ETL Pipeline

```bash
# Activate virtual environment (if not already active)
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Run ETL with default settings (last 90 days)
python python/main.py

# Run ETL with custom date range
python python/main.py --start-date 2025-01-01 --end-date 2025-03-31

# Run ETL with specific output format
python python/main.py --output-format excel
```

**Output:** Generated files in `./output/` directory
- campaigns.csv (or .xlsx, .json)
- leads_funnel.csv
- team_performance.csv
- roi_by_channel.csv

**Logs:** Check `kpi_dashboard.log` for execution details

---

### Step 5: Connect Power BI

#### Create New Power BI Report

1. **Open Power BI Desktop**
2. Click **Get data** → **SQL Server**
3. **Server:** Enter your SQL Server instance name
4. **Database:** Leave blank (will select after)
5. Click **OK** or **Connect**
6. Enter credentials if prompted
7. In Navigator window, select database: **MarketingKPIDB**
8. Check these tables:
   - ✓ Campaigns
   - ✓ CampaignPerformance
   - ✓ Leads
   - ✓ Revenue
   - ✓ DailyMetrics
   - ✓ TeamMetrics
9. Click **Load**
10. Wait for data to load (may take a few minutes)

#### Add DAX Measures

1. In Power BI, click **New Measure** (or Modeling tab)
2. Open `powerbi/dax_measures.dax` file in text editor
3. Copy all DAX code
4. Paste into Power BI Measure Editor
5. Each measure will be created automatically

#### Create Report Pages

Based on `powerbi/config.json`, create 5 report pages:

1. **Executive Summary**
   - Total Revenue, ROI, ROAS cards
   - Revenue trend chart (monthly)
   - Campaign status overview
   - KPI gauges

2. **Campaign Performance**
   - Campaign comparison table
   - ROI by campaign chart
   - Budget vs. Actual spend
   - CTR and Conversion Rate trends

3. **Lead Analysis**
   - Lead conversion funnel
   - Lead source distribution
   - Lead score analysis
   - Status distribution pie chart

4. **Team Performance**
   - Revenue by team member (bar chart)
   - Target achievement %
   - Leads generated leaderboard
   - Individual performance trends

5. **Channel Analysis**
   - ROI by channel (column chart)
   - Spend distribution (pie chart)
   - Performance metrics table
   - Channel efficiency comparison

---

### Step 6: Configure Automatic Refresh

#### Power BI Desktop (Testing)

1. Home tab → **Refresh** → **Refresh Now**
2. Or press **Ctrl+R**

#### Power BI Service (Production)

1. Publish report to Power BI Service
2. Go to **Datasets** in Power BI Service
3. Find your dataset → Click **⋯** → **Settings**
4. **Data source credentials** → Edit credentials
   - Enter SQL Server username and password
   - Check "Use encrypted connection"
5. **Scheduled refresh**
   - Toggle **On**
   - **Frequency:** Daily (or desired interval)
   - **Time:** Select off-peak hours (e.g., 2:00 AM)
   - **Timezone:** Your local timezone
   - **Send refresh failure notification:** Enable

---

## Post-Deployment Verification

### 1. Database Verification

```bash
# Check table row counts
sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -Q "
USE MarketingKPIDB;
SELECT 'Campaigns' as TableName, COUNT(*) as RowCount FROM Campaigns
UNION ALL
SELECT 'Leads', COUNT(*) FROM Leads
UNION ALL
SELECT 'Revenue', COUNT(*) FROM Revenue
UNION ALL
SELECT 'CampaignPerformance', COUNT(*) FROM CampaignPerformance
UNION ALL
SELECT 'DailyMetrics', COUNT(*) FROM DailyMetrics
UNION ALL
SELECT 'TeamMetrics', COUNT(*) FROM TeamMetrics
"
```

### 2. ETL Pipeline Verification

```bash
# Check output files were created
ls -la output/  # macOS/Linux
dir output\    # Windows

# Check logs
cat kpi_dashboard.log  # macOS/Linux
type kpi_dashboard.log # Windows
```

### 3. Power BI Verification

- [ ] All 6 tables loaded
- [ ] 50+ DAX measures created
- [ ] 5 report pages created
- [ ] Automatic refresh configured
- [ ] Reports display data correctly

---

## Troubleshooting

### Database Connection Errors

**Error:** `Failed to connect to database`

**Solutions:**
1. Verify SQL Server is running
2. Check credentials in `.env`
3. Test connection:
   ```bash
   sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -Q "SELECT @@version"
   ```
4. Ensure SQL Server is accepting remote connections
5. Check firewall rules

### Missing Python Modules

**Error:** `ModuleNotFoundError: No module named 'X'`

**Solution:**
```bash
pip install -r python/requirements.txt
```

### Database Already Exists

**Error:** `Cannot create database. Database already exists.`

**Solution:**
```bash
sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -Q "DROP DATABASE MarketingKPIDB"
# Then re-run 01_schema.sql
```

### Permission Denied

**Error:** `Permission denied to write to output directory`

**Solution:**
```bash
mkdir output logs
chmod 755 output logs  # macOS/Linux
```

### Power BI Connection Fails

1. Check SQL Server credentials in Power BI
2. Verify SQL Server is accessible from your machine
3. Test: `ping YOUR_SERVER`
4. Check Windows Firewall allows SQL Server port (default 1433)
5. For named instances, use: `SERVER\INSTANCENAME`

---

## Performance Optimization

### Database Level
- Indexes created on date and key foreign key columns
- Use indexed stored procedures for reports
- Archive data older than 2 years to separate database

### Power BI Level
- Limit visuals per page to 10-15 maximum
- Use aggregation tables for large datasets
- Enable incremental refresh for fact tables
- Use query folding where possible

### ETL Level
- Process data in batches
- Use connection pooling
- Run ETL during off-peak hours
- Monitor log files for performance issues

---

## Maintenance Schedule

### Daily
- Monitor Power BI dashboard for data errors
- Check ETL logs for failures

### Weekly
- Review data refresh success rate
- Check for new campaigns/leads

### Monthly
- Analyze KPI trends
- Update forecasts
- Audit user access

### Quarterly
- Archive old data
- Review and optimize slow queries
- Plan for new features

---

## Support & Resources

### Documentation
- [README.md](README.md) - Full project documentation
- [QUICKSTART.md](QUICKSTART.md) - 5-minute setup guide
- [powerbi/data_model.md](powerbi/data_model.md) - Data model reference

### External Resources
- [SQL Server Documentation](https://docs.microsoft.com/sql/)
- [Power BI Documentation](https://docs.microsoft.com/power-bi/)
- [Python Documentation](https://docs.python.org/)
- [pyodbc Documentation](https://pypi.org/project/pyodbc/)

### Getting Help
1. Check logs in `kpi_dashboard.log`
2. Review QUICKSTART.md for common issues
3. Verify database connection
4. Check Power BI data refresh history

---

## Deployment Sign-Off

- **Project Name:** Executive Marketing KPI Dashboard
- **Version:** 1.0
- **Deployment Date:** _______________
- **Deployed By:** _______________
- **Status:** ☐ Development ☐ Testing ☐ Production
- **Notes:** _______________________________________________

---

**Next Steps:** Begin with Step 1: Configure Environment Variables
