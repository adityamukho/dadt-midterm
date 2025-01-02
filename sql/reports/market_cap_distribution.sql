WITH cap_categories AS (
    SELECT 
        c.name,
        cf.market_cap,
        CASE 
            WHEN cf.market_cap >= 200000000000 THEN 'Mega Cap (>200B)'
            WHEN cf.market_cap >= 10000000000 THEN 'Large Cap (10B-200B)'
            ELSE 'Mid Cap (<10B)'
        END as cap_category
    FROM companies c
    JOIN company_financials cf ON c.symbol = cf.symbol
    WHERE cf.as_of_date = '2025-01-02'
)
SELECT 
    cap_category,
    COUNT(*) as company_count,
    AVG(market_cap) as avg_market_cap,
    MIN(market_cap) as min_market_cap,
    MAX(market_cap) as max_market_cap
FROM cap_categories
GROUP BY cap_category
ORDER BY min_market_cap DESC; 