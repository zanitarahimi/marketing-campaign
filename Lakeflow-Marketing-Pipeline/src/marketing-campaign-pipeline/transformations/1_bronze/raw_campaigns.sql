-- Create a SDP Streaming Table in SQL for campaigns

CREATE STREAMING TABLE raw_campaigns
TBLPROPERTIES ("quality" = "bronze")
COMMENT "Streaming table for marketing campaign data"
AS SELECT
  *
FROM STREAM(zanita_rahimi.dbdemos_aibi_cme_marketing_campaign.raw_campaigns)
