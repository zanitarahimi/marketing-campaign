
USE CATALOG {{my_catalog}};
USE IDENTIFIER({{my_schema}});



CREATE OR REPLACE TABLE top_campaigns_with_ai AS
SELECT
  *,  -- Selects all original columns from the source table
  ai_translate(ai_generated_copy, 'es') AS ai_copy_es,
  ai_translate(ai_generated_copy, 'de') AS ai_copy_de,
  ai_translate(ai_generated_copy, 'fr') AS ai_copy_fr,
  ai_analyze_sentiment(ai_generated_copy) AS sentiment
FROM
  top_campaigns_with_ai;
