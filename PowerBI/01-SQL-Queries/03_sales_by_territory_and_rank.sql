-- 03_sales_by_territory_and_rank.sql
-- Supports Page 2: Sales by Territory bar chart and map
-- Ranks territories by total sales using a window function

WITH TerritoryTotals AS (
    SELECT 
        st.Name              AS TerritoryName,
        SUM(soh.TotalDue)    AS TotalSales
    FROM Sales.SalesOrderHeader AS soh
    INNER JOIN Sales.SalesTerritory AS st
        ON soh.TerritoryID = st.TerritoryID
    GROUP BY st.Name
)
SELECT
    TerritoryName,
    TotalSales,
    RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM TerritoryTotals
ORDER BY SalesRank;