SELECT 
    c.name,
    sg.name as sector,
    cf.debt_to_equity,
    cf.current_ratio,
    cf.quick_ratio,
    cf.market_cap
FROM companies c
JOIN company_financials cf ON c.symbol = cf.symbol
JOIN sector_graph sg ON c.sector_leaf_id = sg.id
WHERE cf.as_of_date = '2025-01-02'
    AND cf.debt_to_equity IS NOT NULL
    AND cf.current_ratio IS NOT NULL
ORDER BY cf.debt_to_equity DESC
LIMIT 20;