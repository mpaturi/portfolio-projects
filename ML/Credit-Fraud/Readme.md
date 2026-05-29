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
```
Credit-Fraud/
├── data/
│ └── (dataset excluded - download from Kaggle)
├── images/
│ └── (visualization outputs)
├── notebooks/
│ └── creditcardfraud.ipynb
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```


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

## Exploratory analysis

A small balanced subset (`df_small`) was created for visualization by taking all fraud rows and randomly sampling the same number of non-fraud rows. This subset was used only for exploratory data analysis so that fraud and non-fraud distributions could be compared clearly in histograms without the majority class visually dominating the plots.

Feature exploration showed that `Amount` had substantial overlap between fraud and non-fraud, making it a weak standalone discriminator, while features such as `V14` showed stronger separation and appeared much more informative for fraud detection. A Random Forest feature-importance check also highlighted variables such as `V14`, `V10`, and `V12` as stronger predictors than `Amount`.

## Baseline model

A baseline Logistic Regression model was trained on the original imbalanced training data and evaluated on the original test set. This baseline produced strong fraud precision of about 0.859 and fraud recall of about 0.684, meaning that when the model flagged fraud it was usually correct, but it still missed a noticeable share of true fraud cases.

This baseline established an important trade-off: the model was conservative about predicting fraud, which helped keep false positives low, but that same conservatism caused more false negatives than a fraud team might want in practice.
## Imbalance-handling strategies

Three different approaches were tested to handle imbalance in the training data: random undersampling, `class_weight='balanced'`, and SMOTE oversampling. In every case, only the training data was modified or reweighted; the test set remained unchanged to preserve honest evaluation.

### Random undersampling

Random undersampling created a balanced training set by keeping all fraud transactions in the training split and randomly dropping non-fraud rows until both classes had the same count. This sharply increased fraud recall to about 0.918, but fraud precision fell to about 0.037 because the model generated a very large number of false positives.
### Class-weighted Logistic Regression

Using `class_weight='balanced'` did not change the dataset itself; instead, it increased the training importance of minority-class errors by weighting fraud examples more heavily in the loss function.This approach achieved the same fraud recall as undersampling at about 0.918, while improving fraud precision to about 0.059 and reducing false positives relative to pure undersampling.

### SMOTE oversampling

SMOTE balanced the training set by generating synthetic minority-class samples between existing fraud neighbors in feature space rather than by duplicating rows. This approach achieved fraud recall of about 0.898 and fraud precision of about 0.129, producing the best precision-recall balance among the resampling-based methods tested in this project.

## Fraud-class comparison

The table below compares class 1 (fraud) performance across the four Logistic Regression setups tested in this project.

| Metric | Original | Undersampled | Class-weighted | SMOTE |
|---|---:|---:|---:|---:|
| Precision | 0.859 | 0.0366 | 0.0585 | 0.1287 |
| Recall | 0.6837 | 0.9184 | 0.9184 | 0.8980 |
| F1-score | 0.7614 | 0.0704 | 0.1100 | 0.2251 |

The original model had the highest fraud precision and the highest fraud F1-score among the tested Logistic Regression variants, but it also missed more fraud cases than the resampling-based approaches. Undersampling and class weighting pushed recall much higher, but they did so at the cost of large increases in false positives.

SMOTE offered the best compromise among the imbalance-handling methods tested here because it kept fraud recall high while materially improving fraud precision compared with undersampling and class weighting. For a fraud detection workflow where catching more fraud is important but alert volume still matters, SMOTE appeared to be the most balanced resampling strategy in this experiment.

## Key takeaways

- Accuracy is not a reliable primary metric for highly imbalanced fraud data because the majority class can dominate the score even when fraud detection is weak.
- Fraud recall is closely tied to false negatives: fewer missed frauds mean higher recall.
- Fraud precision is closely tied to false positives: more false alarms mean lower precision.
- Undersampling is simple and often improves recall, but it throws away many majority-class examples and can create excessive false positives.
- Class weighting is easy to apply and keeps all training data, but may still generate many false alerts.
- SMOTE can provide a stronger recall-precision trade-off by synthesizing minority samples instead of discarding majority examples.

## Conclusion

This project shows that handling imbalance changes model behavior more than raw accuracy suggests. The baseline model was precise but missed more fraud, while undersampling and class weighting increased fraud capture at the cost of noisy alerts. Among the imbalance-handling approaches tested, SMOTE delivered the strongest practical trade-off by preserving high fraud recall while reducing false positives compared with the other resampling-based methods.
