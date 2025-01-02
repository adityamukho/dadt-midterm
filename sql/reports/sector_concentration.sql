SELECT 
    sg.name as sector,
    COUNT(c.symbol) as num_companies,
    SUM(cf.market_cap) as total_market_cap,
    ROUND(SUM(cf.market_cap) / (SELECT SUM(market_cap) FROM company_financials WHERE as_of_date = '2025-01-02') * 100, 2) as market_cap_percentage
FROM sector_graph sg
JOIN companies c ON c.sector_leaf_id = sg.id
JOIN company_financials cf ON c.symbol = cf.symbol
WHERE cf.as_of_date = '2025-01-02'
    AND sg.parent_id IS NULL
GROUP BY sg.name
ORDER BY total_market_cap DESC; 