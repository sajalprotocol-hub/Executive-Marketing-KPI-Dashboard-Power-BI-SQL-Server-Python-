# 📊 Dashboard Visual Guide & Architecture

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                   WEB INTERFACE (Streamlit)                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  Dashboard   │  │  Metrics     │  │  Database    │   ...    │
│  │  Overview    │  │  Analytics   │  │  Management  │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│         ↓                  ↓                  ↓                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │         Configuration & State Management                │   │
│  │    (.env file, session state, user inputs)             │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                            ↓
        ┌───────────────────┴───────────────────┐
        ↓                                       ↓
┌──────────────────────┐            ┌──────────────────────┐
│  PYTHON ETL LAYER    │            │  DATA VISUALIZER     │
│  ┌────────────────┐  │            │  ┌────────────────┐  │
│  │ main.py        │  │            │  │ Plotly Charts  │  │
│  │ Orchestrator   │  │            │  │ Tables & Cards │  │
│  └────────────────┘  │            │  └────────────────┘  │
│  ┌────────────────┐  │            │                      │
│  │data_pipeline   │  │            │  ┌────────────────┐  │
│  │Database Ops    │  │            │  │ Data Export    │  │
│  └────────────────┘  │            │  │ CSV/JSON/Excel │  │
│  ┌────────────────┐  │            │  └────────────────┘  │
│  │config_manager  │  │            │                      │
│  │Configuration   │  │            └──────────────────────┘
│  └────────────────┘  │                     ↑
└──────────────────────┘                     │
        ↓                                     │
┌──────────────────────────────────────────────────┐
│         SQL SERVER DATABASE LAYER                │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐ │
│  │ Campaigns  │  │ Performance│  │   Leads    │ │
│  └────────────┘  └────────────┘  └────────────┘ │
│  ┌────────────┐  ┌────────────┐                 │
│  │  Revenue   │  │DailyMetrics│  + Team Metrics│
│  └────────────┘  └────────────┘                 │
│                                                  │
│  5 Stored Procedures for KPI Calculation        │
│  Indexes & Constraints for Performance          │
└──────────────────────────────────────────────────┘
        ↓
┌──────────────────────────────────────────────────┐
│     POWER BI REPORTING LAYER (Optional)          │
│  - 50+ DAX Measures                              │
│  - 5 Report Page Templates                       │
│  - Interactive Dashboards                        │
│  - Executive Reports                             │
└──────────────────────────────────────────────────┘
```

---

## Dashboard Navigation Structure

```
MARKETING KPI DASHBOARD
│
├─ 📊 DASHBOARD
│  ├─ Project Overview (16 components, 2000+ doc lines)
│  ├─ Component Status (✅/❌ indicators)
│  ├─ Quick Start (6-step guide)
│  └─ Metrics Summary
│
├─ 📈 METRICS
│  ├─ Metric Cards (10 KPIs)
│  │  ├─ Total Revenue
│  │  ├─ ROAS & ROI
│  │  ├─ CPL & CAC
│  │  ├─ CTR & Conversion Rate
│  │  ├─ LTV & LTV:CAC
│  │  └─ Team Performance
│  ├─ Revenue Trend Chart (30-day line)
│  ├─ Channel Comparison (bar chart)
│  └─ Campaign Performance (detailed table)
│
├─ 🗄️ DATABASE
│  ├─ Database Statistics
│  ├─ Table Information
│  │  ├─ Campaigns (50 records)
│  │  ├─ Performance (150 records)
│  │  ├─ Leads (200 records)
│  │  ├─ Revenue (100 records)
│  │  ├─ DailyMetrics (30 records)
│  │  └─ TeamMetrics (10 records)
│  ├─ Stored Procedures (5 total)
│  └─ Configuration Settings
│
├─ ⚙️ CONFIGURATION
│  ├─ Environment Variables (.env)
│  ├─ Database Credentials
│  ├─ Refresh Schedule
│  ├─ Export Options
│  └─ Logging Settings
│
├─ 📚 DOCUMENTATION
│  ├─ Project Guides
│  │  ├─ README.md (full guide)
│  │  ├─ QUICKSTART.md (5-min setup)
│  │  ├─ DEPLOYMENT.md (detailed)
│  │  └─ DASHBOARD_GUIDE.md (this)
│  ├─ FAQ Section
│  └─ External Resources
│
└─ 🚀 DEPLOYMENT
   ├─ Project Status (6/8 complete)
   ├─ Timeline & Steps (8 total)
   ├─ Deployment Checklist
   └─ Quick Actions
      ├─ Connect Database
      ├─ Run ETL Pipeline
      └─ Generate Report
