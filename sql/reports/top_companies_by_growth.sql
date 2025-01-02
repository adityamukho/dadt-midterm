SELECT 
    c.name,
    c.sector_leaf_id,
    cf.price_earnings,
    cf.price_book,
    cf.price_sales,
    cf.market_cap
FROM companies c
JOIN company_financials cf ON c.symbol = cf.symbol
WHERE cf.as_of_date = '2025-01-02'
    AND cf.price_earnings > 0
ORDER BY (cf.price_earnings * cf.price_book * cf.price_sales) DESC
LIMIT 10;
