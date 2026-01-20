-- Create a SDP Streaming Table for campaign issues/complaints

CREATE STREAMING TABLE raw_issues
( 
  CONSTRAINT campaign_id_required EXPECT (CampaignId IS NOT NULL)
)
TBLPROPERTIES ("quality" = "bronze")
COMMENT "Streaming table for campaign issues and compliance complaints"
AS SELECT
  *
FROM STREAM (zanita_rahimi.dbdemos_aibi_cme_marketing_campaign.raw_issues)
