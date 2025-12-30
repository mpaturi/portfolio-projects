-- 02_total_sales_by_month_2011_2014.sql
-- Supports Page 1: Total Sales by Month line chart (seasonality across years)

SELECT 
    YEAR(soh.OrderDate)          AS OrderYear,
    MONTH(soh.OrderDate)         AS OrderMonth,
    DATENAME(MONTH, soh.OrderDate) AS MonthName,
    SUM(soh.SubTotal)            AS MonthlySales
FROM Sales.SalesOrderHeader AS soh
WHERE YEAR(soh.OrderDate) BETWEEN 2011 AND 2014
GROUP BY 
    YEAR(soh.OrderDate),
    MONTH(soh.OrderDate),
    DATENAME(MONTH, soh.OrderDate)
ORDER BY 
    OrderYear,
    OrderMonth;