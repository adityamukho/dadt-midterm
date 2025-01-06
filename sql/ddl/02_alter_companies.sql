-- Enlarge the column capacities from 20 to 50.
-- This operation is inherently idempotent.

ALTER TABLE companies
    MODIFY founded VARCHAR(50) NOT NULL,
    MODIFY sec_filings VARCHAR(255) NULL;
