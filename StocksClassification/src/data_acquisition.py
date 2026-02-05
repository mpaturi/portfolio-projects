"""
Data acquisition helpers.

This module will hold functions to download 5-year daily OHLCV data
for the configured tickers and save them into data/raw/.
"""

from pathlib import Path
from typing import List

import pandas as pd
import yfinance as yf  # used later

from .config import TICKERS, START_DATE, END_DATE, RAW_DATA_DIR, FREQUENCY


def download_ticker_history(
    ticker: str,
    start_date=START_DATE,
    end_date=END_DATE,
    interval: str = FREQUENCY,
) -> pd.DataFrame:
    """
    Download historical price data for a single ticker from Yahoo Finance.

    Parameters
    ----------
    ticker : str
        Ticker symbol, e.g. "AAPL".
    start_date : date
        Start of the historical window.
    end_date : date
        End of the historical window.
    interval : str
        Data frequency (e.g. "1d" for daily).

    Returns
    -------
    pd.DataFrame
        DataFrame indexed by date with OHLCV columns.
    """
    df = yf.download(
        ticker,
        start=start_date,
        end=end_date,
        interval=interval,
        auto_adjust=False,
        progress=False,
    )

    # Ensure a clean, predictable index and column set
    df = df.reset_index().rename(columns=str.strip)
    df = df.rename(
        columns={
            "Date": "date",
            "Open": "open",
            "High": "high",
            "Low": "low",
            "Close": "close",
            "Adj Close": "adj_close",
            "Volume": "volume",
        }
    )

    # Sort just in case and enforce dtypes
    df = df.sort_values("date").reset_index(drop=True)

    return df



def ensure_raw_data_dir(path: Path = RAW_DATA_DIR) -> None:
    """
    Ensure the raw data directory exists.
    """
    path.mkdir(parents=True, exist_ok=True)


def save_ticker_to_csv(ticker: str, directory: Path = RAW_DATA_DIR) -> Path:
    """
    Download 5-year daily data for a single ticker and save to CSV
    in the raw data directory.

    Returns
    -------
    Path
        Path to the saved CSV file.
    """
    ensure_raw_data_dir(directory)

    df = download_ticker_history(ticker)
    output_path = directory / f"{ticker.lower()}_prices_raw.csv"
    df.to_csv(output_path, index=False)

    return output_path


def download_and_save_all_tickers(tickers: List[str] = TICKERS) -> None:
    """
    Download and save raw CSV files for all configured tickers into data/raw/.
    """
    ensure_raw_data_dir()

    for t in tickers:
        path = save_ticker_to_csv(t)
        print(f"Saved {t} data to {path}")
