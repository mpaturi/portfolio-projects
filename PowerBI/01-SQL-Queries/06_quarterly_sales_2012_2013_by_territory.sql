-- 06_quarterly_sales_2012_2013_by_territory.sql
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