LOAD DATA LOCAL INFILE 'data/s-and-p-500-companies-financials/data/constituents-financials.csv'
    IGNORE INTO TABLE company_financials
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (@Symbol, @Name, @Sector, @Price, @Price_Earnings, @Dividend_Yield, @Earnings_Share, @52_Week_Low, @52_Week_High,
     @Market_Cap, @EBITDA, @Price_Sales, @Price_Book, @SEC_Filings)
    SET symbol = @Symbol,
        price = @Price,
        price_earnings = @Price_Earnings,
        dividend_yield = @Dividend_Yield,
        earnings_share = @Earnings_Share,
        fifty_two_week_low = @`52_Week_Low`,
        fifty_two_week_high = @`52_Week_High`,
        market_cap = @Market_Cap,
        ebitda = @EBITDA,
        price_sales = @Price_Sales,
        price_book = @Price_Book;