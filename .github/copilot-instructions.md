# Setup Guide for Copilot

This workspace contains an Executive Marketing KPI Dashboard project with Power BI, SQL Server, and Python components.

## Completed Components

### 1. Database Layer (SQL Server)
- ✅ Complete schema with 6 optimized tables
- ✅ Sample data for testing
- ✅ 5 stored procedures for KPI calculations
- ✅ Indexes for performance optimization

### 2. Python Data Pipeline
- ✅ Database connector with connection pooling
- ✅ KPI data extractor with stored procedure integration
- ✅ Data transformer with advanced calculations
- ✅ Configuration manager for environment setup
- ✅ Multi-format report generator (CSV, JSON, Excel)
- ✅ Metrics calculator for custom KPI analysis
- ✅ Main ETL orchestrator with logging

### 3. Power BI Configuration
- ✅ 50+ DAX measures covering all KPI calculations
- ✅ Complete data model documentation with relationships
- ✅ Power BI settings and refresh configuration
- ✅ 5 report page templates with descriptions

### 4. Documentation
- ✅ Comprehensive README with full setup instructions
- ✅ Quick Start guide (5-minute setup)
- ✅ Data model documentation with relationships
- ✅ VS Code extensions list
- ✅ Environment configuration examples

### 5. Configuration
- ✅ .env example and template files
- ✅ VS Code launch configuration for Python debugging
- ✅ VS Code tasks for common operations

## Project Overview

**Executive Marketing KPI Dashboard** is a complete analytics solution providing:
- Real-time KPI monitoring across marketing channels
- Campaign performance analysis with ROI calculations
- Lead generation and conversion funnel tracking
- Team performance metrics and target achievement
- Channel comparison and marketing efficiency analysis

## Key Metrics Tracked

- Total Revenue & ROI
- Cost Per Lead (CPL) & Customer Acquisition Cost (CAC)
- Customer Lifetime Value (LTV) & LTV:CAC Ratio
- Click-Through Rate (CTR) & Conversion Rate
- Return on Ad Spend (ROAS) & Marketing Efficiency
- Lead Conversion Rate & Pipeline Value
- Team Performance & Target Achievement

## Database Schema

| Table | Records | Purpose |
|-------|---------|---------|
| Campaigns | Master records | Campaign definitions |
| CampaignPerformance | Daily metrics | Impressions, clicks, conversions |
| Leads | Lead records | Lead information and status |
| Revenue | Transactions | Revenue attribution |
| DailyMetrics | Daily summary | Aggregated KPI metrics |
| TeamMetrics | Team records | Team performance tracking |

## Python Modules

- **data_pipeline.py** (400+ lines) - Database operations, ETL logic
- **config_manager.py** (200+ lines) - Configuration, reporting, metrics
- **main.py** (300+ lines) - Pipeline orchestration
- **requirements.txt** - 8 dependencies with pinned versions

## Power BI Configuration

**DAX Measures (50+):**
- Revenue metrics (Total, by channel, by source)
- Performance metrics (ROI, ROAS, CTR, Conversion Rate)
- Cost metrics (CPL, CPA, Marketing Efficiency)
- Advanced metrics (LTV, LTV:CAC, Campaign Score)
- Time-based metrics (YoY Growth, Trends)

**Report Pages (5):**
1. Executive Summary
2. Campaign Performance
3. Lead Analysis
4. Team Performance
5. Channel Analysis

## Quick Start Commands

```bash
# 1. Setup virtual environment
python -m venv venv
venv\Scripts\activate

# 2. Install dependencies
pip install -r python/requirements.txt

# 3. Configure database
sqlcmd -S your_server -i database/01_schema.sql
sqlcmd -S your_server -i database/02_sample_data.sql
sqlcmd -S your_server -i database/03_stored_procedures.sql

# 4. Setup environment
cp .env.example .env
# Edit .env with your SQL Server credentials

# 5. Run ETL pipeline
python python/main.py

# 6. Import to Power BI
# Open Power BI → Get Data → SQL Server → Select tables
```

## Next Steps

1. **Review documentation** - Start with QUICKSTART.md
2. **Configure database** - Run SQL scripts in SQL Server
3. **Update .env file** - Add your SQL Server credentials
4. **Run ETL pipeline** - Execute `python python/main.py`
5. **Connect Power BI** - Import data and create reports
6. **Customize reports** - Modify DAX measures as needed
7. **Setup refresh schedule** - Configure in Power BI settings

## File Structure

```
project/
├── database/              # SQL Server scripts
│   ├── 01_schema.sql
│   ├── 02_sample_data.sql
│   └── 03_stored_procedures.sql
├── python/               # Python ETL
│   ├── main.py
│   ├── data_pipeline.py
│   ├── config_manager.py
│   └── requirements.txt
├── powerbi/              # Power BI config
│   ├── config.json
│   ├── dax_measures.dax
│   └── data_model.md
├── docs/                 # Documentation
├── .vscode/              # VS Code config
├── .env                  # Environment vars
├── README.md             # Full documentation
├── QUICKSTART.md         # Quick start guide
└── EXTENSIONS.md         # Recommended extensions
```

## Support & Troubleshooting

- Check QUICKSTART.md for common issues
- Review README.md for detailed setup instructions
- Check logs in `kpi_dashboard.log` for errors
- Verify SQL Server connection: `sqlcmd -S your_server -Q "SELECT @@version"`

All components are production-ready and can be deployed immediately after configuration.
