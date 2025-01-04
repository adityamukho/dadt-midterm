WITH pe_stats AS (
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
    WHERE cf.price_earnings > 0
    AND cf.price_earnings < 500
    GROUP BY s1.name, s2.name
),
median_calc AS (
    SELECT 
        s1.name as sector,
        s2.name as subsector,
        cf.price_earnings as pe_ratio,
        ROW_NUMBER() OVER (PARTITION BY s1.name, s2.name ORDER BY cf.price_earnings) as row_num,
        COUNT(*) OVER (PARTITION BY s1.name, s2.name) as total_rows
    FROM company_financials cf
    INNER JOIN companies c on cf.symbol = c.symbol
    INNER JOIN sector_graph s2 ON c.sector_leaf_id = s2.id
    INNER JOIN sector_graph s1 on s2.parent_id = s1.id
    WHERE cf.price_earnings > 0
    AND cf.price_earnings < 500
)
SELECT 
    p.*,
    AVG(m.pe_ratio) as median_pe_ratio
FROM pe_stats p
LEFT JOIN median_calc m ON p.sector = m.sector 
    AND p.subsector = m.subsector
    AND m.row_num IN (FLOOR((m.total_rows + 1)/2), CEIL((m.total_rows + 1)/2))
GROUP BY 
    p.sector,
    p.subsector,
    p.avg_pe_ratio,
    p.min_pe_ratio,
    p.max_pe_ratio,
    p.company_count
ORDER BY p.sector, p.subsector;
