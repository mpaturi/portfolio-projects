# Credit Card Fraud Detection

Exploratory data analysis and classification modeling on the highly imbalanced Credit Card Fraud Detection dataset from Kaggle, following a practical workflow for handling extreme class imbalance in fraud prediction.

## Tools & Libraries

- Python 3.x
- pandas, numpy
- matplotlib, seaborn
- scikit-learn
- imbalanced-learn
- xgboost

## Dataset

[Credit Card Fraud Detection Dataset](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud) from Kaggle (Machine Learning Group - ULB).

The dataset contains 284,807 transactions with 31 columns, and the target variable `Class` identifies fraud (`1`) vs non-fraud (`0`). Fraud cases make up only about 0.17% of the data, which makes this a severely imbalanced classification problem.

**Note:** The dataset file (`creditcard.csv`, ~143 MB) is not included in this repository due to GitHub file size limits. Download it from the Kaggle link above.

## Project Structure

```text
Credit-Fraud/
├── data/
│   └── (dataset excluded - download from Kaggle)
├── images/
│   └── (visualization outputs)
├── models/
│   ├── rf_importance.pkl
│   ├── log_reg_orig.pkl
│   ├── log_reg_smote.pkl
│   ├── smote_data.pkl
│   ├── rf_smote.pkl
│   ├── xgb_smote.pkl
│   └── rf_grid_search.pkl
├── notebooks/
│   └── creditcardfraud.ipynb
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```

**Note:** Trained model files (`models/*.pkl`) are not included in this repository due to file size. Run the notebook to generate them — each model uses joblib caching so it only trains once and loads from disk on subsequent runs.

## How to Run

1. Clone this repository.
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Download `creditcard.csv` from Kaggle and place it in the `data/` folder.
4. Open the notebook:
   ```bash
   jupyter notebook notebooks/creditcardfraud.ipynb
   ```

## Exploratory Analysis

Initial exploration confirmed that the dataset is extremely imbalanced, with about 99.83% non-fraud transactions and only about 0.17% fraud transactions. Because of this, accuracy alone is not a reliable metric, so the project focuses on fraud-class precision, recall, and F1-score instead.

## Train-Test Setup

The train-test split was performed before any feature analysis or modeling, using stratification so both sets preserved the original class distribution. The test set was intentionally left imbalanced to reflect real-world fraud detection conditions and to ensure honest evaluation.

## Feature Importance

A Random Forest was trained on the training set only to identify which features carry the strongest fraud signal. The top features by importance score were **V17 (0.172)**, V12 (0.137), and V14 (0.126). Distribution plots of V17 confirmed clear separation between fraud and non-fraud transactions, validating it as a genuinely discriminative feature.

## Baseline Model

A baseline Logistic Regression model was trained on the original imbalanced training data and evaluated on the original test set. This baseline achieved fraud precision of **0.8289**, fraud recall of **0.6429**, and fraud F1-score of **0.7241**, showing that it was conservative and precise but still missed a meaningful share of fraud cases.

This baseline established the main trade-off in the project: high precision helps reduce false positives, but lower recall means more missed fraud.

## Imbalance-Handling Strategies

Three imbalance-handling strategies were tested during training: random undersampling, `class_weight='balanced'`, and SMOTE oversampling. In each case, only the training data was adjusted or reweighted, while the test set remained unchanged.

### Random Undersampling

Random undersampling balanced the training set by keeping all fraud rows and randomly reducing the non-fraud class to the same size. This increased fraud recall to **0.9184**, but fraud precision dropped to **0.0366**, making the model impractical because it generated too many false positives.

### Class-Weighted Logistic Regression

Using `class_weight='balanced'` increased the penalty for fraud misclassification without altering the dataset itself. This produced fraud recall of **0.9184** and fraud precision of **0.0585**, which was slightly better than undersampling but still far too noisy for real use.

### SMOTE + Logistic Regression

SMOTE balanced the training data by generating synthetic fraud examples based on nearby minority-class observations. With Logistic Regression, this improved the precision-recall trade-off compared with undersampling and class weighting, producing fraud precision of **0.1287**, recall of **0.8980**, and F1-score of **0.2251**.

