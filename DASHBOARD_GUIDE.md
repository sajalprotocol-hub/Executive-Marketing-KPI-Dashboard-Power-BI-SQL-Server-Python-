# Dashboard Guide

## Executive Marketing KPI Dashboard - Web Interface

The Streamlit dashboard provides a unified, integrated interface for the entire Marketing KPI system.

---

## Features

### 📊 Dashboard
- **Project Overview** - Quick status of all components
- **Component Status** - Shows which parts are ready
- **Metrics Overview** - List of all tracked KPIs
- **Quick Start Guide** - 6-step deployment process

### 📈 Metrics Page
- **Revenue Metrics** - Total revenue, ROAS, ROI, Average Order Value
- **Cost Metrics** - CPL, CAC, Marketing Efficiency, CPM
- **Engagement Metrics** - CTR, Conversion Rate, Lead Conversion Rate
- **Performance Charts** - Interactive Plotly visualizations
- **Campaign Performance** - Detailed campaign analytics table

### 🗄️ Database Page
- **Database Statistics** - Tables, indexes, stored procedures count
- **Table Management** - View all 6 database tables
- **Stored Procedures** - List of all 5 KPI procedures
- **Configuration Settings** - Connection details
- **Backup & Recovery** - Database backup tools

### ⚙️ Configuration Page
- **Environment Variables** - All .env configuration options
- **Update Settings** - Form to modify configuration
- **Advanced Settings** - Refresh schedule, logging options
- **Auto-Refresh** - Configure automatic data refresh interval

### 📚 Documentation Page
- **Available Docs** - Access all project documentation
- **External Resources** - Links to SQL Server, Power BI, Python docs
- **FAQ Section** - Common questions and answers
- **Download Option** - Export documentation files

### 🚀 Deployment Page
- **Project Status** - Development, Testing, Documentation, Production status
- **Deployment Steps** - 6-step process with duration and status
- **Quick Actions** - Buttons to connect database, run ETL, generate reports
- **Deployment Checklist** - Track completion progress
- **Timeline Estimate** - Total time needed for deployment

---

## Starting the Dashboard

### Windows
1. Double-click `START_DASHBOARD.bat`
2. Dashboard opens automatically at http://localhost:8501

### Linux/macOS
```bash
chmod +x start_dashboard.sh
./start_dashboard.sh
```

### Manual Start
```bash
# Activate virtual environment
python -m venv venv
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r python/requirements.txt

# Start dashboard
streamlit run dashboard.py
```

---

## Dashboard Navigation

### Using the Sidebar
- Click any menu item to navigate
- View project version and status
- See quick statistics

### Menu Options
1. **📊 Dashboard** - Main overview and quick start
2. **📈 Metrics** - All KPIs and performance charts
3. **🗄️ Database** - Database management and status
4. **⚙️ Configuration** - Settings and configuration
5. **📚 Documentation** - Help and resources
6. **🚀 Deployment** - Deployment status and actions

---

## Key Sections

### Dashboard Metrics
- **Total Components**: 16 (all project files)
- **Documentation**: 2,000+ lines
- **Python Code**: 900+ lines
- **DAX Measures**: 50+

### Component Status
**Database Layer**
- ✅ Schema (01_schema.sql)
- ✅ Sample Data (02_sample_data.sql)
- ✅ Stored Procedures (03_stored_procedures.sql)
- ✅ Indexes & Constraints

**Python Pipeline**
- ✅ main.py (Orchestration)
- ✅ data_pipeline.py (ETL)
- ✅ config_manager.py (Configuration)
- ✅ requirements.txt (Dependencies)

### Available Metrics
**Revenue**: Total Revenue, Revenue by Channel, ROAS, ROI, AOV
**Cost**: CPL, CAC, Marketing Efficiency, CPM
**Engagement**: CTR, Conversion Rate, Lead Conversion Rate, Session Duration
**Customer**: Customer LTV, LTV:CAC Ratio, Lead Score
**Team**: Revenue Generated, Target Achievement, Leads Generated, Performance Rank

---

## Interactive Features

### Configuration Management
- Update database credentials
- Change export format
- Configure refresh intervals
- Adjust logging levels
- All changes saved to .env

### Quick Actions
- **Connect Database** - Test SQL Server connection
- **Run ETL Pipeline** - Execute data extraction and transformation
- **Generate Report** - Create marketing analytics report

### Deployment Tracking
- Progress bar showing completion percentage
- Checklist of 8 deployment requirements
- Visual indicators (✅/❌) for each item
- Estimated timeline with breakdown by step

### Analytics Charts
- **Revenue Trend** - 30-day revenue line chart
- **Channel Comparison** - Revenue by marketing channel
- **Campaign Performance** - Detailed campaign metrics table

