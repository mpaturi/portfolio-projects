from pathlib import Path
from datetime import date, timedelta

# Project paths (root is the StocksClassification folder)
PROJECT_ROOT = Path(__file__).resolve().parents[1]

DATA_DIR = PROJECT_ROOT / "data"
RAW_DATA_DIR = DATA_DIR / "raw"
PROCESSED_DATA_DIR = DATA_DIR / "processed"
MODELS_DIR = DATA_DIR / "models"

NOTEBOOKS_DIR = PROJECT_ROOT / "notebooks"

# Universe of tickers
TICKERS = ["AAPL", "AMZN", "MSFT", "VOO", "SPY"]

# Date window: last 5 years from today (can later be overridden)
END_DATE = date.today()
START_DATE = END_DATE - timedelta(days=5 * 365)

# Yahoo Finance options
PRICE_COLUMNS = ["Open", "High", "Low", "Close", "Adj Close", "Volume"]
FREQUENCY = "1d"  # daily
