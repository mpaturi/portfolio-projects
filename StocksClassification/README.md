Project goal
Analyze 5 years of daily price and volume data for AAPL, AMZN, MSFT, VOO, and SPY to understand their behavior relative to the S&P 500 and build a simple classification model that predicts whether each ticker’s next‑day return will be positive (up) or non‑positive (down).
Why this matters for a data analyst role
This project demonstrates end‑to‑end analytical workflow on financial time‑series data: defining a business‑style question, sourcing and cleaning market data, engineering features, training and evaluating a classification model, and communicating results and limitations to non‑technical stakeholders.
Success criteria


Data: Successfully pull and store 5 full years of daily OHLCV data for AAPL, AMZN, MSFT, VOO, and SPY from Yahoo Finance (or equivalent) with a reproducible script.


Modeling: Train at least one baseline classifier (e.g., logistic regression) and one tree‑based model (e.g., random forest) to predict up_next_day (1 if next‑day return > 0, else 0) using only information available up to the prediction date.


Performance: Achieve out‑of‑sample performance that clearly exceeds a naive baseline such as always predicting “up” or random guessing, and document metrics like accuracy, precision/recall, and ROC‑AUC.


Communication: Produce a concise report (README + selected charts) explaining data, features, model performance, limitations, and how an analyst might use this in a monitoring or alerting context.