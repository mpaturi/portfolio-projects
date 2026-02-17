# AdventureWorks Sales Dashboard (2011–2014)

## Project Overview

An end-to-end sales analytics solution for AdventureWorks (2011–2014) demonstrating modern BI and AI integration:

- **Data Layer:** Curated T-SQL queries surface year-over-year sales trends, monthly seasonality, territory performance, and product margins from SQL Server (AdventureWorksDW).
- **Visualization Layer:** Power BI dashboard with executive KPI cards and interactive drill-downs by year, month, territory, and product.
- **API Layer:** FastAPI service exposes `/kpis` and `/explain-kpis` endpoints for programmatic access to metrics.
- **AI Layer:** LangChain + Ollama (local Llama 3.2 model) generates natural-language executive summaries from live sales data, making the dashboard insights consumable by downstream applications and LLMs.

This project showcases SQL, Power BI, Python, FastAPI, and modern LLM integration in a production-style BI pipeline.

## Dataset and Model
- Source: AdventureWorks OLTP (June 2011– June 2014) sales orders.
- Tables: FactSalesDetail at order-line grain, DimDate, DimProduct, DimCustomer, DimTerritory, SalesHeader.
- Tools: SQL Server, Power Query, Power BI Desktop, DAX measures, Drillthrough navigation.
- End-to-end flow: Data is pulled from SQL Server (AdventureWorksDW) using curated T‑SQL queries, exported to clean views/tables, and then modeled in Power BI to power the executive Overview and detail pages.

### Data Model (Star Schema)
![Star schema](04-Screenshots/Sales-StarSchema.png)

## Page 1 – Sales Overview
**Purpose:** Purpose: Give executives a quick view of revenue, order volume, and average order value trends from 2011–2014.
Behind this page are curated SQL queries that calculate YoY sales and monthly trends, which feed the KPI cards and the two trend charts.

### Page 1 – Sales Overview
![Sales Overview](04-Screenshots/OverviewPage.png) 

**Key findings**
- Sales grow from 2011 and peak in 2013, then drop sharply in partial year 2014, pulling down YoY growth.
- From 2011–2014 the business generates roughly $110M in revenue from about 31K orders, with an average order value around $3.5K.
- Monthly sales follow a clear seasonal pattern with an early‑year peak and weaker summer months, which informs staffing and campaign planning.
- High-priced bikes (e.g., Mountain-200) dominate Total Sales, while accessories like Fender Set – Mountain lead in Gross Margin %, generating about 62% profit per dollar of revenue.
- Southwest and a few other regions lead in Total Sales, and Average Order Value varies by region, suggesting regional differences in product mix and typical order size.

## Page 2 – Sales Analysis
**Purpose:** Break down sales and average order value by territory and product line to show where revenue and basket size are strongest.

### Page 2 – Sales Analysis
![Sales Analysis](04-Screenshots/SalesAnalysis.png)

**Key findings**
- Southwest and Northwest are the largest territories by Total Sales, with several other regions (e.g., Canada, Central) forming a strong second tier.
- Mountain (M) product lines dominate revenue across most territories, while Road (R) and Touring (T) products still contribute meaningful share in specific regions.
- Average Order Value varies significantly by territory: some regions generate fewer orders but much higher AOV, indicating fewer but larger, higher-value baskets in terms of revenue per order.
- Combining the bar chart and matrix highlights territories where high-margin product lines (like accessories) are under-penetrated, suggesting clear cross-sell and upsell opportunities.

## Page 3 – Territory Details (Drillthrough)
**Purpose:** Deep dive into single territory performance with 2012-2013 focus.

### Page 3 – Territory Details (Drillthrough)
![Territory Details](04-Screenshots/TerritoryDetails.png)

**Key visuals & insights:**
- **Gauge**: 2013 sales vs 2012 target (territory-specific performance)
- **Monthly trend**: 2012 (blue) vs 2013 (orange) line chart showing seasonal patterns
- **6 KPI cards**: Total Sales, Order Quantity, Avg Order Vol, Gross Margin %, Order Count, YoY Sales %
- **Top Products table**: Conditional formatting (green high-margin, red low-margin)
- **Product donut**: Top 3 product lines by sales distribution
- **Quarterly columns**: 2012 (blue) vs 2013 (orange) comparison

