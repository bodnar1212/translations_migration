SET SESSION sort_buffer_size = 67108864;
SET SESSION read_buffer_size = 4194304;
SET SESSION transaction_isolation = 'READ-COMMITTED';

DROP PROCEDURE IF EXISTS prune_orphans;
DELIMITER $$
CREATE PROCEDURE prune_orphans()
BEGIN
    DECLARE batch_lo INT DEFAULT 0;
    DECLARE batch_hi INT DEFAULT NULL;

    REPEAT
        SET batch_hi = (SELECT MAX(seq)
                        FROM (SELECT seq
                              FROM orphan_otci
                              WHERE seq > batch_lo
                              ORDER BY seq
                              LIMIT 50000) x);

        IF batch_hi IS NOT NULL THEN
            DELETE otci
            FROM original_text_collection_item otci
                     JOIN orphan_otci s
                          ON s.original_text_id = otci.original_text_id
                              AND s.collection_item_id = otci.collection_item_id
            WHERE s.seq > batch_lo
              AND s.seq <= batch_hi;
            SET batch_lo = batch_hi;
            DO SLEEP(0.2);
        END IF;
    UNTIL batch_hi IS NULL END REPEAT;
END$$
DELIMITER ;

CALL prune_orphans();
DROP PROCEDURE prune_orphans;
DROP TABLE orphan_otci;
