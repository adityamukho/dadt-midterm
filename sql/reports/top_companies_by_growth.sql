SELECT 
    c.name,
    CONCAT(sg1.name, '/', sg2.name) as 'Sector/Subsector',
    cf.price_earnings,
    cf.price_book,
    cf.price_sales,
    cf.market_cap
FROM companies c
INNER JOIN sector_graph sg2 on c.sector_leaf_id = sg2.id
INNER JOIN sector_graph sg1 on sg2.parent_id = sg1.id
INNER JOIN company_financials cf ON c.symbol = cf.symbol
WHERE cf.as_of_date = '2025-01-02'
    AND cf.price_earnings > 0
    AND sg1.parent_id IS NULL
ORDER BY (cf.price_earnings * cf.price_book * cf.price_sales) DESC
LIMIT 10;
