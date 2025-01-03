SELECT 
    parent.name as sector,
    COUNT(DISTINCT c.symbol) as company_count,
    AVG(cf.market_cap) as avg_market_cap,
    AVG(cf.price_earnings) as avg_pe_ratio,
    AVG(cf.dividend_yield) as avg_dividend_yield
FROM sector_graph parent
INNER JOIN sector_graph leaf ON leaf.parent_id = parent.id
INNER JOIN companies c ON c.sector_leaf_id = leaf.id
INNER JOIN company_financials cf ON c.symbol = cf.symbol
WHERE parent.parent_id IS NULL
GROUP BY parent.name
ORDER BY avg_market_cap DESC;
