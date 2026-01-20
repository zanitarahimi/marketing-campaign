-- Create a SDP Streaming Table for prospect/company data

CREATE STREAMING TABLE raw_prospects
( 
  CONSTRAINT valid_prospect_id EXPECT (ProspectId IS NOT NULL)
)
TBLPROPERTIES ("quality" = "bronze")
COMMENT "Streaming table for prospect/company information"
AS SELECT
  *
FROM STREAM (samples.bakehouse.raw_prospects)
