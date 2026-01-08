"""
Executive Marketing KPI Dashboard - Main ETL Script

This script orchestrates the extraction, transformation, and loading of marketing KPI data
from SQL Server to Power BI and other visualization tools.
"""

import sys
import argparse
from datetime import datetime, timedelta
import logging
import pandas as pd

from data_pipeline import DatabaseConnector, KPIDataExtractor, KPIDataTransformer
from config_manager import ConfigManager, ReportGenerator, MetricsCalculator

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('kpi_dashboard.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class MarketingKPIDashboard:
    """Main orchestrator for KPI dashboard operations."""
    
    def __init__(self):
        """Initialize dashboard with configuration."""
        self.config = ConfigManager()
        self.db_config = self.config.get_db_config()
        self.db = DatabaseConnector(
            server=self.db_config['server'],
            database=self.db_config['database'],
            username=self.db_config['username'],
            password=self.db_config['password']
        )
        self.extractor = KPIDataExtractor(self.db)
    
    def extract_data(self, start_date: datetime = None, end_date: datetime = None) -> dict:
        """
        Extract KPI data from database.
        
        Args:
            start_date: Start date for analysis period
            end_date: End date for analysis period
            
        Returns:
            Dictionary of extracted DataFrames
        """
        if not self.db.connect():
            logger.error("Failed to connect to database")
            return {}
        
        if start_date is None:
            start_date = datetime.now() - timedelta(days=90)
        if end_date is None:
            end_date = datetime.now()
        
        logger.info(f"Extracting data for period: {start_date.date()} to {end_date.date()}")
        
        try:
            data = {
                'campaigns': self.extractor.get_campaign_performance(start_date, end_date),
                'leads_funnel': self.extractor.get_lead_conversion_funnel(start_date, end_date),
                'team_performance': self.extractor.get_team_performance(start_date, end_date),
                'roi_by_channel': self.extractor.get_roi_by_channel(start_date, end_date),
                'all_campaigns': self.extractor.get_all_campaigns(),
                'leads': self.extractor.get_leads_by_status()
            }
            
            logger.info("Data extraction completed successfully")
            return data
        except Exception as e:
            logger.error(f"Data extraction failed: {str(e)}")
            return {}
        finally:
            self.db.disconnect()
    
    def transform_data(self, raw_data: dict) -> dict:
        """
        Transform and enrich extracted data.
        
        Args:
            raw_data: Dictionary of raw DataFrames
            
        Returns:
            Dictionary of transformed DataFrames
        """
        logger.info("Starting data transformation")
        
        try:
            transformer = KPIDataTransformer()
            
            # Transform campaign data
            if 'campaigns' in raw_data and not raw_data['campaigns'].empty:
                raw_data['campaigns'] = transformer.calculate_engagement_metrics(raw_data['campaigns'])
                raw_data['campaigns_weekly'] = transformer.aggregate_by_period(raw_data['campaigns'], 'W')
                raw_data['campaigns_monthly'] = transformer.aggregate_by_period(raw_data['campaigns'], 'M')
            
            # Identify top performers
            if 'team_performance' in raw_data and not raw_data['team_performance'].empty:
                raw_data['top_performers'] = transformer.identify_top_performers(
                    raw_data['team_performance'], 
                    'TotalRevenue', 
                    5
                )
            
            logger.info("Data transformation completed successfully")
            return raw_data
        except Exception as e:
            logger.error(f"Data transformation failed: {str(e)}")
            return raw_data
    
    def load_data(self, data: dict) -> bool:
        """
        Load transformed data to output formats.
        
        Args:
            data: Dictionary of DataFrames to export
            
        Returns:
            Success status
        """
        logger.info("Starting data load process")
        
        try:
            output_config = self.config.get_output_config()
            output_path = output_config['output_path']
            export_format = output_config['export_format']
            
            # Create output directory
            import os
            os.makedirs(output_path, exist_ok=True)
            
            # Export each dataset
            for name, df in data.items():
                if isinstance(df, pd.DataFrame) and not df.empty:
                    filename = f"{name}.{export_format}"
                    filepath = os.path.join(output_path, filename)
                    
                    if export_format == 'csv':
                        ReportGenerator.export_to_csv(df, filepath)
                    elif export_format == 'json':
                        ReportGenerator.export_to_json(df, filepath)
                    elif export_format == 'excel':
                        ReportGenerator.export_to_excel(df, filepath)
            
            logger.info("Data load completed successfully")
            return True
        except Exception as e:
            logger.error(f"Data load failed: {str(e)}")
            return False
    
    def run_full_pipeline(self, start_date: datetime = None, end_date: datetime = None) -> bool:
        """
        Run complete ETL pipeline.
        
        Args:
            start_date: Start date for analysis
            end_date: End date for analysis
            
        Returns:
            Success status
        """
        logger.info("=" * 60)
        logger.info("Starting Marketing KPI Dashboard ETL Pipeline")
        logger.info("=" * 60)
        
        # Extract
        raw_data = self.extract_data(start_date, end_date)
        if not raw_data:
            logger.error("Pipeline failed at extraction stage")
            return False
        
        # Transform
        transformed_data = self.transform_data(raw_data)
        
        # Load
        success = self.load_data(transformed_data)
        
        if success:
            logger.info("=" * 60)
            logger.info("ETL Pipeline completed successfully!")
            logger.info("=" * 60)
        else:
            logger.error("ETL Pipeline failed!")
        
        return success


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description='Executive Marketing KPI Dashboard ETL Pipeline'
    )
    parser.add_argument(
        '--start-date',
        type=str,
        help='Start date (YYYY-MM-DD)',
        default=None
    )
    parser.add_argument(
        '--end-date',
        type=str,
        help='End date (YYYY-MM-DD)',
        default=None
    )
    parser.add_argument(
        '--output-format',
        type=str,
        choices=['csv', 'json', 'excel'],
        default='csv',
        help='Output format'
    )
    
    args = parser.parse_args()
    
    # Parse dates
    start_date = None
    end_date = None
    
    if args.start_date:
        start_date = datetime.strptime(args.start_date, '%Y-%m-%d')
    if args.end_date:
        end_date = datetime.strptime(args.end_date, '%Y-%m-%d')
    
    # Run pipeline
    dashboard = MarketingKPIDashboard()
    success = dashboard.run_full_pipeline(start_date, end_date)
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
