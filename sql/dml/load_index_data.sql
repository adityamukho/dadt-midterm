LOAD DATA LOCAL INFILE 'data/s-and-p-500/data/data.csv'
    IGNORE INTO TABLE sp500_index_data
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    IGNORE 1 LINES
    (@Date, @SP500, @Dividend, @Earnings, @Consumer_Price_Index, @Long_Interest_Rate, @Real_Price, @Real_Dividend,
     @Real_Earnings, @PE10)
    SET date = @Date,
        level = @SP500,
        dividend = @Dividend,
        earnings = @Earnings,
        consumer_price_index = @Consumer_Price_Index,
        long_interest_rate = @Long_Interest_Rate,
        real_price = @Real_Price,
        real_dividend = @Real_Dividend,
        real_earnings = @Real_Earnings,
        pe_10 = @PE10;