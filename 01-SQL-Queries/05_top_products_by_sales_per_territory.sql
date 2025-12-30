-- 05_top_products_by_sales_per_territory.sql
-- Supports Page 3: Top Products by Sales (Territory) visual
-- Returns the top product by TotalSales in each territory using ROW_NUMBER()
-- Uses ROW_NUMBER() to find the top product in each territory, supporting the 
--Territory Details Top Products visual.

WITH TerritorySales AS (
    SELECT
        st.Name          AS TerritoryName,
        p.Name           AS ProductName,
        SUM(soh.TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader  AS soh
    INNER JOIN Sales.SalesTerritory AS st
        ON soh.TerritoryID = st.TerritoryID
    INNER JOIN Sales.SalesOrderDetail AS sod
        ON sod.SalesOrderID = soh.SalesOrderID
    INNER JOIN Production.Product AS p
        ON p.ProductID = sod.ProductID
    GROUP BY st.Name, p.Name
),
Ranked AS (
    SELECT
        TerritoryName,
        ProductName,
        TotalSales,
        ROW_NUMBER() OVER (
            PARTITION BY TerritoryName
            ORDER BY TotalSales DESC
        ) AS SalesRank
    FROM TerritorySales
)
SELECT
    TerritoryName,
    ProductName,
    TotalSales,
    SalesRank
FROM Ranked
WHERE SalesRank = 1   -- change to <= 10 for Top 10 per territory
ORDER BY TerritoryName, SalesRank;