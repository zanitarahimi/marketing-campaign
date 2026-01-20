-- Create a SDP Streaming Table for campaign events with data quality

CREATE STREAMING TABLE raw_events
( 
  CONSTRAINT valid_event_type EXPECT (EventType IN ('sent', 'opened', 'clicked', 'bounced', 'unsubscribed'))
)
TBLPROPERTIES ("quality" = "bronze")
COMMENT "Streaming table for campaign events (sent, opened, clicked, etc.)"
AS SELECT
  *
FROM STREAM (samples.bakehouse.raw_events)
