// Power BI Data Model Relationships
// This file documents the relationships and structure for the Power BI data model

[Data Model Structure]

Tables:
1. Campaigns (Fact/Dimension)
   - Primary Key: CampaignID
   - Fields: CampaignName, CampaignType, Channel, StartDate, EndDate, Budget, Status

2. CampaignPerformance (Fact)
   - Primary Key: PerformanceID
   - Foreign Key: CampaignID -> Campaigns
   - Fields: Date, Impressions, Clicks, CTR, Conversions, ConversionRate, Spend, Revenue, ROI

3. Leads (Fact/Dimension)
   - Primary Key: LeadID
   - Foreign Key: CampaignID -> Campaigns
   - Fields: LeadName, Email, CompanyName, Industry, LeadSource, LeadScore, Status, CreatedDate, ConvertedDate

4. Revenue (Fact)
   - Primary Key: RevenueID
   - Foreign Keys: LeadID -> Leads, CampaignID -> Campaigns
   - Fields: TransactionDate, Amount, ProductCategory, Status

5. TeamMetrics (Fact)
   - Primary Key: TeamMetricID
   - Fields: TeamMemberName, Department, MetricDate, LeadsGenerated, LeadsConverted, RevenueGenerated, TargetRevenue, TasksCompleted

6. DailyMetrics (Fact)
   - Primary Key: MetricID
   - Fields: MetricDate, TotalImpressions, TotalClicks, TotalConversions, etc.

[Relationships]

1-to-Many Relationships:
- Campaigns (1) ---> CampaignPerformance (*)
  - Foreign Key: CampaignPerformance[CampaignID] -> Campaigns[CampaignID]
  - Cross Filter: Both
  - Active: Yes

- Campaigns (1) ---> Leads (*)
  - Foreign Key: Leads[CampaignID] -> Campaigns[CampaignID]
  - Cross Filter: Both
  - Active: Yes

- Leads (1) ---> Revenue (*)
  - Foreign Key: Revenue[LeadID] -> Leads[LeadID]
  - Cross Filter: Both
  - Active: Yes

- Campaigns (1) ---> Revenue (*)
  - Foreign Key: Revenue[CampaignID] -> Campaigns[CampaignID]
  - Cross Filter: Both
  - Active: Yes

[Date Dimension - RECOMMENDED]
Create a Date table for better time intelligence:

Date Table Fields:
- DateKey (Primary Key)
- FullDate
- Year
- Quarter
- Month
- MonthName
- Week
- Day
- DayOfWeek
- DayName
- IsWeekend
- IsMonthEnd
- IsQuarterEnd
- IsYearEnd

Relationships to Date Table:
- DailyMetrics[MetricDate] ---> Date[FullDate]
- CampaignPerformance[Date] ---> Date[FullDate]
- Leads[CreatedDate] ---> Date[FullDate]
- Revenue[TransactionDate] ---> Date[FullDate]
- TeamMetrics[MetricDate] ---> Date[FullDate]

[Query Performance Optimization]

Recommended Indexes in SQL Server:
1. Composite index on CampaignPerformance: (CampaignID, Date)
2. Index on Leads: Status, CreatedDate
3. Index on Revenue: LeadID, TransactionDate
4. Index on DailyMetrics: MetricDate

[Data Import Settings]

- Import Mode: Recommended for interactive reports
- Query Folding: Enable where possible
- Row Level Security: Configure by Department/TeamMember if needed
- Incremental Refresh: Set up for large tables (CampaignPerformance, Revenue)

Incremental Refresh Configuration:
- Table: CampaignPerformance
  - RangeStart: RangeStart (date parameter)
  - RangeEnd: RangeEnd (date parameter)
  - Store full history but refresh only recent data

[Hierarchy Definitions]

1. Campaign Hierarchy
   - Channel > CampaignType > CampaignName

2. Time Hierarchy
   - Year > Quarter > Month > Date

3. Team Hierarchy
   - Department > TeamMemberName

4. Lead Status Hierarchy
   - Status (New > Qualified > Converted/Lost)