---

## System Requirements

- **Python 3.8+**
- **Streamlit 1.28+**
- **Plotly 5.17+**
- **Pandas 2.0+**
- **4GB RAM minimum**

---

## Troubleshooting

### Dashboard won't start
```bash
# Clear Streamlit cache
streamlit cache clear

# Reinstall dependencies
pip install -r python/requirements.txt --force-reinstall

# Start again
streamlit run dashboard.py
```

### Charts not displaying
- Ensure Plotly is installed: `pip install plotly`
- Clear browser cache (Ctrl+Shift+Del)
- Refresh page (F5)

### Configuration not saving
- Check .env file permissions
- Ensure file is not read-only
- Verify path is correct

### Slow performance
- Reduce chart update frequency
- Clear browser cache
- Close other applications
- Restart dashboard

---

## Features Overview

### Page Layout
- **Wide layout** - Maximizes screen space
- **Sidebar navigation** - Easy access to all sections
- **Responsive design** - Works on desktop, tablet, mobile
- **Dark/Light mode** - Toggle theme in Streamlit settings

### Data Visualization
- **Interactive charts** - Hover for details, zoom, pan
- **Color-coded tables** - Easy to scan data
- **Progress indicators** - Visual completion status
- **Status badges** - ✅/❌ for quick reference

### User Experience
- **Consistent styling** - Uniform look and feel
- **Clear headings** - Easy navigation
- **Helpful descriptions** - Context for each metric
- **Quick links** - Direct access to resources

---

## Configuration via Dashboard

### Database Settings
- Server: SQL Server instance name
- Database: MarketingKPIDB
- Username: SQL Server user
- Password: SQL Server password
- Connection Pool: Enabled
- Timeout: 30 seconds

### Export Options
- Format: CSV, JSON, Excel
- Output Path: ./output
- Archive Path: ./archive
- Timestamp: Automatic

### Refresh Schedule
- Enabled: Yes/No
- Interval: 15-480 minutes
- Type: Scheduled
- Notification: On failure

### Logging
- Level: INFO, DEBUG, WARNING, ERROR
- Max Size: 10-1000 MB
- Retention: 7-365 days
- Format: Detailed with timestamps

---

## Dashboard Statistics

**Displayed Metrics:**
- 10 KPI cards with current values and trends
- 2 interactive Plotly charts
- 6 database tables with stats
- 5 stored procedures
- 50+ DAX measures
- 6 deployment steps
- 8 checklist items

**Supported Actions:**
- 3 quick action buttons
- 1 configuration form
- 5 expandable sections
- 1 progress indicator
- 6 navigation menu items

---

## Integration Points

### Connected Systems
- **SQL Server** - Database connection testing
- **ETL Pipeline** - Run from dashboard
- **Power BI** - Configuration instructions
- **Streamlit** - Frontend interface
- **Plotly** - Visualizations

### Data Flow
1. Dashboard collects configuration
2. Configuration saved to .env
3. ETL pipeline reads configuration
4. ETL connects to SQL Server
5. Data extracted and transformed
6. Reports generated and exported
7. Dashboard displays updated metrics

---

## Advanced Configuration

### Streamlit Settings
File: `~/.streamlit/config.toml`

```toml
[theme]
primaryColor = "#1f77b4"
backgroundColor = "#ffffff"
secondaryBackgroundColor = "#f0f2f6"
textColor = "#262730"
font = "sans serif"

[client]
showErrorDetails = true
toolbarMode = "minimal"
```

### Custom CSS
Styling embedded in dashboard.py using Streamlit markdown

### Session State
Maintains navigation state and form data across reruns

---

## Support & Help

### Built-in Documentation
- FAQ section in Documentation page
- Links to official documentation
- Configuration examples
- Troubleshooting tips

### External Resources
- SQL Server: https://docs.microsoft.com/sql/
- Power BI: https://docs.microsoft.com/power-bi/
- Streamlit: https://docs.streamlit.io/
- Python: https://docs.python.org/

### Getting Help
1. Check Dashboard FAQ
2. Review README.md
3. Check DEPLOYMENT.md
4. Review application logs

---

## Next Steps After Starting Dashboard

1. **Configure** - Update database credentials in ⚙️ Configuration
2. **Connect** - Click "Connect Database" in 🚀 Deployment
3. **Run ETL** - Click "Run ETL Pipeline" in 🚀 Deployment
4. **Monitor** - Watch metrics update in 📈 Metrics
5. **Deploy** - Complete checklist in 🚀 Deployment
6. **Report** - Click "Generate Report" to create analytics

---

**Dashboard Version:** 1.0.0  
**Last Updated:** January 8, 2026  
**Status:** ✅ Production Ready
