# Credit Card Fraud Detection

A machine learning project that explores fraud detection on a highly imbalanced credit card transaction dataset. The project focuses on handling extreme class imbalance, comparing multiple modeling strategies, and evaluating business trade-offs between catching fraud and minimizing false alarms.

---

## Project Goal

Credit card fraud detection is a classic imbalanced classification problem:

* Fraud transactions: ~0.17%
* Legitimate transactions: ~99.83%

Because fraud is extremely rare, accuracy is not a useful metric. Instead, the project focuses on:

* Precision
* Recall
* F1-score
* Precision-Recall (PR) Curve
* ROC Curve

The objective is to maximize fraud detection while keeping false-positive investigations manageable.

---

## Tools & Libraries

* Python
* Pandas
* NumPy
* Matplotlib
* Seaborn
* Scikit-Learn
* Imbalanced-Learn (SMOTE)
* XGBoost

---

## Dataset

Kaggle Credit Card Fraud Detection Dataset:

https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud

Dataset characteristics:

* 284,807 transactions
* 492 fraud transactions
* 30 anonymized PCA-transformed features (V1–V28)
* Amount
* Class (Target)

Fraud prevalence:

0.172%

---

## Project Workflow

### 1. Exploratory Data Analysis

* Class distribution analysis
* Fraud vs non-fraud comparison
* Feature distribution visualization
* Correlation analysis

### 2. Train-Test Split

A stratified train-test split was used to preserve the original fraud ratio in both datasets.

The test set remained completely untouched throughout training and tuning to prevent data leakage.

### 3. Feature Selection

Random Forest feature importance was used to identify the most predictive fraud indicators.

Top features included:

* V17
* V12
* V14
* V10
* V16

The top 10 features were selected for modeling.

### 4. Imbalance Handling Techniques

The following approaches were compared:

1. Baseline Logistic Regression
2. Random Undersampling
3. Class-Weighted Logistic Regression
4. SMOTE + Logistic Regression
5. SMOTE + Random Forest
6. SMOTE + XGBoost

### 5. Hyperparameter Tuning

Random Forest + SMOTE was tuned using:

* GridSearchCV
* Stratified K-Fold Cross Validation
* Fraud-class F1-score as the optimization metric

Results showed that the default Random Forest configuration was already near-optimal.

### 6. Threshold Tuning

The fraud probability threshold was adjusted to study the Precision-Recall trade-off.

This demonstrates how businesses can choose between:

* Higher fraud detection (higher recall)
* Lower investigation workload (higher precision)

without retraining the model.

---

## Model Comparison

| Model                               | Precision |   Recall | F1 Score |
| ----------------------------------- | --------: | -------: | -------: |
| Baseline Logistic Regression        |      0.80 |     0.60 |     0.69 |
| Logistic Regression + Undersampling |      0.04 |     0.93 |     0.08 |
| Logistic Regression + Class Weights |      0.06 |     0.92 |     0.11 |
| Logistic Regression + SMOTE         |      0.05 |     0.92 |     0.10 |
| Random Forest + SMOTE               |  **0.71** | **0.83** | **0.76** |
| XGBoost + SMOTE                     |      0.12 |     0.90 |     0.21 |

---

## Best Model: Random Forest + SMOTE

Fraud-class metrics:

* Precision: 71.1%
* Recall: 82.7%
* F1-score: 76.4%

Confusion Matrix:

|              | Predicted Legit | Predicted Fraud |
| ------------ | --------------: | --------------: |
| Actual Legit |          56,831 |              33 |
| Actual Fraud |              17 |              81 |

Interpretation:

* Catches approximately 83% of fraud transactions
* Maintains a relatively low false-positive count
* Provides the best balance between fraud detection and investigator workload

---

## Threshold Tuning Example

Using a lower threshold (0.3):

| Metric    | Value |
| --------- | ----: |
| Precision | 53.2% |
| Recall    | 85.7% |
| F1-score  | 65.6% |

Confusion Matrix:

|              | Predicted Legit | Predicted Fraud |
| ------------ | --------------: | --------------: |
| Actual Legit |          56,790 |              74 |
| Actual Fraud |              14 |              84 |

Business implication:

* More fraud is detected
* More legitimate transactions are flagged
* Useful when the cost of missed fraud exceeds the cost of investigations

---

## Precision-Recall and ROC Analysis

### Precision-Recall Curve

AUC-PR:

0.8124

The PR curve is especially important for fraud detection because it directly reflects the trade-off between fraud detection and false alarms.

### ROC Curve

AUC-ROC:

0.9643

The ROC curve shows that the model separates fraud and legitimate transactions extremely well across many thresholds.

For highly imbalanced datasets, AUC-PR is generally the more informative metric.

---

## Key Findings

* Accuracy is misleading for highly imbalanced datasets.
* Recall and Precision are more meaningful fraud-detection metrics.
* Random undersampling improves recall but creates excessive false positives.
* Class weighting preserves data but still produces many false alarms.
* SMOTE is generally more effective than undersampling because it generates synthetic minority examples instead of discarding majority-class data.
* Random Forest outperformed Logistic Regression and XGBoost by achieving the strongest Precision-Recall balance.
* Hyperparameter tuning produced only marginal improvements, indicating that the overall modeling strategy mattered more than specific parameter choices.
* Threshold tuning provides a practical business lever for controlling fraud detection sensitivity.

---

## Business Takeaway

In fraud detection, the cost of missing a fraudulent transaction is often significantly higher than the cost of investigating a false alarm.

The Random Forest + SMOTE model achieved the strongest overall balance between fraud detection and operational efficiency. Additionally, threshold tuning demonstrated that the business can adjust fraud sensitivity without retraining the model, allowing investigation workload and fraud losses to be balanced according to business priorities.

---

## Future Improvements

* Cost-sensitive learning
* Advanced anomaly detection methods
* Real-time fraud scoring pipeline
* Ensemble model stacking
* Model monitoring and drift detection

---

## License

This project is released under the MIT License.
