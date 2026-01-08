-- Sample Data for Executive Marketing KPI Dashboard
USE MarketingKPIDB;
GO

-- Insert Sample Campaigns
INSERT INTO dbo.Campaigns (CampaignName, CampaignType, Channel, StartDate, EndDate, Budget, Status)
VALUES
    ('Q1 Email Campaign', 'Email', 'Email', '2025-01-01', '2025-03-31', 5000.00, 'Completed'),
    ('LinkedIn Lead Generation', 'Social', 'LinkedIn', '2025-01-15', NULL, 8000.00, 'Active'),
    ('Google Ads Q1', 'Display', 'Google Ads', '2025-01-01', '2025-03-31', 15000.00, 'Completed'),
    ('Facebook Brand Awareness', 'Social', 'Facebook', '2025-02-01', NULL, 10000.00, 'Active'),
    ('Content Marketing Blitz', 'Content', 'Website', '2025-01-01', '2025-06-30', 12000.00, 'Active');

-- Insert Sample Campaign Performance Data
INSERT INTO dbo.CampaignPerformance (CampaignID, Date, Impressions, Clicks, CTR, Conversions, ConversionRate, Spend, Revenue, ROI)
VALUES
    (1, '2025-01-01', 50000, 2500, 5.0, 125, 5.0, 200.00, 3750.00, 1775.00),
    (1, '2025-01-02', 52000, 2704, 5.2, 135, 5.0, 210.00, 4050.00, 1830.00),
    (2, '2025-01-15', 100000, 4000, 4.0, 200, 5.0, 500.00, 8000.00, 1500.00),
    (3, '2025-01-01', 200000, 8000, 4.0, 320, 4.0, 800.00, 16000.00, 1900.00),
    (4, '2025-02-01', 150000, 6000, 4.0, 240, 4.0, 600.00, 12000.00, 1900.00),
    (5, '2025-01-05', 75000, 2250, 3.0, 90, 4.0, 300.00, 4500.00, 1400.00);

-- Insert Sample Leads
INSERT INTO dbo.Leads (LeadName, Email, CompanyName, Industry, LeadSource, CampaignID, LeadScore, Status, CreatedDate, ConvertedDate)
VALUES
    ('John Smith', 'john.smith@example.com', 'Tech Corp', 'Technology', 'Campaign', 1, 85, 'Converted', '2025-01-05', '2025-01-20'),
    ('Sarah Johnson', 'sarah.j@example.com', 'Finance Inc', 'Finance', 'Campaign', 2, 90, 'Converted', '2025-01-20', '2025-02-10'),
    ('Michael Brown', 'mbrown@example.com', 'Manufacturing Co', 'Manufacturing', 'Campaign', 3, 75, 'Qualified', '2025-01-10', NULL),
    ('Emily Davis', 'emily.d@example.com', 'Retail Group', 'Retail', 'Website', 5, 65, 'Qualified', '2025-01-15', NULL),
    ('David Wilson', 'dwilson@example.com', 'Healthcare Ltd', 'Healthcare', 'Campaign', 4, 88, 'Converted', '2025-02-05', '2025-02-25');

-- Insert Sample Revenue Data
INSERT INTO dbo.Revenue (LeadID, CampaignID, TransactionDate, Amount, ProductCategory, Status)
VALUES
    (1, 1, '2025-01-20', 5000.00, 'Enterprise Software', 'Completed'),
    (2, 2, '2025-02-10', 8500.00, 'SaaS License', 'Completed'),
    (5, 4, '2025-02-25', 6000.00, 'Consulting Services', 'Completed'),
    (1, 1, '2025-02-01', 3500.00, 'Support Package', 'Completed'),
    (2, 2, '2025-02-15', 2000.00, 'Training', 'Pending');

-- Insert Daily Metrics
INSERT INTO dbo.DailyMetrics (MetricDate, TotalImpressions, TotalClicks, TotalConversions, TotalLeadsGenerated, TotalLeadsConverted, TotalSpend, TotalRevenue, AverageCTR, AverageConversionRate, OverallROI, MarketingEfficiency)
VALUES
    ('2025-01-01', 302000, 12500, 445, 35, 12, 1800.00, 35750.00, 4.14, 3.56, 1886.11, 19.86),
    ('2025-01-02', 310000, 13204, 465, 38, 13, 1920.00, 38050.00, 4.26, 3.52, 1882.81, 19.82),
    ('2025-01-05', 375000, 15250, 540, 45, 15, 2200.00, 45300.00, 4.07, 3.54, 1959.09, 20.59),
    ('2025-02-01', 350000, 14000, 480, 42, 14, 2100.00, 42000.00, 4.0, 3.43, 1900.00, 20.0);

-- Insert Team Metrics
INSERT INTO dbo.TeamMetrics (TeamMemberName, Department, MetricDate, LeadsGenerated, LeadsConverted, RevenueGenerated, TargetRevenue, TasksCompleted)
VALUES
    ('Alice Manager', 'Marketing', '2025-01-01', 15, 5, 22500.00, 20000.00, 12),
    ('Bob Specialist', 'Sales', '2025-01-01', 12, 4, 18000.00, 18000.00, 10),
    ('Carol Executive', 'Marketing', '2025-01-01', 8, 3, 15000.00, 15000.00, 8),
    ('Alice Manager', 'Marketing', '2025-02-01', 18, 6, 27000.00, 20000.00, 14),
    ('Bob Specialist', 'Sales', '2025-02-01', 14, 5, 21000.00, 18000.00, 12);

GO
