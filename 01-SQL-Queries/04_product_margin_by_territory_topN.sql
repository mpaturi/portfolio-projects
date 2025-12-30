-- 04_product_margin_by_territory.sql
-- Supports: Top Products w/ Gross Margin % table and margin analysis

WITH ProductTerritorySales AS (
    SELECT
        st.Name         AS TerritoryName,
        p.Name          AS ProductName,
        SUM(sod.LineTotal)                    AS TotalSales,
        SUM(sod.OrderQty * p.StandardCost)    AS TotalCost
    FROM Sales.SalesOrderHeader  AS soh
    JOIN Sales.SalesOrderDetail  AS sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Sales.SalesTerritory    AS st  ON soh.TerritoryID  = st.TerritoryID
    JOIN Production.Product      AS p   ON sod.ProductID    = p.ProductID
    GROUP BY
        st.Name,
        p.Name
), ProductTerritoryMargin as (
SELECT
    TerritoryName,
    ProductName,
    TotalSales,
    TotalCost,
    TotalSales - TotalCost                       AS GrossMargin,
    (TotalSales - TotalCost) / NULLIF(TotalSales, 0.0) AS GrossMarginPercent, 
	ROW_NUMBER() over(partition by TerritoryName order by (TotalSales - TotalCost) desc) as RankMargins
FROM ProductTerritorySales)
select * from ProductTerritoryMargin 
where RankMargins <= 10
ORDER BY
    RankMargins DESC, TerritoryName;