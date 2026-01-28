-- SDP gold table: Top performing campaigns by industry and country

CREATE OR REFRESH MATERIALIZED VIEW top_campaigns
AS
SELECT 
  cp.CampaignId,
  cp.CampaignName,
  cp.SubjectLine,
  cp.Industry,
  cp.Country,
  cp.City,
  cp.Cost,
  cp.emails_sent,
  cp.emails_delivered,
  cp.emails_opened,
  cp.clicks,
  cp.spam_reports,
  cp.unsubscribes,
  cp.open_rate,
  cp.click_rate,
  cp.delivery_rate,
  cp.spam_rate,
  cp.clicks_per_dollar,
  cp.engagement_score
FROM campaign_performance cp
WHERE 
  cp.Industry IS NOT NULL
  AND cp.Country IS NOT NULL
ORDER BY 
  engagement_score DESC,
  cp.clicks_per_dollar DESC
LIMIT 10;
