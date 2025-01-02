WITH current_pe AS (
    SELECT AVG(cf.price_earnings) as current_avg_pe
    FROM company_financials cf
    WHERE as_of_date = '2025-01-02'
)
SELECT 
    YEAR(sid.date) as year,
    AVG(sid.pe_10) as historical_pe_10,
    current_pe.current_avg_pe
FROM sp500_index_data sid
CROSS JOIN current_pe
WHERE YEAR(sid.date) >= 2020
GROUP BY YEAR(sid.date)
ORDER BY year;
