CREATE TABLE IF NOT EXISTS sector_graph
(
    id        INT AUTO_INCREMENT PRIMARY KEY,
    parent_id INT,
    name      VARCHAR(255) NOT NULL,
    FOREIGN KEY (parent_id) REFERENCES sector_graph (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS companies
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

CREATE TABLE IF NOT EXISTS company_financials
(
    symbol              VARCHAR(10) NOT NULL,
    as_of_date          DATE        NOT NULL,
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
    PRIMARY KEY (symbol, as_of_date),
    FOREIGN KEY (symbol) REFERENCES companies (symbol) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS sp500_index_data
(
    date                 DATE PRIMARY KEY,
    level                DECIMAL(20, 16),
    dividend             DECIMAL(20, 16),
    earnings             DECIMAL(20, 16),
    consumer_price_index DECIMAL(20, 16),
    long_interest_rate   DECIMAL(20, 16),
    real_price           DECIMAL(20, 16),
    real_dividend        DECIMAL(20, 16),
    real_earnings        DECIMAL(20, 16),
    pe_10                DECIMAL(20, 16)
);