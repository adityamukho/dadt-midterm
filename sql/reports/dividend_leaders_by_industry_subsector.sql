SELECT 
    sg.name as subsector,
    c.name as company,
    cf.dividend_yield,
    cf.market_cap,
    cf.price_earnings
FROM companies c
JOIN company_financials cf ON c.symbol = cf.symbol
JOIN sector_graph sg ON c.sector_leaf_id = sg.id
WHERE cf.as_of_date = '2025-01-02'
    AND cf.dividend_yield > 0
ORDER BY cf.dividend_yield DESC
LIMIT 15;
