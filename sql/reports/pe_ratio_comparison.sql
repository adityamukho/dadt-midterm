SELECT 
    s1.name as sector,
    s2.name as subsector,
    AVG(cf.price_earnings) as avg_pe_ratio,
    MIN(cf.price_earnings) as min_pe_ratio,
    MAX(cf.price_earnings) as max_pe_ratio,
    COUNT(DISTINCT c.symbol) as company_count
FROM company_financials cf
INNER JOIN companies c on cf.symbol = c.symbol
INNER JOIN sector_graph s2 ON c.sector_leaf_id = s2.id
INNER JOIN sector_graph s1 on s2.parent_id = s1.id
WHERE cf.price_earnings > 0  -- Exclude negative P/E ratios
AND cf.price_earnings < 500  -- Remove extreme outliers
GROUP BY s1.name, s2.name
ORDER BY s1.name, s2.name;
