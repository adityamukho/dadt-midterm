-- Create a temp table to load the relevant columns from `companies` constituents
CREATE TEMPORARY TABLE IF NOT EXISTS temp_company_fields_1
(
    symbol       VARCHAR(10)  NOT NULL,
    name         VARCHAR(255) NOT NULL,
    sub_sector   VARCHAR(255) NOT NULL,
    headquarters VARCHAR(255) NOT NULL,
    date_added   DATE         NOT NULL,
    cik          INT          NOT NULL,
    founded      VARCHAR(50)  NOT NULL
);

-- Ensure it is empty initially
TRUNCATE temp_company_fields_1;

-- Load the CSV data
LOAD DATA LOCAL INFILE 'data/s-and-p-500-companies/data/constituents.csv'
    INTO TABLE temp_company_fields_1
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    IGNORE 1 LINES
    (@Symbol, @Security, @GICS_Sector, @GICS_Sub_Industry, @Headquarters_Location, @Date_Added, @CIK, @Founded)
    SET symbol = @Symbol,
        name = @Security,
        sub_sector = @GICS_Sub_Industry,
        headquarters = @Headquarters_Location,
        date_added = @Date_Added,
        cik = @CIK,
        founded = @Founded;

-- Create a temp table to load the relevant columns from `companies-financials` constituents
CREATE TEMPORARY TABLE IF NOT EXISTS temp_company_fields_2
(
    symbol      VARCHAR(10)  NOT NULL,
    sec_filings VARCHAR(255) NOT NULL
);

-- Ensure it is empty initially
TRUNCATE temp_company_fields_2;

-- Load the CSV data
LOAD DATA LOCAL INFILE 'data/s-and-p-500-companies-financials/data/constituents-financials.csv'
    INTO TABLE temp_company_fields_2
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (@Symbol, @Name, @Sector, @Price, @Price_Earnings, @Dividend_Yield, @Earnings_Share, @52_Week_Low, @52_Week_High,
     @Market_Cap, @EBITDA, @Price_Sales, @Price_Book, @SEC_Filings)
    SET symbol = @Symbol,
        sec_filings = @SEC_Filings;

-- Insert rows into the companies tables, picking columns from both temp tables
INSERT IGNORE INTO companies (symbol, name, sector_leaf_id, headquarters, date_added, cik, founded, sec_filings)
SELECT t1.symbol,
       t1.name,
       sg.id,
       t1.headquarters,
       t1.date_added,
       t1.cik,
       t1.founded,
       t2.sec_filings
FROM temp_company_fields_1 t1
         INNER JOIN sector_graph sg on t1.sub_sector = sg.name
         LEFT OUTER JOIN temp_company_fields_2 t2 on t1.symbol = t2.symbol;

-- Cleanup
DROP TEMPORARY TABLE IF EXISTS temp_company_fields_1;
DROP TEMPORARY TABLE IF EXISTS temp_company_fields_2;