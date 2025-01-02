DELIMITER //

DROP PROCEDURE IF EXISTS addUniqueConstraintIfNotExists;

CREATE PROCEDURE addUniqueConstraintIfNotExists()
BEGIN
    -- Check if the unique constraint already exists
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.TABLE_CONSTRAINTS
        WHERE TABLE_NAME = 'sector_graph'
          AND CONSTRAINT_NAME = 'sector_graph_pk'
    ) THEN
        ALTER TABLE sector_graph
            ADD CONSTRAINT sector_graph_pk
                UNIQUE (name);
    END IF;
END //

DELIMITER ;

CALL addUniqueConstraintIfNotExists();
