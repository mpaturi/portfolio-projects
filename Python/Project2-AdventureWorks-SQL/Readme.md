# AdventureWorks Sales Analysis

## Project Overview

This project performs comprehensive SQL-based data extraction and exploratory data analysis (EDA) on the AdventureWorks sample database. The analysis focuses on identifying sales patterns, top-performing products, geographic performance differences, and seasonal trends to provide actionable business insights.

**Key Business Questions:**
- Which months and products drive the highest revenue?
- How do territories differ in sales volume vs. average order value?
- What seasonal patterns exist in product category sales?
- What product tiers contribute most to overall revenue?

---

## Project Structure
Project2-AdventureWorks-SQL/
├── notebooks/
│ ├── 01_adw_sales_queries.ipynb # SQL queries and data extraction
│ ├── 02_adw_sales_eda.ipynb # Exploratory data analysis & visualizations
│ ├── 03_adw_cleaning_pipeline.ipynb # Reusable data cleaning function
│ └── proj2_task1_1_python_sql_connection.ipynb # Initial connection setup
├── data/
│ └── clean/
│ └── clean_sales_lines.parquet # Cleaned transaction-level data
├── requirements.txt # Python dependencies
└── README.md # This file


---

## Key Findings

### 1. Revenue Concentration
- **Peak Month**: March 2014 generated $7.2M in sales
- **Top 3 Months**: Account for ~37% of revenue among top 10 performing months
- **Trend**: Upward trajectory from 2011-2014 with notable volatility

### 2. Product Performance
- **Top Product**: Mountain-200 Black, 38 ($4.4M in sales)
- **High Sales Tier**: Top 3 products contribute 39% of top-10 revenue
- **Volume vs. Price**: Revenue strongly correlated with quantity sold (r=0.98)
- **Product Mix**: Bikes dominate at 86.2% of revenue, followed by Components (10.7%)

### 3. Geographic Patterns
**Two Territory Archetypes Identified:**
- **High-Volume Territories** (Southwest, Canada, Northwest, Australia)
  - Moderate average order values ($1,500-$4,000)
  - High revenue through order volume
  - Strategy: Market penetration and accessibility

- **Premium Territories** (Central, Northeast, Southeast)
  - Very high average order values ($16,000-$20,500)
  - Lower total sales but higher-value deals
  - Strategy: Focus on B2B and enterprise accounts

### 4. Seasonal Trends
- **Spring**: Highest revenue (29% of annual sales)
- **Summer-Fall**: Gradual decline through cycling season
- **Winter**: Lowest performance (22% of annual sales)
- **Insight**: Clear seasonality suggests inventory and marketing timing opportunities

---

## Notebooks Description

### 01 - SQL Queries (`01_adw_sales_queries.ipynb`)
**Purpose**: Extract and prepare core sales data from SQL Server

**Key Operations:**
- Connects to AdventureWorks SQL Server database
- Executes three optimized aggregate queries:
  - Monthly top 10 sales performance
  - Top 10 products by revenue
  - Territory sales and average order values
- Pulls complete transaction-level data with product categories
- Saves cleaned data to Parquet format for EDA
- Validates data quality (shape, dtypes, missing values)

**Output**: `clean_sales_lines.parquet` (121,317 transactions with 11 columns)

### 02 - Exploratory Data Analysis (`02_adw_sales_eda.ipynb`)
**Purpose**: Comprehensive analysis with visualizations and business insights

**Analysis Sections:**
1. **Feature Engineering**
   - Revenue per unit, revenue per order, revenue share
   - Product tiering (Low/Medium/High)
   - Territory rankings by sales and order value
   - Cumulative sales and rolling averages

2. **Visualizations**
   - Monthly sales trends with 3-month moving average
   - Cumulative revenue share curves
   - Product performance correlations
   - Territory scatter plots (order value vs. total sales)
   - Category and seasonal breakdowns

