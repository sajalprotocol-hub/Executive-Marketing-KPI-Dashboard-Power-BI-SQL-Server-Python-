@echo off
REM Executive Marketing KPI Dashboard - Startup Script
REM This script starts the Streamlit web dashboard

echo.
echo ========================================
echo  Marketing KPI Dashboard - Web Interface
echo ========================================
echo.

REM Check if virtual environment exists
if not exist "venv\Scripts\activate.bat" (
    echo Creating virtual environment...
    python -m venv venv
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Install/update dependencies
echo Installing dependencies...
pip install -q -r python/requirements.txt

REM Start dashboard
echo.
echo Starting dashboard on http://localhost:8501
echo Press Ctrl+C to stop
echo.

streamlit run dashboard.py --logger.level=info

pause
