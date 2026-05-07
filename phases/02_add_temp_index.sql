SET SESSION sort_buffer_size = 67108864;
SET SESSION read_buffer_size = 4194304;
SET SESSION transaction_isolation = 'READ-COMMITTED';

ALTER TABLE original_text
    ADD INDEX idx_dedupe_tmp (project_iri, hash, id),
    ALGORITHM = INPLACE,
    LOCK = NONE;
