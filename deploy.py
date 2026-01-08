"""
Deployment and Initialization Script for Executive Marketing KPI Dashboard
This script sets up the entire environment and validates all components.
"""

import os
import sys
import subprocess
from pathlib import Path

# Fix encoding for Windows console
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def print_section(title):
    """Print section header."""
    print("\n" + "="*60)
    print(f"  {title}")
    print("="*60)

def check_file_exists(filepath, description):
    """Check if a file exists."""
    if os.path.exists(filepath):
        print(f"✅ {description}: {filepath}")
        return True
    else:
        print(f"❌ {description}: NOT FOUND - {filepath}")
        return False

def check_python_modules():
    """Check if all required Python modules are installed."""
    print_section("Checking Python Modules")
    
    modules = ['pyodbc', 'pandas', 'openpyxl', 'python-dotenv', 'requests', 'numpy', 'scipy', 'sqlalchemy']
    all_installed = True
    
    for module in modules:
        try:
            __import__(module)
            print(f"✅ {module} installed")
        except ImportError:
            print(f"❌ {module} NOT installed")
            all_installed = False
    
    return all_installed

def check_project_structure():
    """Check project directory structure."""
    print_section("Checking Project Structure")
    
    required_dirs = [
        ('database', 'Database scripts directory'),
        ('python', 'Python scripts directory'),
        ('powerbi', 'Power BI configuration directory'),
        ('docs', 'Documentation directory'),
        ('.vscode', 'VS Code configuration directory'),
    ]
    
    all_exist = True
    for dirname, description in required_dirs:
        if os.path.isdir(dirname):
            print(f"✅ {description}: {dirname}/")
        else:
            print(f"❌ {description} NOT found: {dirname}/")
            all_exist = False
    
    return all_exist

def check_files():
    """Check for required files."""
    print_section("Checking Required Files")
    
    required_files = [
        ('database/01_schema.sql', 'Database schema'),
        ('database/02_sample_data.sql', 'Sample data'),
        ('database/03_stored_procedures.sql', 'Stored procedures'),
        ('python/main.py', 'Main ETL script'),
        ('python/data_pipeline.py', 'Data pipeline module'),
        ('python/config_manager.py', 'Configuration manager'),
        ('python/requirements.txt', 'Python dependencies'),
        ('powerbi/config.json', 'Power BI configuration'),
        ('powerbi/dax_measures.dax', 'DAX measures'),
        ('powerbi/data_model.md', 'Data model documentation'),
        ('README.md', 'Project README'),
        ('QUICKSTART.md', 'Quick start guide'),
        ('.env', 'Environment configuration'),
        ('.vscode/launch.json', 'VS Code launch config'),
        ('.vscode/tasks.json', 'VS Code tasks'),
    ]
    
    all_exist = True
    for filepath, description in required_files:
        if check_file_exists(filepath, description):
            continue
        all_exist = False
    
    return all_exist

def verify_environment():
    """Verify .env file has proper configuration."""
    print_section("Verifying Environment Configuration")
    
    if not os.path.exists('.env'):
        print("❌ .env file not found")
        return False
    
    with open('.env', 'r') as f:
        content = f.read()
    
    required_vars = ['DB_SERVER', 'DB_NAME', 'DB_USER', 'DB_PASSWORD']
    all_found = True
    
    for var in required_vars:
        if var in content and not content.split(f'{var}=')[1].split('\n')[0].startswith('your_'):
            print(f"✅ {var} configured")
        else:
            print(f"⚠️  {var} needs configuration")
            all_found = False
    
    return all_found

def print_deployment_summary(results):
    """Print deployment summary."""
    print_section("Deployment Summary")
    
    total = len(results)
    passed = sum(1 for r in results.values() if r)
    
    print(f"Checks Passed: {passed}/{total}")
    print("\nStatus:")
    for check, result in results.items():
        status = "✅" if result else "⚠️"
        print(f"{status} {check}")
    
    if passed == total:
        print("\n🎉 Project is ready for deployment!")
    else:
        print("\n⚠️  Some components need configuration before full deployment.")

def main():
    """Run all deployment checks."""
    print("\n" + "="*60)
    print("  Executive Marketing KPI Dashboard - Deployment Check")
    print("="*60)
    
    results = {
        'Project Structure': check_project_structure(),
        'Required Files': check_files(),
        'Python Modules': check_python_modules(),
        'Environment Configuration': verify_environment(),
    }
    
    print_deployment_summary(results)
    
    print_section("Next Steps")
    print("""
1. Update .env file with your SQL Server credentials:
   - DB_SERVER: Your SQL Server instance name
   - DB_NAME: MarketingKPIDB (or custom name)
   - DB_USER: SQL Server username
   - DB_PASSWORD: SQL Server password

2. Create the database by running:
   sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -i database/01_schema.sql
   sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -i database/02_sample_data.sql
   sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -i database/03_stored_procedures.sql

3. Run the ETL pipeline:
   python python/main.py

4. Connect Power BI:
   - Open Power BI Desktop
   - Get Data → SQL Server
   - Enter your SQL Server credentials
   - Select the required tables

5. Import DAX measures and create reports
    """)

if __name__ == '__main__':
    main()
