CREATE TEMPORARY TABLE IF NOT EXISTS temp_sector_graph
(
    sector     VARCHAR(255) NOT NULL,
    sub_sector VARCHAR(255) NOT NULL
);

TRUNCATE temp_sector_graph;

LOAD DATA LOCAL INFILE 'data/s-and-p-500-companies/data/constituents.csv'
    INTO TABLE temp_sector_graph
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    IGNORE 1 LINES
    (@Symbol, @Security, @GICS_Sector, @GICS_Sub_Industry)
    SET sector = @GICS_Sector,
        sub_sector = @GICS_Sub_Industry;

INSERT IGNORE INTO sector_graph (name)
SELECT temp_sector_graph.sector
from temp_sector_graph;

INSERT IGNORE INTO sector_graph (name)
SELECT temp_sector_graph.sub_sector
from temp_sector_graph;

UPDATE sector_graph sg
INNER JOIN (
    SELECT sg2.id AS sub_sector_id, sg1.id AS parent_id
    FROM sector_graph sg1
    INNER JOIN temp_sector_graph tsg ON sg1.name = tsg.sector
    INNER JOIN sector_graph sg2 ON tsg.sub_sector = sg2.name
    WHERE sg2.parent_id IS NULL
) AS derived
ON sg.id = derived.sub_sector_id
SET sg.parent_id = derived.parent_id;

DROP TEMPORARY TABLE IF EXISTS temp_sector_graph;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_sector
(
    sector VARCHAR(255) NOT NULL
);

TRUNCATE temp_sector;

LOAD DATA LOCAL INFILE 'data/s-and-p-500-companies-financials/data/constituents.csv'
    INTO TABLE temp_sector
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (@Symbol, @Name, @Sector)
    SET sector = @Sector;

SELECT count(a.sector)
FROM (SELECT ts.sector, sg.name
      FROM temp_sector ts
               LEFT OUTER JOIN sector_graph sg on ts.sector = sg.name) a
WHERE a.name IS NULL;

DROP TEMPORARY TABLE IF EXISTS temp_sector;