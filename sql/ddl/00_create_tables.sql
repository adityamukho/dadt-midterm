CREATE TABLE companies (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    ticker VARCHAR(10) UNIQUE NOT NULL,
    sector VARCHAR(255),
    industry VARCHAR(255),
    market_cap BIGINT
);

CREATE TABLE stock_prices (
    price_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    date DATE NOT NULL,
    open_price DECIMAL(10, 2),
    close_price DECIMAL(10, 2),
    high DECIMAL(10, 2),
    low DECIMAL(10, 2),
    volume BIGINT,
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
);

CREATE TABLE market_indices (
    index_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    ticker VARCHAR(10) UNIQUE NOT NULL,
    description TEXT,
    region VARCHAR(255)
);

CREATE TABLE index_components (
    index_id INT NOT NULL,
    company_id INT NOT NULL,
    PRIMARY KEY (index_id, company_id),
    FOREIGN KEY (index_id) REFERENCES market_indices(index_id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
);

CREATE TABLE historical_indices (
    index_price_id INT AUTO_INCREMENT PRIMARY KEY,
    index_id INT NOT NULL,
    date DATE NOT NULL,
    open_price DECIMAL(10, 2),
    close_price DECIMAL(10, 2),
    high DECIMAL(10, 2),
    low DECIMAL(10, 2),
    volume BIGINT,
    FOREIGN KEY (index_id) REFERENCES market_indices(index_id) ON DELETE CASCADE
);

-- CREATE TABLE transactions (
--     transaction_id INT AUTO_INCREMENT PRIMARY KEY,
--     company_id INT NOT NULL,
--     date DATE NOT NULL,
--     transaction_type ENUM('buy', 'sell') NOT NULL,
--     quantity INT,
--     price DECIMAL(10, 2),
--     FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
-- );
