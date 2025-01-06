-- Group value and growth aggregates by sector and subsector
SELECT
    sg1.name as sector,
    sg2.name as subsector,
    COUNT(CASE WHEN cf.price_book < 1.5 AND cf.price_earnings < 15 THEN 1 END) as value_companies,
    COUNT(CASE WHEN cf.price_book > 3 AND cf.price_earnings > 25 THEN 1 END) as growth_companies,
    AVG(cf.price_book) as avg_pb_ratio,
    AVG(cf.price_earnings) as avg_pe_ratio
FROM sector_graph sg1
-- Self-join on the sector_graph table to fetch parent and child levels
INNER JOIN sector_graph sg2 on sg1.id = sg2.parent_id
INNER JOIN companies c ON c.sector_leaf_id = sg2.id
INNER JOIN company_financials cf ON c.symbol = cf.symbol
WHERE sg1.parent_id IS NULL
    AND cf.price_earnings > 0
GROUP BY sector, subsector
ORDER BY sector, subsector;