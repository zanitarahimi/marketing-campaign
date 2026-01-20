-- Create a SDP Materialized View for campaign performance analytics

CREATE MATERIALIZED VIEW campaign_performance
(
  CONSTRAINT campaign_id_set EXPECT (c.CampaignId IS NOT NULL) ON VIOLATION FAIL UPDATE,
  CONSTRAINT valid_industry EXPECT (p.Industry IS NOT NULL)
)

COMMENT "Campaign performance metrics by industry and country"
AS 
WITH event_metrics AS (
  SELECT
    CampaignId,
    COUNT(CASE WHEN EventType = 'sent' THEN 1 END) AS emails_sent,
    COUNT(CASE WHEN EventType = 'delivered' THEN 1 END) AS emails_delivered,
    COUNT(CASE WHEN EventType = 'html_open' THEN 1 END) AS emails_opened,
    COUNT(CASE WHEN EventType = 'click' THEN 1 END) AS clicks,
    COUNT(CASE WHEN EventType = 'spam' THEN 1 END) AS spam_reports,
    COUNT(CASE WHEN EventType IN ('optout_click', 'optput_click') THEN 1 END) AS unsubscribes,
    MAX(DATE(EventDate)) AS latest_event_date
  FROM raw_events
  GROUP BY CampaignId
)
SELECT
  c.CampaignId,
  c.CampaignName,
  c.CampaignDescription,
  c.SubjectLine,
  c.Template,
  c.Cost,
  c.StartDate,
  c.EndDate,
  p.Industry,
  p.Country,
  p.City,
  p.AnnualRevenue,
  p.Employees,
  em.emails_sent,
  em.emails_delivered,
  em.emails_opened,
  em.clicks,
  em.spam_reports,
  em.unsubscribes,
  -- Calculate engagement rates
  ROUND(em.emails_opened * 100.0 / NULLIF(em.emails_sent, 0), 2) AS open_rate,
  ROUND(em.clicks * 100.0 / NULLIF(em.emails_sent, 0), 2) AS click_rate,
  ROUND(em.emails_delivered * 100.0 / NULLIF(em.emails_sent, 0), 2) AS delivery_rate,
  ROUND(em.spam_reports * 100.0 / NULLIF(em.emails_sent, 0), 2) AS spam_rate,
  -- Calculate ROI metrics
  ROUND(em.clicks / NULLIF(c.Cost, 0), 2) AS clicks_per_dollar,
  -- Calculate engagement score (weighted metric)
  ROUND(
    (ROUND(em.emails_opened * 100.0 / NULLIF(em.emails_sent, 0), 2) * 0.3) + 
    (ROUND(em.clicks * 100.0 / NULLIF(em.emails_sent, 0), 2) * 0.5) + 
    (ROUND(em.clicks / NULLIF(c.Cost, 0), 2) * 0.2), 
    2
  ) AS engagement_score,
  em.latest_event_date
FROM
  raw_campaigns c
  JOIN event_metrics em ON c.CampaignId = em.CampaignId
  JOIN raw_contacts ct ON c.MailingList = ct.ContactId
  JOIN raw_prospects p ON ct.ProspectId = p.ProspectId
WHERE
  em.latest_event_date = (SELECT MAX(DATE(EventDate)) FROM raw_events)
