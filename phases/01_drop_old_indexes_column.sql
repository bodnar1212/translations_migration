SET SESSION sort_buffer_size = 67108864;
SET SESSION read_buffer_size = 4194304;
SET SESSION transaction_isolation = 'READ-COMMITTED';

ALTER TABLE original_text
    DROP INDEX iri_index,
    DROP INDEX UNIQ_31FECCF1D1B862B835B31D676359007,
    DROP INDEX `text`,
    DROP COLUMN item_iri;
