-- 06_quarterly_sales_2012_2013_by_territory.sql
-- Business Question: How do quarterly sales compare between 2012 and 2013 across territories?
-- Key Insight: Q2 and Q3 show strongest growth in 2013 vs 2012, Q4 2013 slightly weaker than 2012
-- Supports Page 3: Quarterly Sales Comparison (2012 vs 2013) by territory

SELECT
    YEAR(soh.OrderDate)                         AS OrderYear,
    DATEPART(QUARTER, soh.OrderDate)            AS OrderQuarter,
    st.Name                                     AS TerritoryName,
    SUM(soh.TotalDue)                           AS TotalSales
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
WHERE YEAR(soh.OrderDate) IN (2012, 2013)
GROUP BY
    YEAR(soh.OrderDate),
    DATEPART(QUARTER, soh.OrderDate),
    st.Name
ORDER BY
    TerritoryName,
    OrderYear,
    OrderQuarter;