```

---

## Key Metrics Dashboard Layout

```
┌─────────────────────────────────────────────────────────────┐
│                    METRIC CARDS                             │
├────────────────────────────────────────┬────────────────────┤
│  Total Revenue        │  ROAS          │  ROI               │
│  $425,000            │  2.45x         │  145%              │
│  ↑ 12% vs last month │ ↑ 8%           │ ↑ 15%              │
├────────────────────────────────────────┼────────────────────┤
│  CPL                  │  CAC           │  LTV               │
│  $15.50              │  $48.50        │  $620              │
│  ↓ 5% (good)         │ ↓ 3% (good)    │ ↑ 22%              │
├────────────────────────────────────────┼────────────────────┤
│  CTR                  │  Conversion %  │  Lead Conv %       │
│  3.2%                │  4.5%          │  8.3%              │
│  ↑ 0.5%              │ ↑ 0.8%         │ ↑ 1.2%             │
└────────────────────────────────────────┴────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│          REVENUE TREND (30 Days)                            │
│     ▁    ╱╲      ╱╲  ╱╲                                     │
│    ╱ ╲  ╱  ╲    ╱  ╲╱  ╲  ╱╲  ╱╲                           │
│   ╱   ╲╱    ╲  ╱        ╲╱  ╲╱  ╲   ╱                      │
│  ──────────────────────────────────────                    │
│  Jan 1        Jan 8        Jan 15      Jan 30              │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────────┬──────────────────────────┐
│  CHANNEL COMPARISON      │  CAMPAIGN PERFORMANCE    │
│  Email: $150K            │                          │
│  Social: $120K   ▓▓▓     │  Campaign    │ Revenue  │
│  Paid Ad: $95K   ▓▓      │  ────────────┼──────────│
│  Organic: $60K   ▓       │  Summer Sale │ $85,000  │
│                          │  Spring Promo│ $75,000  │
│                          │  New Product │ $68,000  │
└──────────────────────────┴──────────────────────────┘
```

---

## Data Flow Through System

```
STEP 1: USER INPUT
├─ Configure database in Dashboard
└─ Set refresh schedule

        ↓

STEP 2: STREAMLIT APP (dashboard.py)
├─ Reads configuration from .env
├─ Updates session state
└─ Renders appropriate page

        ↓

STEP 3: USER CLICKS ACTION
├─ "Connect Database" → Test connection
├─ "Run ETL Pipeline" → Execute main.py
└─ "Generate Report" → Export data

        ↓

STEP 4: PYTHON PIPELINE (main.py)
├─ Loads configuration (config_manager.py)
├─ Initializes database connection (data_pipeline.py)
└─ Executes three-phase ETL:

    EXTRACT:
    ├─ Call sp_GetDailyKPISummary
    ├─ Call sp_GetCampaignPerformance
    ├─ Call sp_GetLeadConversionFunnel
    ├─ Call sp_GetTeamPerformance
    └─ Call sp_GetROIByChannel

    TRANSFORM:
    ├─ Enrich data with calculated fields
    ├─ Validate data quality
    ├─ Calculate advanced metrics
    └─ Aggregate time-series data

    LOAD:
    ├─ Insert transformed data
    ├─ Export to CSV/JSON/Excel
    ├─ Create reports
    └─ Update Power BI dataset

        ↓

STEP 5: UPDATE DASHBOARD
├─ Refresh metric cards
├─ Update charts
└─ Display status messages

        ↓

STEP 6: DISPLAY RESULTS
├─ Show updated metrics on Dashboard
├─ Display interactive charts
└─ Log actions to kpi_dashboard.log
```

---

## File Dependencies & Relationships

```
START_DASHBOARD.bat (Windows)
    │
    └─→ Activates venv
        │
        └─→ Installs python/requirements.txt
            │
            ├─→ streamlit, plotly, pandas, pyodbc, ...
            │
            └─→ Runs: streamlit run dashboard.py

dashboard.py (Main App - 553 lines)
    │
    ├─→ Imports config_manager.py for configuration
    │
    ├─→ Imports data_pipeline.py for database ops
    │
    ├─→ Uses Streamlit for UI rendering
    │
    ├─→ Uses Plotly for chart generation
    │
    └─→ Reads/writes .env file

