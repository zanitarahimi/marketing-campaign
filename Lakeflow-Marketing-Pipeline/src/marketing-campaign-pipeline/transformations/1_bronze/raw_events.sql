-- Create a SDP Streaming Table for campaign events with data quality

CREATE STREAMING TABLE raw_events
( 
  CONSTRAINT valid_event_type EXPECT (EventType IN ('sent', 'delivered', 'html_open', 'click', 'spam', 'optout_click', 'optput_click') OR EventType IS NULL)
)
TBLPROPERTIES ("quality" = "bronze")
COMMENT "Streaming table for campaign events (sent, delivered, html_open, click, spam, optout_click)"
AS SELECT
  *
FROM STREAM (zanita_rahimi.dbdemos_aibi_cme_marketing_campaign.raw_events)
