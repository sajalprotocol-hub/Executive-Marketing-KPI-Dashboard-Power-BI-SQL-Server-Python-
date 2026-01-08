-- Executive Marketing KPI Dashboard Database Schema
-- SQL Server Database Setup

-- Create Database
CREATE DATABASE MarketingKPIDB;
GO

USE MarketingKPIDB;
GO

-- 1. Marketing Campaigns Table
CREATE TABLE dbo.Campaigns (
    CampaignID INT PRIMARY KEY IDENTITY(1,1),
    CampaignName NVARCHAR(255) NOT NULL,
    CampaignType NVARCHAR(50) NOT NULL, -- Email, Social, Display, Content, etc.
    Channel NVARCHAR(100) NOT NULL, -- Email, LinkedIn, Facebook, Google Ads, etc.
    StartDate DATE NOT NULL,
    EndDate DATE,
    Budget DECIMAL(10, 2),
    Status NVARCHAR(20), -- Active, Completed, Planned
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- 2. Campaign Performance Table
CREATE TABLE dbo.CampaignPerformance (
    PerformanceID INT PRIMARY KEY IDENTITY(1,1),
    CampaignID INT NOT NULL,
    Date DATE NOT NULL,
    Impressions INT DEFAULT 0,
    Clicks INT DEFAULT 0,
    CTR DECIMAL(5, 2), -- Click-through rate
    Conversions INT DEFAULT 0,
    ConversionRate DECIMAL(5, 2),
    Spend DECIMAL(10, 2),
    Revenue DECIMAL(12, 2),
    ROI DECIMAL(10, 2),
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CampaignID) REFERENCES dbo.Campaigns(CampaignID),
    UNIQUE(CampaignID, Date)
);

-- 3. Lead Information Table
CREATE TABLE dbo.Leads (
    LeadID INT PRIMARY KEY IDENTITY(1,1),
    LeadName NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255),
    CompanyName NVARCHAR(255),
    Industry NVARCHAR(100),
    LeadSource NVARCHAR(100), -- Website, Campaign, Referral, etc.
    CampaignID INT,
    LeadScore INT DEFAULT 0, -- 0-100
    Status NVARCHAR(20), -- New, Qualified, Converted, Lost
    CreatedDate DATETIME DEFAULT GETDATE(),
    ConvertedDate DATETIME,
    FOREIGN KEY (CampaignID) REFERENCES dbo.Campaigns(CampaignID)
);

-- 4. Revenue Data Table
CREATE TABLE dbo.Revenue (
    RevenueID INT PRIMARY KEY IDENTITY(1,1),
    LeadID INT,
    CampaignID INT,
    TransactionDate DATE NOT NULL,
    Amount DECIMAL(12, 2),
    ProductCategory NVARCHAR(100),
    Status NVARCHAR(20), -- Completed, Pending, Cancelled
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (LeadID) REFERENCES dbo.Leads(LeadID),
    FOREIGN KEY (CampaignID) REFERENCES dbo.Campaigns(CampaignID)
);

-- 5. Marketing Metrics Table (Daily Summary)
CREATE TABLE dbo.DailyMetrics (
    MetricID INT PRIMARY KEY IDENTITY(1,1),
    MetricDate DATE NOT NULL,
    TotalImpressions INT DEFAULT 0,
    TotalClicks INT DEFAULT 0,
    TotalConversions INT DEFAULT 0,
    TotalLeadsGenerated INT DEFAULT 0,
    TotalLeadsConverted INT DEFAULT 0,
    TotalSpend DECIMAL(12, 2),
    TotalRevenue DECIMAL(12, 2),
    AverageCTR DECIMAL(5, 2),
    AverageConversionRate DECIMAL(5, 2),
    OverallROI DECIMAL(10, 2),
    MarketingEfficiency DECIMAL(5, 2), -- Revenue per Dollar Spent
    CreatedDate DATETIME DEFAULT GETDATE(),
    UNIQUE(MetricDate)
);

-- 6. Team Performance Table
CREATE TABLE dbo.TeamMetrics (
    TeamMetricID INT PRIMARY KEY IDENTITY(1,1),
    TeamMemberName NVARCHAR(255) NOT NULL,
    Department NVARCHAR(100),
    MetricDate DATE NOT NULL,
    LeadsGenerated INT DEFAULT 0,
    LeadsConverted INT DEFAULT 0,
    RevenueGenerated DECIMAL(12, 2),
    TargetRevenue DECIMAL(12, 2),
    TasksCompleted INT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    UNIQUE(TeamMemberName, MetricDate)
);

-- Create Indexes for Performance
CREATE INDEX idx_CampaignPerformance_CampaignID ON dbo.CampaignPerformance(CampaignID);
CREATE INDEX idx_CampaignPerformance_Date ON dbo.CampaignPerformance(Date);
CREATE INDEX idx_Leads_CampaignID ON dbo.Leads(CampaignID);
CREATE INDEX idx_Leads_Status ON dbo.Leads(Status);
CREATE INDEX idx_Revenue_CampaignID ON dbo.Revenue(CampaignID);
CREATE INDEX idx_Revenue_LeadID ON dbo.Revenue(LeadID);
CREATE INDEX idx_DailyMetrics_Date ON dbo.DailyMetrics(MetricDate);
CREATE INDEX idx_TeamMetrics_Date ON dbo.TeamMetrics(MetricDate);

GO
