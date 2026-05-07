SET SESSION sort_buffer_size = 67108864;
SET SESSION read_buffer_size = 4194304;
SET SESSION transaction_isolation = 'READ-COMMITTED';

DROP TABLE IF EXISTS orphan_otci;
CREATE TABLE orphan_otci
(
    seq                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    original_text_id   INT NOT NULL,
    collection_item_id INT NOT NULL,
    KEY (original_text_id, collection_item_id)
) ENGINE = InnoDB;

INSERT INTO orphan_otci (original_text_id, collection_item_id)
SELECT o.original_text_id, o.collection_item_id
FROM original_text_collection_item o
         LEFT JOIN collection_item c ON c.id = o.collection_item_id
WHERE c.id IS NULL;
