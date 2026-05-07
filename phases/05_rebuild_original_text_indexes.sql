SET SESSION sort_buffer_size = 67108864;
SET SESSION read_buffer_size = 4194304;
SET SESSION transaction_isolation = 'READ-COMMITTED';

ALTER TABLE original_text
    ADD INDEX IDX_31FECCF135B31D68CDE5729 (project_iri, type),
    ADD UNIQUE INDEX UNIQ_31FECCF1D1B862B835B31D6 (hash, project_iri),
    DROP INDEX idx_dedupe_tmp;
