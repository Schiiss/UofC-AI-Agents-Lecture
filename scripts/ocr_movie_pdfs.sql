SET STATEMENT_TIMEOUT = 86400; -- 24 hours in seconds
DECLARE parse_extensions ARRAY<STRING> DEFAULT array('.pdf', '.jpg', '.jpeg', '.png');
CREATE TABLE IDENTIFIER(:destinationTableName) AS (
-- Parse documents with ai_parse
WITH all_files AS (
  SELECT
    path,
    content
  FROM
    READ_FILES(:sourceVolumePath, format => 'binaryFile')
  ORDER BY
    path ASC
  LIMIT INT(:limit)
),
repartitioned_files AS (
  SELECT *
  FROM all_files
  -- Force Spark to split into partitions
  DISTRIBUTE BY crc32(path) % INT(:partitionCount)
),
-- Parse the files using ai_parse document
parsed_documents AS (
  SELECT
    path,
    ai_parse_document(content) as parsed
  FROM
    repartitioned_files
  WHERE array_contains(parse_extensions, lower(regexp_extract(path, r'(\.[^.]+)$', 1)))
),
raw_documents AS (
  SELECT
    path,
    null as raw_parsed,
    decode(content, 'utf-8') as text,
    null as error_status
  FROM 
    repartitioned_files
  WHERE NOT array_contains(parse_extensions, lower(regexp_extract(path, r'(\.[^.]+)$', 1)))
),
-- Mark documents with ai_parse errors
error_documents AS (
  SELECT
    path,
    parsed as raw_parsed,
    null as text,
    try_cast(parsed:error_status AS STRING) AS error_status
  FROM
    parsed_documents
  WHERE try_cast(parsed:error_status AS STRING) IS NOT NULL
),
-- Extract content from ai_parse_document output for all successful parses
sorted_contents AS (
  SELECT
    path,
    element:content AS content
  FROM
    (
      SELECT
        path,
          posexplode(
            CASE
              WHEN try_cast(parsed:metadata:version AS STRING) = '1.0' 
              THEN try_cast(parsed:document:pages AS ARRAY<VARIANT>)
              ELSE try_cast(parsed:document:elements AS ARRAY<VARIANT>)
            END
          ) AS (idx, element)
      FROM
        parsed_documents
      WHERE try_cast(parsed:error_status AS STRING) IS NULL
    )
  ORDER BY
    idx
),
-- Concatenate so we have 1 row per document
concatenated AS (
    SELECT
        path,
        concat_ws('

', collect_list(content)) AS full_content
    FROM
        sorted_contents
    WHERE content IS NOT NULL
    GROUP BY
        path
),
-- Bring back the raw parsing since it could be useful for other downstream uses
with_raw AS (
    SELECT
        a.path,
        b.parsed as raw_parsed,
        a.full_content as text,
        null as error_status
    FROM concatenated a
    JOIN parsed_documents b ON a.path = b.path
)
-- Recombine raw text documents with parsed documents
SELECT *  FROM with_raw
UNION ALL 
SELECT * FROM raw_documents
UNION ALL
SELECT * FROM error_documents
);
-- Display a sample from the table
SELECT
    *
FROM IDENTIFIER(:destinationTableName)
LIMIT 20