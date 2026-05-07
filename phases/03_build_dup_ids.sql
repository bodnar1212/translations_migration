SET SESSION sort_buffer_size = 67108864;
SET SESSION read_buffer_size = 4194304;
SET SESSION transaction_isolation = 'READ-COMMITTED';

DROP TABLE IF EXISTS dup_ids;
CREATE TABLE dup_ids
(
    id INT PRIMARY KEY
) ENGINE = InnoDB;

INSERT INTO dup_ids (id)
SELECT id
FROM (SELECT id,
             ROW_NUMBER() OVER (PARTITION BY project_iri, hash ORDER BY id) AS rn
      FROM original_text) x
WHERE rn > 1;
