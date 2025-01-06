-- Ensure local infile data loads are supported.
-- This can fail if DB user has inadequate permissions.
-- However, as long as this is already the default setting,
-- things should still work.
SET GLOBAL local_infile = 1;
