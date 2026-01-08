# Getting Started Guide

## Quick Start (5 minutes)

### 1. Clone/Extract Project
```bash
cd path/to/project
```

### 2. Configure Environment
```bash
# Copy example configuration
cp .env.example .env

# Edit .env with your SQL Server details
# DB_SERVER=your_server
# DB_NAME=MarketingKPIDB
# DB_USER=your_user
# DB_PASSWORD=your_password
```

### 3. Setup Python Environment
```bash
# Create and activate virtual environment
python -m venv venv
venv\Scripts\activate  # Windows
source venv/bin/activate  # macOS/Linux

# Install dependencies
pip install -r python/requirements.txt
```

### 4. Setup SQL Server Database
**Option A: Using SQL Server Management Studio (GUI)**
1. Open SSMS
2. Connect to your SQL Server instance
3. Open `database/01_schema.sql` → Execute
4. Open `database/02_sample_data.sql` → Execute
5. Open `database/03_stored_procedures.sql` → Execute

**Option B: Using Command Line**
```bash
sqlcmd -S your_server -U your_user -P your_password -i database/01_schema.sql
sqlcmd -S your_server -U your_user -P your_password -i database/02_sample_data.sql
sqlcmd -S your_server -U your_user -P your_password -i database/03_stored_procedures.sql
```

### 5. Run ETL Pipeline
```bash
python python/main.py
```

### 6. Connect Power BI
1. Open Power BI Desktop
2. Get Data → SQL Server
3. Enter your server and database details
4. Import the required tables
5. Load measures from `powerbi/dax_measures.dax`

## Project Features

### Database Layer
- ✅ 6 main tables with optimized indexes
- ✅ 5 stored procedures for KPI calculations
- ✅ Sample data for testing and demonstration
- ✅ Referential integrity constraints

### Python Pipeline
- ✅ Database connection management
- ✅ Data extraction from SQL Server
- ✅ Data transformation and enrichment
- ✅ Multi-format export (CSV, JSON, Excel)
- ✅ Comprehensive logging
- ✅ Configuration management
- ✅ Error handling and recovery

### Power BI
- ✅ 50+ DAX measures and calculations
- ✅ Complete data model documentation
- ✅ Configuration templates
- ✅ 5 report page layouts
- ✅ Row-level security ready

## Key Components

### Tables
1. **Campaigns** - Marketing campaign details
2. **CampaignPerformance** - Daily metrics (impressions, clicks, conversions)
3. **Leads** - Lead information and status
4. **Revenue** - Transaction data
5. **DailyMetrics** - Aggregated daily summary
6. **TeamMetrics** - Team member performance

### Stored Procedures
1. `sp_GetDailyKPISummary` - Daily KPI snapshot
2. `sp_GetCampaignPerformance` - Campaign analytics
3. `sp_GetLeadConversionFunnel` - Lead funnel analysis
4. `sp_GetTeamPerformance` - Team metrics
5. `sp_GetROIByChannel` - Channel ROI comparison

### Python Modules
- **data_pipeline.py** - Database operations and ETL
- **config_manager.py** - Configuration and reporting
- **main.py** - Pipeline orchestration

## Common Tasks

### Run ETL for Specific Period
```bash
python python/main.py --start-date 2025-01-01 --end-date 2025-03-31
```

### Export Data as Excel
```bash
python python/main.py --output-format excel
```

### Test Database Connection
```bash
python -c "from python.data_pipeline import DatabaseConnector; \
db = DatabaseConnector('YOUR_SERVER', 'MarketingKPIDB', 'USER', 'PASS'); \
print('Connected!' if db.connect() else 'Failed')"
```

### View Available Logs
```bash
tail -f kpi_dashboard.log  # macOS/Linux
Get-Content kpi_dashboard.log -Tail 20 -Wait  # Windows
```

## Troubleshooting

### "Failed to connect to database"
- Check SQL Server is running: `sqlcmd -S your_server -Q "SELECT @@version"`
- Verify credentials in `.env` file
- Ensure ODBC Driver 17 is installed
- Check firewall rules

### "ModuleNotFoundError: No module named 'pyodbc'"
```bash
pip install -r python/requirements.txt
```

### "SQL file syntax error"
- Verify SQL Server version compatibility
- Check if database MarketingKPIDB already exists
- Ensure ODBC Driver 17 for SQL Server is installed

### Power BI won't connect to SQL Server
- Check SQL Server is accessible from your machine
- Verify network connectivity: `ping your_server`
- Enable SQL Server named pipes if using named instance
- Check Power BI Gateway configuration

## Next Steps

1. ✅ **Review Data Model** - Check `powerbi/data_model.md`
2. ✅ **Explore Sample Data** - Query the tables in SSMS
3. ✅ **Build Reports** - Create visualizations in Power BI
4. ✅ **Configure Refresh** - Set up scheduled data refresh
5. ✅ **Add Data Sources** - Integrate APIs (Google Analytics, Facebook Ads, etc.)

## Resources

- [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/)
- [Power BI Documentation](https://docs.microsoft.com/en-us/power-bi/)
- [Python pandas Documentation](https://pandas.pydata.org/docs/)
- [pyodbc Documentation](https://pypi.org/project/pyodbc/)

## Support

For help and questions:
1. Check README.md for detailed documentation
2. Review logs in `kpi_dashboard.log`
3. Check data integrity using SQL queries
4. Verify configuration in `.env` file

Good luck! 🚀
