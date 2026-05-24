# Credit Card Defaulters Analysis

Exploratory data analysis and classification modeling on the imbalanced Credit Card Default dataset from Kaggle, following Joni Hoppen's approach to handling class imbalance.

## Tools & Libraries

- Python 3.x
- pandas, numpy
- matplotlib, seaborn
- scikit-learn

## Dataset

[Credit Card Fraud Detection Dataset](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud) from Kaggle (Machine Learning Group - ULB).

The dataset contains transactions made by credit cards in September 2013 by European cardholders. It is highly imbalanced, with fraudulent transactions accounting for only 0.172% of all transactions.

**Note:** The dataset file (`creditcard.csv`, 143 MB) is not included in this repository due to GitHub's file size limits. Download it from the Kaggle link above.

## Project Structure
CREDITCARD/
├── data/
│ └── creditcard.csv
├── images/
├── notebooks/
│ └── CreditCardDefaulters.ipynb
├── README.md
├── .gitignore
└── requirements.txt


## How to Run

1. Clone this repository
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Open the notebook:
   ```bash
   jupyter notebook notebooks/CreditCardDefaulters.ipynb
   ```