3. **Deep-Dive Analysis**
   - Product category sales distribution
   - Mountain bikes vs. other bike types
   - Seasonal patterns by category
   - Time-based features (year, quarter, season, weekend)

**Key Techniques:** Time-series analysis, correlation analysis, quantile-based bucketing, aggregations

### 03 - Data Cleaning Pipeline (`03_adw_cleaning_pipeline.ipynb`)
**Purpose**: Define and test reusable data cleaning function

**Features:**
- `clean_sales_dataframe()` function with parameters:
  - Date type coercion and validation
  - Numeric column handling with error coercion
  - Status-based filtering (excludes cancelled orders)
  - Date range filtering
  - Configurable missing value handling

**Design Pattern**: Reusable utility function for consistent data preprocessing across multiple analyses

---

## Technical Stack

**Database:**
- SQL Server (AdventureWorks sample database)
- ODBC Driver 17 for SQL Server

**Python Libraries:**
- `pandas`: Data manipulation and analysis
- `numpy`: Numerical operations
- `sqlalchemy`: SQL database connections
- `pyodbc`: ODBC database connectivity
- `matplotlib`: Data visualization
- `seaborn`: Statistical visualizations
- `fastparquet`: Parquet file I/O

**Environment:**
- Python 3.x
- Jupyter Notebook / VS Code

---

## Setup Instructions

### Prerequisites
1. SQL Server installed with AdventureWorks database
2. Python 3.8+ installed
3. ODBC Driver 17 for SQL Server

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mpaturi/portfolio-projects.git
   cd portfolio-projects/Python/Project2-AdventureWorks-SQL
2. Install dependencies:
   ```bash
	pip install -r requirements.txt
3. Configure SQL Server connection:
	server = r"MYDELL23\SQLEXPRESS01"
	database = "AdventureWorks"
4. Download AdventureWorks database: Microsoft AdventureWorks Sample Databases

# 1. Extract and clean data
jupyter notebook notebooks/01_adw_sales_queries.ipynb

# 2. Run exploratory analysis
jupyter notebook notebooks/02_adw_sales_eda.ipynb

# 3. (Optional) Test cleaning pipeline
jupyter notebook notebooks/03_adw_cleaning_pipeline.ipynb

Business Recommendations
Based on the analysis, the following actions are recommended:

1. Inventory Management
Stock high-performing Mountain-200 series aggressively
Adjust seasonal inventory levels (increase Spring/Summer bike stock)

2. Territory Strategy
Implement differentiated sales approaches:
Volume territories: Focus on accessibility and promotions
Premium territories: Target B2B accounts and enterprise deals
Expand into regions similar to Southwest (high volume) or Central (high value)

3. Product Strategy
Investigate pricing power for top products (revenue per unit analysis)
Consider bundling strategies for accessories and clothing with bikes
Focus marketing on High-tier products that drive 39% of revenue

4. Seasonal Campaigns
Launch Spring promotional campaigns (peak season)
Offer Winter clearance sales to move inventory during slow season
Target accessories/clothing sales during off-season months

Data Dictionary
Core Tables Used
SalesOrderHeader: Order-level information
SalesOrderID: Unique order identifier
OrderDate: Date order was placed
SubTotal: Pre-tax order amount
Status: Order status (5 = Shipped, 6 = Cancelled)
TerritoryID: Geographic territory

SalesOrderDetail: Line-item details
SalesOrderDetailID: Unique line item identifier
ProductID: Product identifier
OrderQty: Quantity ordered
UnitPrice: Price per unit
LineTotal: Total for line item (qty × price)

Product / ProductCategory / ProductSubcategory: Product hierarchy
Name: Product, category, or subcategory name
ProductCategoryID, ProductSubcategoryID: Hierarchy links

SalesTerritory: Geographic information
TerritoryID: Territory identifier
Name: Territory name (e.g., "Southwest", "Canada")



### Author section
## Author

**Mpaturi**  
[GitHub](https://github.com/mpaturi) | [LinkedIn](https://www.linkedin.com/in/millie-p-b32b072/)