**Navigation**: Drill from Sales Analysis to Territory Details visuals to this page.

**Core measures**
- **Total Sales** – sum of LineTotal (quantity × unit price) from the detail table.
- **YOY Sales & YOY Sales %** – current vs. prior‑year sales using SAMEPERIODLASTYEAR with a blank check for missing prior periods.
- **Total Cost, Gross Margin & Gross Margin %** – standard‑cost‑based profitability measures.
- **Order Count** – distinct SalesOrderID (number of orders).
- **Average Order Value (AOV)** – Total Sales ÷ Order Count (average revenue per order).

## Files
- [AdventureWorks_Sales.pbix](03-PowerBI/AdventureWorks_Sales.pbix)

## Implementation Notes
- Star schema with automatic drillthrough filtering
- Wrote T-SQL queries in SQL Server to extract sales header/detail, product, customer, and territory data from AdventureWorks OLTP (2011–2014).
- Cleaned and modeled the data in Power Query, building a star schema with FactSalesDetail at order-line grain and DimDate, DimProduct, DimCustomer, DimTerritory, plus a SalesHeader helper table.
- Created DAX measures for Total Sales, YOY Sales/%, Total Cost, Gross Margin/%, Order Count, and Average Order Value, then used them to design the report pages.
- 2012-2013 focus on Territory Details excludes partial 2011/2014 years.

## SQL Layer

## SQL Queries and Supported Visuals
- [SQL queries](01-SQL-Queries/)
- [SQL outputs](02-SQL-Outputs/)

1. **01_yoy_sales_by_year.sql**  
   - **Page:** Sales Overview  
   - **Supports:**  
     - "YOY Sales % by Year" column chart  
     - YOY KPI cards (Total Sales, Total Sales PY, YOY Sales %)
     - Built a YoY sales trend query so leadership can quickly see whether revenue is accelerating, flat, or declining.

2. **02_total_sales_by_month_2011_2014.sql**  
   - **Page:** Sales Overview  
   - **Supports:**  
     - "Total Sales by Month" line chart  
     - Seasonal pattern used in narrative
     - Built a monthly sales trend query so leadership can see seasonal patterns across years, compare each month to its history, and plan staffing and campaigns around predictable peaks and slowdowns.

3. **03_sales_by_territory_and_rank.sql**  
   - **Page:** Sales Analysis  
   - **Supports:**  
     - "Sales by Territory" bar chart  
     - Territory map (bubble size by Total Sales)  
     - Insight that Southwest/Northwest are top territories

4. **04_product_margin_by_territory_topN.sql**  
   - **Page:** Territory Details  
   - **Supports:**  
     - "Top Products by Sales (Territory)" table with Gross Margin % conditional formatting  
     - Margin-focused commentary (high vs low margin products)

5. **05_top_products_by_sales_per_territory.sql**  
   - **Page:** Territory Details  
   - **Supports:**  
     - Revenue ranking in "Top Products by Sales (Territory)"  
     - Cross-check of DAX Top N products logic

6. **06_quarterly_sales_2012_2013_by_territory.sql**  
   - **Page:** Territory Details  
   - **Supports:**  
     - "Quarterly Sales Comparison" clustered column chart (2012 vs 2013)  
     - 2012–2013 territory performance story

## FastAPI KPIs service
- Exposed a lightweight FastAPI app ('/kpis') that returns key sales KPIs as JSON:
  - 'total_sales_2011_2014'
  - 'yoy_sales_percent_by_year' (dict of year → YoY %)
  - 'total_orders_2011_2014'
- This makes the dashboard metrics consumable by other apps, scripts, or future AI/LLM components.
- Added an `/explain-kpis` endpoint that returns an executive-ready narrative summary of the sales KPIs.
- Designed the API to be LLM-ready so the current template-based summary can later be powered by a LangChain or other LLM call without changing the client interface.
- Added an `/explain-kpis` endpoint that uses a local Llama 3.2 model via Ollama and LangChain to generate executive-ready narratives from sales KPIs, demonstrating AI integration in a BI pipeline.
