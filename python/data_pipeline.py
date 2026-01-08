import pyodbc
import pandas as pd
from datetime import datetime, timedelta
import logging
from typing import Dict, List, Tuple

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class DatabaseConnector:
    """Manages connections to SQL Server database."""
    
    def __init__(self, server: str, database: str, username: str, password: str):
        """
        Initialize database connector.
        
        Args:
            server: SQL Server instance name
            database: Database name
            username: SQL Server username
            password: SQL Server password
        """
        self.server = server
        self.database = database
        self.username = username
        self.password = password
        self.connection = None
    
    def connect(self) -> bool:
        """Establish connection to SQL Server."""
        try:
            conn_string = (
                f'Driver={{ODBC Driver 17 for SQL Server}};'
                f'Server={self.server};'
                f'Database={self.database};'
                f'UID={self.username};'
                f'PWD={self.password};'
            )
            self.connection = pyodbc.connect(conn_string)
            logger.info(f"Successfully connected to {self.database}")
            return True
        except Exception as e:
            logger.error(f"Failed to connect to database: {str(e)}")
            return False
    
    def disconnect(self):
        """Close database connection."""
        if self.connection:
            self.connection.close()
            logger.info("Database connection closed")
    
    def execute_query(self, query: str) -> pd.DataFrame:
        """
        Execute SELECT query and return results as DataFrame.
        
        Args:
            query: SQL SELECT query
            
        Returns:
            DataFrame with query results
        """
        try:
            if not self.connection:
                self.connect()
            return pd.read_sql(query, self.connection)
        except Exception as e:
            logger.error(f"Query execution failed: {str(e)}")
            return pd.DataFrame()
    
    def execute_procedure(self, procedure_name: str, params: List = None) -> pd.DataFrame:
        """
        Execute stored procedure and return results.
        
        Args:
            procedure_name: Name of stored procedure
            params: Procedure parameters
            
        Returns:
            DataFrame with results
        """
        try:
            if not self.connection:
                self.connect()
            
            cursor = self.connection.cursor()
            if params:
                cursor.execute(f"EXEC {procedure_name} {','.join(['?' for _ in params])}", params)
            else:
                cursor.execute(f"EXEC {procedure_name}")
            
            columns = [description[0] for description in cursor.description]
            data = cursor.fetchall()
            cursor.close()
            
            return pd.DataFrame(data, columns=columns)
        except Exception as e:
            logger.error(f"Procedure execution failed: {str(e)}")
            return pd.DataFrame()
    
    def insert_data(self, table_name: str, data: pd.DataFrame) -> bool:
        """
        Insert data into table.
        
        Args:
            table_name: Target table name
            data: DataFrame with data to insert
            
        Returns:
            Success status
        """
        try:
            if not self.connection:
                self.connect()
            
            cursor = self.connection.cursor()
            for index, row in data.iterrows():
                columns = ','.join(data.columns)
                placeholders = ','.join(['?' for _ in data.columns])
                values = tuple(row)
                
                query = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
                cursor.execute(query, values)
            
            self.connection.commit()
            cursor.close()
            logger.info(f"Successfully inserted {len(data)} rows into {table_name}")
            return True
        except Exception as e:
            logger.error(f"Data insertion failed: {str(e)}")
            self.connection.rollback()
            return False


