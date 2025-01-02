CREATE TEMPORARY TABLE IF NOT EXISTS sector_graph_raw
(
    sector     VARCHAR(255) NOT NULL,
    sub_sector VARCHAR(255) NOT NULL
);

TRUNCATE sector_graph_raw;

LOAD DATA LOCAL INFILE 'data/s-and-p-500-companies/data/constituents.csv'
    IGNORE INTO TABLE sector_graph_raw
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    IGNORE 1 LINES
    (@Symbol, @Security, @GICS_Sector, @GICS_Sub_Industry, @Headquarters_Location, @Date_Added, @CIK, @Founded)
    SET sector = @GICS_Sector,
        sub_sector = @GICS_Sub_Industry;

INSERT IGNORE INTO sector_graph (name)
SELECT sector_graph_raw.sector
from sector_graph_raw;

INSERT IGNORE INTO sector_graph (name)
SELECT sector_graph_raw.sub_sector
from sector_graph_raw;

UPDATE sector_graph sg
SET parent_id = (SELECT DISTINCT sg1.id
                 FROM sector_graph sg1
                          INNER JOIN sector_graph_raw sgr ON sg1.name = sgr.sector
                 WHERE sgr.sub_sector = sg.name)
WHERE parent_id IS NULL;

DROP TEMPORARY TABLE IF EXISTS sector_graph_raw;
