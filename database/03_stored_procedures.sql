-- Stored Procedures for KPI Calculations
USE MarketingKPIDB;
GO

-- Procedure: Get Daily KPI Summary
CREATE PROCEDURE sp_GetDailyKPISummary
    @Date DATE
AS
BEGIN
    SELECT 
        @Date AS ReportDate,
        COALESCE(SUM(cp.Impressions), 0) AS TotalImpressions,
        COALESCE(SUM(cp.Clicks), 0) AS TotalClicks,
        COALESCE(SUM(cp.Conversions), 0) AS TotalConversions,
        COUNT(DISTINCT CASE WHEN l.CreatedDate = @Date THEN l.LeadID END) AS NewLeadsGenerated,
        COUNT(DISTINCT CASE WHEN l.ConvertedDate = @Date THEN l.LeadID END) AS LeadsConverted,
        COALESCE(SUM(cp.Spend), 0) AS TotalSpend,
        COALESCE(SUM(r.Amount), 0) AS TotalRevenue,
        CASE WHEN SUM(cp.Clicks) > 0 THEN CAST(SUM(cp.Clicks) AS FLOAT) / SUM(cp.Impressions) * 100 ELSE 0 END AS AvgCTR,
        CASE WHEN SUM(cp.Conversions) > 0 THEN CAST(SUM(cp.Conversions) AS FLOAT) / SUM(cp.Clicks) * 100 ELSE 0 END AS AvgConversionRate,
        CASE WHEN SUM(cp.Spend) > 0 THEN ((COALESCE(SUM(r.Amount), 0) - SUM(cp.Spend)) / SUM(cp.Spend)) * 100 ELSE 0 END AS ROI,
        CASE WHEN SUM(cp.Spend) > 0 THEN COALESCE(SUM(r.Amount), 0) / SUM(cp.Spend) ELSE 0 END AS MarketingEfficiency
    FROM dbo.CampaignPerformance cp
    LEFT JOIN dbo.Campaigns c ON cp.CampaignID = c.CampaignID
    LEFT JOIN dbo.Leads l ON c.CampaignID = l.CampaignID
    LEFT JOIN dbo.Revenue r ON l.LeadID = r.LeadID AND r.TransactionDate = @Date
    WHERE cp.Date = @Date
    GROUP BY cp.Date;
END;

GO

-- Procedure: Get Campaign Performance Report
CREATE PROCEDURE sp_GetCampaignPerformance
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        c.CampaignID,
        c.CampaignName,
        c.CampaignType,
        c.Channel,
        c.Budget,
        SUM(cp.Impressions) AS TotalImpressions,
        SUM(cp.Clicks) AS TotalClicks,
        CASE WHEN SUM(cp.Impressions) > 0 THEN CAST(SUM(cp.Clicks) AS FLOAT) / SUM(cp.Impressions) * 100 ELSE 0 END AS CTR,
        SUM(cp.Conversions) AS TotalConversions,
        CASE WHEN SUM(cp.Clicks) > 0 THEN CAST(SUM(cp.Conversions) AS FLOAT) / SUM(cp.Clicks) * 100 ELSE 0 END AS ConversionRate,
        SUM(cp.Spend) AS TotalSpend,
        SUM(cp.Revenue) AS TotalRevenue,
        CASE WHEN SUM(cp.Spend) > 0 THEN ((SUM(cp.Revenue) - SUM(cp.Spend)) / SUM(cp.Spend)) * 100 ELSE 0 END AS ROI,
        COUNT(DISTINCT l.LeadID) AS LeadsGenerated,
        COUNT(DISTINCT CASE WHEN l.Status = 'Converted' THEN l.LeadID END) AS LeadsConverted
    FROM dbo.Campaigns c
    LEFT JOIN dbo.CampaignPerformance cp ON c.CampaignID = cp.CampaignID AND cp.Date BETWEEN @StartDate AND @EndDate
    LEFT JOIN dbo.Leads l ON c.CampaignID = l.CampaignID
    GROUP BY c.CampaignID, c.CampaignName, c.CampaignType, c.Channel, c.Budget
    ORDER BY SUM(cp.Revenue) DESC;
END;

GO

-- Procedure: Get Lead Conversion Funnel
CREATE PROCEDURE sp_GetLeadConversionFunnel
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        'New Leads' AS FunnelStage,
        COUNT(DISTINCT LeadID) AS Count,
        NULL AS Percentage
    FROM dbo.Leads
    WHERE CreatedDate BETWEEN @StartDate AND @EndDate
    
    UNION ALL
    
    SELECT 
        'Qualified Leads',
        COUNT(DISTINCT LeadID),
        NULL
    FROM dbo.Leads
    WHERE CreatedDate BETWEEN @StartDate AND @EndDate
    AND Status IN ('Qualified', 'Converted')
    
    UNION ALL
    
    SELECT 
        'Converted Customers',
        COUNT(DISTINCT LeadID),
        NULL
    FROM dbo.Leads
    WHERE ConvertedDate BETWEEN @StartDate AND @EndDate
    AND Status = 'Converted';
END;

GO

-- Procedure: Get Team Performance
CREATE PROCEDURE sp_GetTeamPerformance
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        TeamMemberName,
        Department,
        SUM(LeadsGenerated) AS TotalLeadsGenerated,
        SUM(LeadsConverted) AS TotalLeadsConverted,
        SUM(RevenueGenerated) AS TotalRevenue,
        MAX(TargetRevenue) AS TargetRevenue,
        SUM(RevenueGenerated) - MAX(TargetRevenue) AS VarianceFromTarget,
        CASE WHEN MAX(TargetRevenue) > 0 THEN CAST(SUM(RevenueGenerated) AS FLOAT) / MAX(TargetRevenue) * 100 ELSE 0 END AS TargetAchievementPercentage
    FROM dbo.TeamMetrics
    WHERE MetricDate BETWEEN @StartDate AND @EndDate
    GROUP BY TeamMemberName, Department
    ORDER BY SUM(RevenueGenerated) DESC;
END;

GO

-- Procedure: Get ROI by Campaign Channel
CREATE PROCEDURE sp_GetROIByChannel
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        c.Channel,
        COUNT(DISTINCT c.CampaignID) AS NumberOfCampaigns,
        SUM(cp.Spend) AS TotalSpend,
        SUM(cp.Revenue) AS TotalRevenue,
        CASE WHEN SUM(cp.Spend) > 0 THEN ((SUM(cp.Revenue) - SUM(cp.Spend)) / SUM(cp.Spend)) * 100 ELSE 0 END AS ROI,
        CASE WHEN SUM(cp.Spend) > 0 THEN SUM(cp.Revenue) / SUM(cp.Spend) ELSE 0 END AS MarketingEfficiency
    FROM dbo.Campaigns c
    LEFT JOIN dbo.CampaignPerformance cp ON c.CampaignID = cp.CampaignID AND cp.Date BETWEEN @StartDate AND @EndDate
    WHERE cp.Date BETWEEN @StartDate AND @EndDate
    GROUP BY c.Channel
    ORDER BY SUM(cp.Revenue) DESC;
END;

GO