## Tree-Based Models

### Random Forest + SMOTE

Random Forest was trained on the SMOTE-balanced training data and evaluated on the original test set. This model achieved fraud precision of **0.8265**, fraud recall of **0.8265**, and fraud F1-score of **0.8265** — the best overall balance among all models tested.

Random Forest outperformed Logistic Regression because it can capture non-linear relationships and feature interactions more effectively, which is valuable in fraud detection where suspicious patterns are often complex.

### XGBoost + SMOTE

XGBoost was also trained on the SMOTE-balanced training data. It achieved higher recall (**0.88**) than Random Forest but at the cost of much lower precision (**0.42**), resulting in a significantly higher false positive rate. Random Forest remained the stronger overall choice.

## Fraud-Class Results

| Model | Precision | Recall | F1-score |
|---|---:|---:|---:|
| Logistic Regression (imbalanced) | 0.8289 | 0.6429 | 0.7241 |
| Logistic Regression + Undersampling | 0.0366 | 0.9184 | 0.0704 |
| Logistic Regression + `class_weight='balanced'` | 0.0585 | 0.9184 | 0.1100 |
| Logistic Regression + SMOTE | 0.1287 | 0.8980 | 0.2251 |
| **Random Forest + SMOTE** | **0.8265** | **0.8265** | **0.8265** |
| XGBoost + SMOTE | 0.42 | 0.88 | 0.57 |

## Hyperparameter Tuning

GridSearchCV with StratifiedKFold cross-validation was used to tune the Random Forest + SMOTE pipeline. The search optimised for fraud-class F1-score to ensure tuning stayed focused on the minority class. Tuning confirmed that the default configuration was already near-optimal — the tuned model scored **0.8163** F1 on the test set, confirming that the SMOTE + Random Forest strategy itself drives performance more than specific parameter values.

## Threshold Tuning

The tuned Random Forest assigns each transaction a fraud probability between 0 and 1. Lowering the default threshold of 0.5 allows the model to flag more fraud at the cost of more false alarms.

At threshold **0.3**:
- **Recall: 87.8%** — catches 86 out of 98 fraud cases
- **Precision: 68.8%** — 39 legitimate transactions wrongly flagged
- **F1-score: 0.7713**

This gives practitioners a lever to tune the precision-recall trade-off based on business priorities without retraining the model.

## PR Curve and ROC Curve

- **AUC-PR: 0.8704** — the model maintains near-perfect precision up to ~55% recall before dropping, indicating high confidence in its earliest fraud predictions
- **AUC-ROC: 0.9739** — confirms strong separation between fraud and legitimate transactions across all thresholds

For an imbalanced dataset, AUC-PR is the more informative metric. Both scores being strong provides high confidence that RF + SMOTE is a genuinely effective model.

## Key Takeaways

- Accuracy is not a reliable primary metric for extremely imbalanced fraud data.
- Fraud recall reflects how many actual fraud cases are caught; fraud precision reflects how many flagged cases are truly fraud.
- Random undersampling can improve recall but creates excessive false positives by discarding most majority-class data.
- Class weighting is simple and preserves all training data but may still produce many false alerts.
- SMOTE provides a better training signal than undersampling by synthesising minority examples instead of discarding majority data.
- Tree-based models such as Random Forest outperform linear models when fraud patterns depend on non-linear feature interactions.
- Threshold tuning is a practical post-training tool that lets the business control the precision-recall trade-off without retraining.

## Conclusion

This project shows that class-imbalance handling changes fraud-model behaviour much more meaningfully than raw accuracy suggests. The baseline Logistic Regression model was precise but missed more fraud, while undersampling and class weighting increased fraud capture at the cost of many false alarms.

Among all tested approaches, **Random Forest + SMOTE** delivered the best overall fraud-detection trade-off on the original imbalanced test set — strong precision, strong recall, and the highest fraud F1-score. Hyperparameter tuning confirmed this configuration was already near-optimal. Threshold tuning and AUC-PR/ROC curves provide additional tools for deploying and monitoring the model in a real-world setting.
