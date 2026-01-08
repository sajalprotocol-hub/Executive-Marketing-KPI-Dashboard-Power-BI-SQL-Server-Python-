# Executive Marketing KPI Dashboard

A comprehensive analytics solution for monitoring marketing performance metrics, campaign ROI, lead generation, and team performance using Power BI, SQL Server, and Python.

## Overview

This dashboard provides executive-level insights into marketing operations through:
- **Real-time KPI monitoring** across all marketing channels
- **Campaign performance analysis** with ROI calculations
- **Lead generation and conversion** funnel tracking
- **Team performance metrics** and target achievement
- **Channel comparison** and marketing efficiency analysis

## Architecture

```
Executive Marketing KPI Dashboard
├── Database Layer (SQL Server)
│   ├── Marketing Campaigns
│   ├── Campaign Performance
│   ├── Lead Tracking
│   ├── Revenue Attribution
│   └── Team Metrics
├── Data Pipeline (Python)
│   ├── Data Extraction
│   ├── Data Transformation
│   ├── Data Loading
│   └── Reporting
└── Visualization Layer (Power BI)
    ├── Executive Summary
    ├── Campaign Performance
    ├── Lead Analysis
    ├── Team Performance
    └── Channel Analysis
```

## Project Structure

```
.
├── database/                 # SQL Server scripts
│   ├── 01_schema.sql        # Database schema and tables
│   ├── 02_sample_data.sql   # Sample data for testing
│   └── 03_stored_procedures.sql  # KPI calculation procedures
├── python/                   # Python ETL scripts
│   ├── main.py              # Main ETL orchestration
│   ├── data_pipeline.py     # Data extraction and transformation
│   ├── config_manager.py    # Configuration and reporting
│   ├── requirements.txt     # Python dependencies
│   └── kpi_dashboard.log    # Application logs
├── powerbi/                 # Power BI configuration
│   ├── config.json          # Power BI settings
│   ├── dax_measures.dax     # DAX measures and calculations
│   ├── data_model.md        # Data model documentation
│   └── queries/             # Power BI queries
├── docs/                    # Documentation
├── .env                     # Environment configuration
└── README.md               # This file
```

## Key Metrics

### Core KPIs
- **Total Revenue**: Aggregated revenue from all sources
- **Marketing ROI**: Return on marketing investment
- **ROAS (Return on Ad Spend)**: Revenue per dollar spent
- **CTR (Click-Through Rate)**: Click engagement percentage
- **Conversion Rate**: Lead to customer conversion percentage
- **Customer Lifetime Value (LTV)**: Average value per customer

### Cost Metrics
- **Cost Per Lead (CPL)**: Average cost to acquire a lead
- **Customer Acquisition Cost (CAC)**: Cost per converted customer
- **Marketing Efficiency**: Revenue per dollar spent
- **Budget Utilization**: Actual spend vs. budget percentage

### Lead Metrics
- **Total Leads Generated**: Count of new leads
- **Lead Conversion Rate**: Percentage of leads converted
- **Average Lead Score**: Lead quality indicator
- **Lead Status Distribution**: New, Qualified, Converted, Lost

### Team Metrics
- **Revenue Generated**: Total revenue per team member
- **Target Achievement**: Performance vs. goal
- **Leads Generated**: Lead count per team member
- **Tasks Completed**: Productivity measure

## Prerequisites

### System Requirements
- Windows, macOS, or Linux
- Python 3.8+
- SQL Server 2016 or later
- Power BI Desktop (latest version)
- 4GB RAM minimum

### Required Software
- Python 3.8 or higher
- SQL Server Management Studio (SSMS)
- Power BI Desktop
- ODBC Driver 17 for SQL Server

### SQL Server Setup
1. SQL Server instance running and accessible
2. Administrative privileges to create databases
3. ODBC driver installed (ODBC Driver 17 for SQL Server)

## Installation & Setup

### 1. Database Setup

```bash
# Connect to SQL Server using SQL Server Management Studio
# Run the following scripts in order:

# 1. Create database and tables
sqlcmd -S SERVER_NAME -i database/01_schema.sql

# 2. Load sample data (optional)
sqlcmd -S SERVER_NAME -i database/02_sample_data.sql

# 3. Create stored procedures
sqlcmd -S SERVER_NAME -i database/03_stored_procedures.sql
```

Or use SQL Server Management Studio GUI:
1. Open SSMS
2. Connect to your SQL Server instance
3. Open each SQL file and execute

### 2. Environment Configuration

Copy and customize `.env.example` to `.env`:

```bash
cp .env.example .env
```

Edit `.env` with your SQL Server credentials:

```env
# SQL Server Configuration
DB_SERVER=your_server_name
DB_NAME=MarketingKPIDB
DB_USER=your_username
DB_PASSWORD=your_password

# Output Configuration
EXPORT_FORMAT=csv
OUTPUT_PATH=./output
ARCHIVE_PATH=./archive
```

### 3. Python Environment Setup

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r python/requirements.txt
```

### 4. Power BI Setup

1. Open Power BI Desktop
2. Create new report
3. Get data from SQL Server:
   - Server: Your SQL Server instance
   - Database: MarketingKPIDB
4. Select tables:
   - Campaigns
   - CampaignPerformance
   - Leads
   - Revenue
   - DailyMetrics
   - TeamMetrics
5. Load the data model configuration from `powerbi/data_model.md`
6. Add DAX measures from `powerbi/dax_measures.dax`
7. Create report pages based on `powerbi/config.json`

## Running the ETL Pipeline

### Command Line

```bash
# Run full ETL pipeline with default settings (last 90 days)
python python/main.py

