DROP TABLE IF EXISTS company_financials;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS sector_graph;

CREATE TABLE sector_graph
(
    id        INT AUTO_INCREMENT PRIMARY KEY,
    parent_id INT,
    name      VARCHAR(255) NOT NULL,
    FOREIGN KEY (parent_id) REFERENCES sector_graph (id) ON DELETE CASCADE
);

CREATE TABLE companies
(
    symbol         VARCHAR(10) PRIMARY KEY,
    name           VARCHAR(255) NOT NULL,
    sector_leaf_id INT,
    headquarters   VARCHAR(255) NOT NULL,
    date_added     DATE         NOT NULL,
    cik            INT          NOT NULL,
    founded        VARCHAR(20)  NOT NULL,
    sec_filings    VARCHAR(255) NOT NULL,
    FOREIGN KEY (sector_leaf_id) REFERENCES sector_graph (id) ON DELETE SET NULL
);

CREATE TABLE company_financials
(
    symbol              VARCHAR(10) NOT NULL,
    price               DECIMAL(20, 16),
    price_earnings      DECIMAL(20, 16),
    dividend_yield      DECIMAL(20, 16),
    earnings_share      DECIMAL(20, 16),
    fifty_two_week_low  DECIMAL(20, 16),
    fifty_two_week_high DECIMAL(20, 16),
    market_cap          BIGINT,
    ebitda              BIGINT,
    price_sales         DECIMAL(20, 16),
    price_book          DECIMAL(20, 16),
    PRIMARY KEY (symbol),
    FOREIGN KEY (symbol) REFERENCES companies (symbol) ON DELETE CASCADE
);