main.py (ETL Orchestrator)
    │
    ├─→ Imports config_manager.py
    │   │
    │   ├─→ Reads .env file
    │   ├─→ Loads configuration
    │   └─→ Exports reports
    │
    ├─→ Imports data_pipeline.py
    │   │
    │   ├─→ Connects to SQL Server
    │   ├─→ Calls stored procedures
    │   ├─→ Transforms data
    │   └─→ Returns DataFrames
    │
    └─→ Runs complete ETL pipeline
        │
        ├─→ Extract from SQL Server
        ├─→ Transform with pandas
        ├─→ Load to files
        └─→ Generate reports

.env (Configuration)
    │
    ├─→ SQL Server connection string
    ├─→ Database credentials
    ├─→ Export settings
    ├─→ Refresh schedule
    └─→ Logging configuration

SQL Server Database
    │
    ├─→ 6 Tables
    │   ├─ Campaigns
    │   ├─ CampaignPerformance
    │   ├─ Leads
    │   ├─ Revenue
    │   ├─ DailyMetrics
    │   └─ TeamMetrics
    │
    └─→ 5 Stored Procedures
        ├─ sp_GetDailyKPISummary
        ├─ sp_GetCampaignPerformance
        ├─ sp_GetLeadConversionFunnel
        ├─ sp_GetTeamPerformance
        └─ sp_GetROIByChannel
```

---

## Component Integration Points

```
┌──────────────────────────────────────────────────────────┐
│                    STREAMLIT DASHBOARD                   │
│  (User Interface - Web-based, Interactive)               │
└──────────────┬───────────────────────────────┬───────────┘
               │                               │
        ┌──────▼──────┐             ┌──────────▼──────┐
        │ Streamlit   │             │   Plotly        │
        │ Rendering   │             │   Charts        │
        │ & State     │             │   & Tables      │
        └──────┬──────┘             └──────────┬──────┘
               │                               │
        ┌──────▼────────────────────────────────▼──────┐
        │        Configuration Management              │
        │         (.env, session_state)                │
        └──────┬────────────────────────────────┬──────┘
               │                                │
        ┌──────▼──────────────┐        ┌───────▼─────────┐
        │  Python Scripts     │        │  External APIs  │
        │  ├─ main.py         │        │  ├─ SQL Server  │
        │  ├─data_pipeline.py │        │  └─Power BI     │
        │  └─config_manager.py│        │                 │
        └──────┬──────────────┘        └───────┬─────────┘
               │                               │
        ┌──────▼───────────────────────────────▼──────┐
        │          SQL Server Database                │
        │  ├─ 6 Tables                               │
        │  ├─ 5 Stored Procedures                    │
        │  ├─ Indexes & Constraints                  │
        │  └─ Sample Data (540+ records)             │
        └────────────────────────────────────────────┘
```

---

## Quick Reference: Button Actions

| Button | Page | Action | Result |
|--------|------|--------|--------|
| **Connect Database** | Deployment | Tests SQL Server connection | Shows ✅ or ❌ |
| **Run ETL Pipeline** | Deployment | Executes main.py | Loads data from DB |
| **Generate Report** | Deployment | Exports metrics | Creates CSV/JSON/Excel |
| **Clear Cache** | Configuration | Clears app cache | Resets session state |
| **Save Settings** | Configuration | Updates .env file | Persists configuration |

---

## Feature Completeness Matrix

| Feature | Dashboard | Database | Python | PowerBI | Docs |
|---------|-----------|----------|--------|---------|------|
| Schema | ✅ Show | ✅ Exist | - | - | ✅ Doc |
| Data | ⏳ Live | ✅ Sample | ✅ Process | - | ✅ Doc |
| Metrics | ✅ 10 KPIs | ✅ 5 SPs | ✅ Calc | ✅ 50+ | ✅ Doc |
| Reports | ✅ Cards | - | ✅ Export | ✅ Template | ✅ Doc |
| Config | ✅ UI | - | ✅ File | ✅ Template | ✅ Doc |
| Visualization | ✅ Charts | - | - | ✅ Template | ✅ Doc |

---

**Dashboard Architecture Version:** 1.0.0  
**Documentation Status:** Complete  
**Production Ready:** ✅ Yes
