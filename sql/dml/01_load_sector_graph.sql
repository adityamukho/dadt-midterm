-- Create a temp table to load the relevant columns from `companies` constituents
CREATE TEMPORARY TABLE IF NOT EXISTS temp_sector_graph
(
    sector     VARCHAR(255) NOT NULL,
    sub_sector VARCHAR(255) NOT NULL
);

-- Ensure it is empty initially
TRUNCATE temp_sector_graph;

-- Load the CSV data
LOAD DATA LOCAL INFILE 'data/s-and-p-500-companies/data/constituents.csv'
    INTO TABLE temp_sector_graph
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    IGNORE 1 LINES
    (@Symbol, @Security, @GICS_Sector, @GICS_Sub_Industry)
    SET sector = @GICS_Sector,
        sub_sector = @GICS_Sub_Industry;

-- Insert level-1 sectors into sector_graph table
-- Ingore 'duplicate' errors for idempotency
INSERT IGNORE INTO sector_graph (name)
SELECT temp_sector_graph.sector
from temp_sector_graph;

-- Insert level-2 subsectors into sector_graph table
-- Ingore 'duplicate' errors for idempotency
INSERT IGNORE INTO sector_graph (name)
SELECT temp_sector_graph.sub_sector
from temp_sector_graph;

-- Update parent_id on subsector rows by matching their
-- parent names to corresponding parent ids
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

-- Cleanup
DROP TEMPORARY TABLE IF EXISTS temp_sector_graph;

-- Validate all required sectors are present in table
-- by cross-checking with 'companies_financials' constituents

-- Create a temp table to load the relevant columns from `companies-financials` constituents
CREATE TEMPORARY TABLE IF NOT EXISTS temp_sector
(
    sector VARCHAR(255) NOT NULL
);

-- Ensure it is empty initially
TRUNCATE temp_sector;

-- Load the CSV data
LOAD DATA LOCAL INFILE 'data/s-and-p-500-companies-financials/data/constituents.csv'
    INTO TABLE temp_sector
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (@Symbol, @Name, @Sector)
    SET sector = @Sector;

-- Show a count of sectors present in temp table (companies-financials` constituents).
-- that are missing from sector_graph. This number should be 0, for ideal data consistency.
SELECT count(a.sector)
FROM (SELECT ts.sector, sg.name
      FROM temp_sector ts
               LEFT OUTER JOIN sector_graph sg on ts.sector = sg.name) a
WHERE a.name IS NULL;

-- Cleanup
DROP TEMPORARY TABLE IF EXISTS temp_sector;