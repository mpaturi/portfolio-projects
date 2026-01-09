-- 01_yoy_sales_by_year.sql
-- Supports Page 1: YOY Sales % by Year column chart and YOY KPI
-- Uses LAG() to calculate prior-year sales and YoY %, feeding the Overview YOY chart.

WITH YearSales AS (
    SELECT
        YEAR(soh.OrderDate) AS [Year],
        SUM(soh.SubTotal)   AS Sales
    FROM Sales.SalesOrderHeader AS soh
    GROUP BY YEAR(soh.OrderDate)
)
SELECT
    [Year],
    Sales,
    LAG(Sales) OVER (ORDER BY [Year]) AS PYSales,
    (Sales * 1.0 - LAG(Sales) OVER (ORDER BY [Year]))
        / NULLIF(LAG(Sales) OVER (ORDER BY [Year]), 0) AS YOYPercent
FROM YearSales
ORDER BY [Year];