class KPIDataExtractor:
    """Extracts marketing KPI data from database."""
    
    def __init__(self, db_connector: DatabaseConnector):
        """Initialize data extractor with database connector."""
        self.db = db_connector
    
    def get_campaign_performance(self, start_date: datetime, end_date: datetime) -> pd.DataFrame:
        """Get campaign performance metrics."""
        return self.db.execute_procedure(
            'sp_GetCampaignPerformance',
            [start_date.date(), end_date.date()]
        )
    
    def get_daily_kpi_summary(self, date: datetime) -> pd.DataFrame:
        """Get daily KPI summary."""
        return self.db.execute_procedure(
            'sp_GetDailyKPISummary',
            [date.date()]
        )
    
    def get_lead_conversion_funnel(self, start_date: datetime, end_date: datetime) -> pd.DataFrame:
        """Get lead conversion funnel data."""
        return self.db.execute_procedure(
            'sp_GetLeadConversionFunnel',
            [start_date.date(), end_date.date()]
        )
    
    def get_team_performance(self, start_date: datetime, end_date: datetime) -> pd.DataFrame:
        """Get team performance metrics."""
        return self.db.execute_procedure(
            'sp_GetTeamPerformance',
            [start_date.date(), end_date.date()]
        )
    
    def get_roi_by_channel(self, start_date: datetime, end_date: datetime) -> pd.DataFrame:
        """Get ROI by marketing channel."""
        return self.db.execute_procedure(
            'sp_GetROIByChannel',
            [start_date.date(), end_date.date()]
        )
    
    def get_all_campaigns(self) -> pd.DataFrame:
        """Get all campaigns with details."""
        query = """
        SELECT * FROM dbo.Campaigns
        ORDER BY StartDate DESC
        """
        return self.db.execute_query(query)
    
    def get_leads_by_status(self, status: str = None) -> pd.DataFrame:
        """Get leads filtered by status."""
        if status:
            query = f"""
            SELECT * FROM dbo.Leads
            WHERE Status = '{status}'
            ORDER BY CreatedDate DESC
            """
        else:
            query = "SELECT * FROM dbo.Leads ORDER BY CreatedDate DESC"
        
        return self.db.execute_query(query)


class KPIDataTransformer:
    """Transforms and aggregates KPI data."""
    
    @staticmethod
    def calculate_engagement_metrics(campaign_df: pd.DataFrame) -> pd.DataFrame:
        """Calculate engagement metrics from campaign data."""
        if campaign_df.empty:
            return campaign_df
        
        campaign_df['CPL'] = campaign_df['TotalSpend'] / campaign_df['LeadsGenerated']
        campaign_df['CPA'] = campaign_df['TotalSpend'] / campaign_df['LeadsConverted']
        campaign_df['LTV_Ratio'] = campaign_df['TotalRevenue'] / campaign_df['LeadsConverted']
        
        return campaign_df
    
    @staticmethod
    def aggregate_by_period(daily_df: pd.DataFrame, period: str = 'W') -> pd.DataFrame:
        """
        Aggregate daily metrics by period (W=weekly, M=monthly).
        
        Args:
            daily_df: DataFrame with daily metrics
            period: Aggregation period ('W' for weekly, 'M' for monthly)
            
        Returns:
            Aggregated DataFrame
        """
        if 'ReportDate' not in daily_df.columns or daily_df.empty:
            return daily_df
        
        daily_df['ReportDate'] = pd.to_datetime(daily_df['ReportDate'])
        
        numeric_cols = daily_df.select_dtypes(include=['number']).columns
        agg_dict = {col: 'sum' for col in numeric_cols}
        
        return daily_df.groupby(pd.Grouper(key='ReportDate', freq=period)).agg(agg_dict).reset_index()
    
    @staticmethod
    def identify_top_performers(team_df: pd.DataFrame, metric: str = 'TotalRevenue', top_n: int = 5) -> pd.DataFrame:
        """Identify top performing team members."""
        if team_df.empty or metric not in team_df.columns:
            return team_df
        
        return team_df.nlargest(top_n, metric)
    
    @staticmethod
    def calculate_growth_rates(df: pd.DataFrame, date_col: str, metric_col: str) -> pd.DataFrame:
        """Calculate growth rates over time."""
        if df.empty or date_col not in df.columns or metric_col not in df.columns:
            return df
        
        df = df.sort_values(by=date_col)
        df['Growth_Rate'] = df[metric_col].pct_change() * 100
        
        return df
