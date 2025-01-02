SELECT 
    sg.name as sector,
    COUNT(CASE WHEN cf.price_book < 1.5 AND cf.price_earnings < 15 THEN 1 END) as value_companies,
    COUNT(CASE WHEN cf.price_book > 3 AND cf.price_earnings > 25 THEN 1 END) as growth_companies,
    AVG(cf.price_book) as avg_pb_ratio,
    AVG(cf.price_earnings) as avg_pe_ratio
FROM sector_graph sg
JOIN companies c ON c.sector_leaf_id = sg.id
JOIN company_financials cf ON c.symbol = cf.symbol
WHERE cf.as_of_date = '2025-01-02'
    AND sg.parent_id IS NULL
    AND cf.price_earnings > 0
GROUP BY sg.name
ORDER BY avg_pe_ratio DESC; 