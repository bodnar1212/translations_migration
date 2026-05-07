SET SESSION sort_buffer_size = 67108864;
SET SESSION read_buffer_size = 4194304;
SET SESSION transaction_isolation = 'READ-COMMITTED';

DROP PROCEDURE IF EXISTS prune_dups;
DELIMITER $$
CREATE PROCEDURE prune_dups()
BEGIN
    DECLARE batch_lo INT DEFAULT 0;
    DECLARE batch_hi INT DEFAULT NULL;

    REPEAT
        SET batch_hi = (SELECT MAX(id)
                        FROM (SELECT id
                              FROM dup_ids
                              WHERE id > batch_lo
                              ORDER BY id
                              LIMIT 50000) x);

        IF batch_hi IS NOT NULL THEN
            DELETE o
            FROM original_text o
                     JOIN dup_ids d ON d.id = o.id
            WHERE d.id > batch_lo
              AND d.id <= batch_hi;
            SET batch_lo = batch_hi;
            DO SLEEP(0.2);
        END IF;
    UNTIL batch_hi IS NULL END REPEAT;
END$$
DELIMITER ;

CALL prune_dups();
DROP PROCEDURE prune_dups;
DROP TABLE dup_ids;