# Run with custom date range
python python/main.py --start-date 2025-01-01 --end-date 2025-03-31

# Export to specific format
python python/main.py --output-format excel

# Combine options
python python/main.py --start-date 2025-01-01 --output-format json
```

### Python Script

```python
from python.main import MarketingKPIDashboard
from datetime import datetime

# Initialize dashboard
dashboard = MarketingKPIDashboard()

# Run full pipeline
dashboard.run_full_pipeline(
    start_date=datetime(2025, 1, 1),
    end_date=datetime(2025, 3, 31)
)
```

## Power BI Report Pages

### 1. Executive Summary
- Key metrics cards (Revenue, ROI, ROAS)
- Trend charts (Monthly revenue, lead generation)
- Campaign status overview
- Team performance highlights

### 2. Campaign Performance
- Campaign comparison table
- ROI by campaign chart
- Budget vs. Spend analysis
- CTR and Conversion Rate trends
- Performance by channel

### 3. Lead Analysis
- Lead conversion funnel
- Lead source distribution
- Lead score analysis
- Status distribution
- Conversion timeline

### 4. Team Performance
- Team member revenue comparison
- Target achievement dashboard
- Lead generation by team member
- Top performers leaderboard
- Individual performance trends

### 5. Channel Analysis
- Channel ROI comparison
- Spend distribution by channel
- Performance metrics by channel
- Channel efficiency analysis
- Recommended budget allocation

## KPI Definitions

### Revenue Metrics
- **Total Revenue**: Sum of all completed transactions
- **Revenue by Campaign**: Revenue attributed to specific campaign
- **Revenue by Channel**: Revenue from each marketing channel
- **Average Order Value**: Revenue divided by number of transactions

### Efficiency Metrics
- **Marketing Efficiency**: Revenue / Total Spend
- **Cost Per Lead**: Total Spend / Total Leads Generated
- **Customer Acquisition Cost**: Total Spend / Number of Conversions
- **Return on Investment**: (Revenue - Spend) / Spend × 100%

### Engagement Metrics
- **Click-Through Rate**: Total Clicks / Total Impressions × 100%
- **Conversion Rate**: Total Conversions / Total Clicks × 100%
- **Lead Conversion Rate**: Converted Leads / Total Leads × 100%
- **Cost Per Click**: Total Spend / Total Clicks

## Data Refresh Strategy

### Automated Refresh (Power BI)
- Configured in `powerbi/config.json`
- Default: Every hour
- Type: Scheduled refresh
- Incremental refresh for large tables

### Manual Refresh
```bash
# Run ETL pipeline
python python/main.py

# Power BI: Refresh > Refresh Now
```

## API Integration

The Python pipeline can be extended to integrate with:
- Google Analytics API
- Facebook Ads API
- LinkedIn Campaign Manager API
- HubSpot API
- Salesforce API

See `python/data_pipeline.py` for integration patterns.

## Troubleshooting

### Database Connection Issues
```bash
# Test SQL Server connection
python -c "from python.data_pipeline import DatabaseConnector; \
  db = DatabaseConnector('YOUR_SERVER', 'MarketingKPIDB', 'USER', 'PASS'); \
  print(db.connect())"
```

### Missing Python Dependencies
```bash
# Verify all packages are installed
pip list

# Reinstall requirements
pip install -r python/requirements.txt --force-reinstall
```

### Power BI Data Refresh Issues
1. Check data source credentials
2. Verify SQL Server is accessible
3. Check firewall rules
4. Review Power BI refresh logs

### ODBC Driver Issues
```bash
# Windows - Check installed drivers
odbcad32  # Opens ODBC Data Source Administrator

# Linux/macOS - Install driver
# Ubuntu/Debian
sudo apt-get install odbc-odbcsql

# macOS
brew install microsoft-odbc-17-for-sql-server
```

## Performance Optimization

### Database Level
- Enable table compression for large tables
- Create clustered indexes on date columns
- Use incremental refresh for fact tables
- Archive old data (>2 years) to archive database

### Power BI Level
- Use query folding where possible
- Aggregate data at source (use SQL views)
- Limit report page visuals to 10-15 maximum
- Use aggregation tables for large measures
- Enable incremental refresh

### Python Level
- Use batch inserts instead of row-by-row
- Leverage pandas vectorized operations
- Implement connection pooling
- Use async operations for large data transfers

## Security Considerations

- Never commit `.env` file with credentials to version control
- Use SQL Server authentication with strong passwords
- Implement row-level security (RLS) in Power BI
- Encrypt Power BI connections
- Audit data access and modifications
- Use service accounts for automated refreshes

## Maintenance

### Weekly Tasks
- Monitor data refresh success
- Check for failed jobs in logs
- Review new leads and campaigns

### Monthly Tasks
- Analyze performance metrics
- Update forecasts based on trends
- Review and adjust KPI targets
- Audit user access in Power BI

### Quarterly Tasks
- Archive old data
- Update campaign strategy based on insights
- Review and optimize underperforming channels
- Plan for upcoming campaigns

## License

This project is proprietary and confidential.

## Contact & Support

For issues, questions, or contributions, contact the Marketing Analytics team.

## Changelog

### Version 1.0 (Initial Release)
- Database schema with core marketing tables
- Python ETL pipeline with full transformation
- Power BI configuration and DAX measures
- Sample data and documentation
- Stored procedures for KPI calculations
