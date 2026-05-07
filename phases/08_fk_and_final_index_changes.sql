SET SESSION sort_buffer_size = 67108864;
SET SESSION read_buffer_size = 4194304;
SET SESSION transaction_isolation = 'READ-COMMITTED';

SET foreign_key_checks = 0;
ALTER TABLE original_text_collection_item
    DROP INDEX UNIQ_original_text_collection_item,
    ADD CONSTRAINT FK_BCA53ECF4643208F FOREIGN KEY (collection_item_id)
        REFERENCES collection_item (id) ON DELETE CASCADE,
    RENAME INDEX fk_bca53ecf4643208f TO IDX_BCA53ECF4643208F;
SET foreign_key_checks = 1;

DROP INDEX translated_text_text_index ON translated_text;
