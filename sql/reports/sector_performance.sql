SELECT 
    sg.name as sector,
    COUNT(c.symbol) as company_count,
    AVG(cf.market_cap) as avg_market_cap,
    AVG(cf.price_earnings) as avg_pe_ratio,
    AVG(cf.dividend_yield) as avg_dividend_yield
FROM sector_graph sg
JOIN companies c ON c.sector_leaf_id = sg.id
JOIN company_financials cf ON c.symbol = cf.symbol
WHERE sg.parent_id IS NULL
GROUP BY sg.name
ORDER BY avg_market_cap DESC;
