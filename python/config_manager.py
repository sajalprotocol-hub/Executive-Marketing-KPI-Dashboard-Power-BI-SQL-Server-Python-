import os
import json
from pathlib import Path
from typing import Dict, Any
import logging
import pandas as pd

logger = logging.getLogger(__name__)


class ConfigManager:
    """Manages application configuration."""
    
    def __init__(self, env_file: str = '.env'):
        """Initialize configuration manager."""
        self.env_file = env_file
        self.config = self._load_config()
    
    def _load_config(self) -> Dict[str, Any]:
        """Load configuration from environment file."""
        config = {}
        
        if os.path.exists(self.env_file):
            with open(self.env_file, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith('#'):
                        key, value = line.split('=', 1)
                        config[key.strip()] = value.strip().strip('"\'')
        
        # Load from environment variables as fallback
        for key in ['DB_SERVER', 'DB_NAME', 'DB_USER', 'DB_PASSWORD']:
            if key not in config:
                config[key] = os.getenv(key, '')
        
        return config
    
    def get(self, key: str, default: str = '') -> str:
        """Get configuration value."""
        return self.config.get(key, default)
    
    def get_db_config(self) -> Dict[str, str]:
        """Get database configuration."""
        return {
            'server': self.get('DB_SERVER'),
            'database': self.get('DB_NAME'),
            'username': self.get('DB_USER'),
            'password': self.get('DB_PASSWORD')
        }
    
    def get_output_config(self) -> Dict[str, str]:
        """Get output configuration."""
        return {
            'export_format': self.get('EXPORT_FORMAT', 'csv'),
            'output_path': self.get('OUTPUT_PATH', './output'),
            'archive_path': self.get('ARCHIVE_PATH', './archive')
        }


class ReportGenerator:
    """Generates KPI reports in various formats."""
    
    @staticmethod
    def export_to_csv(df, filepath: str) -> bool:
        """Export DataFrame to CSV."""
        try:
            df.to_csv(filepath, index=False, encoding='utf-8')
            logger.info(f"Exported to {filepath}")
            return True
        except Exception as e:
            logger.error(f"CSV export failed: {str(e)}")
            return False
    
    @staticmethod
    def export_to_json(df, filepath: str) -> bool:
        """Export DataFrame to JSON."""
        try:
            df.to_json(filepath, orient='records', indent=2, date_format='iso')
            logger.info(f"Exported to {filepath}")
            return True
        except Exception as e:
            logger.error(f"JSON export failed: {str(e)}")
            return False
    
    @staticmethod
    def export_to_excel(df, filepath: str, sheet_name: str = 'Data') -> bool:
        """Export DataFrame to Excel."""
        try:
            df.to_excel(filepath, sheet_name=sheet_name, index=False)
            logger.info(f"Exported to {filepath}")
            return True
        except Exception as e:
            logger.error(f"Excel export failed: {str(e)}")
            return False
    
    @staticmethod
    def create_report_bundle(data_dict: Dict[str, Any], output_dir: str, format: str = 'csv') -> bool:
        """
        Create a report bundle with multiple datasets.
        
        Args:
            data_dict: Dictionary of {report_name: DataFrame}
            output_dir: Output directory
            format: Export format (csv, json, excel)
            
        Returns:
            Success status
        """
        try:
            Path(output_dir).mkdir(parents=True, exist_ok=True)
            timestamp = pd.Timestamp.now().strftime('%Y%m%d_%H%M%S')
            
            for report_name, df in data_dict.items():
                filename = f"{report_name}_{timestamp}.{format}"
                filepath = os.path.join(output_dir, filename)
                
                if format == 'csv':
                    ReportGenerator.export_to_csv(df, filepath)
                elif format == 'json':
                    ReportGenerator.export_to_json(df, filepath)
                elif format == 'excel':
                    ReportGenerator.export_to_excel(df, filepath)
            
            return True
        except Exception as e:
            logger.error(f"Report bundle creation failed: {str(e)}")
            return False


class MetricsCalculator:
    """Calculates advanced marketing metrics."""
    
    @staticmethod
    def calculate_customer_lifetime_value(revenue_df, lead_count: int) -> float:
        """Calculate average customer lifetime value."""
        if lead_count == 0:
            return 0
        return revenue_df['Amount'].sum() / lead_count
    
    @staticmethod
    def calculate_payback_period(spend: float, monthly_revenue: float) -> float:
        """Calculate marketing payback period in months."""
        if monthly_revenue == 0:
            return float('inf')
        return spend / monthly_revenue
    
    @staticmethod
    def calculate_attribution_score(df, weight_dict: Dict[str, float] = None) -> float:
        """
        Calculate attribution score based on multiple factors.
        
        Args:
            df: DataFrame with metrics
            weight_dict: Dictionary of weights for each metric
            
        Returns:
            Attribution score
        """
        if df.empty:
            return 0
        
        if weight_dict is None:
            weight_dict = {
                'CTR': 0.2,
                'ConversionRate': 0.3,
                'ROI': 0.3,
                'MarketingEfficiency': 0.2
            }
        
        score = 0
        for metric, weight in weight_dict.items():
            if metric in df.columns:
                # Normalize and apply weight
                score += (df[metric].mean() / 100) * weight if metric != 'ROI' else (df[metric].mean()) * weight
        
        return score
