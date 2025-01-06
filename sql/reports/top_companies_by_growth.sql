-- Sort companies in desc order by a derived growth metric
SELECT 
    c.name,
    CONCAT(sg1.name, '/', sg2.name) as sector_subsector,
    cf.price_earnings,
    cf.price_book,
    cf.price_sales,
    cf.market_cap
FROM companies c
-- Self-join on the sector_graph table to fetch parent and child levels
INNER JOIN sector_graph sg2 on c.sector_leaf_id = sg2.id
INNER JOIN sector_graph sg1 on sg2.parent_id = sg1.id
INNER JOIN company_financials cf ON c.symbol = cf.symbol
WHERE cf.price_earnings > 0
    AND sg1.parent_id IS NULL
-- Compute the derived growth metric inline in the sort clause
ORDER BY (cf.price_earnings * cf.price_book * cf.price_sales) DESC
LIMIT 10;
