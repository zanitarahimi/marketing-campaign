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
  cp.emails_opened,
  cp.clicks,
  cp.open_rate,
  cp.click_rate,
  cp.clicks_per_dollar,
  -- Calculate engagement score (weighted metric)
  ROUND(
    (cp.open_rate * 0.3) + 
    (cp.click_rate * 0.5) + 
    (cp.clicks_per_dollar * 0.2), 
    2
  ) AS engagement_score
FROM campaign_performance cp
WHERE 
  cp.Industry IS NOT NULL
  AND cp.Country IS NOT NULL
  AND cp.emails_sent > 100  -- Filter out test campaigns
ORDER BY 
  engagement_score DESC,
  cp.clicks_per_dollar DESC
LIMIT 10;
