#!/bin/bash
# Executive Marketing KPI Dashboard - Startup Script
# This script starts the Streamlit web dashboard

echo ""
echo "========================================"
echo "  Marketing KPI Dashboard - Web Interface"
echo "========================================"
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install/update dependencies
echo "Installing dependencies..."
pip install -q -r python/requirements.txt

# Start dashboard
echo ""
echo "Starting dashboard on http://localhost:8501"
echo "Press Ctrl+C to stop"
echo ""

streamlit run dashboard.py --logger.level=info
