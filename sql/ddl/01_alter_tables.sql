ALTER TABLE stock_prices RENAME COLUMN open_price TO `open`;
ALTER TABLE stock_prices RENAME COLUMN close_price TO `close`;

ALTER TABLE historical_indices RENAME COLUMN open_price TO `open`;
ALTER TABLE historical_indices RENAME COLUMN close_price TO `close`;