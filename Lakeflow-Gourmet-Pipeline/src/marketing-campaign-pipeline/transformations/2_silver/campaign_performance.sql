-- Create a SDP Materialized View for campaign performance analytics

CREATE MATERIALIZED VIEW campaign_performance
(
  CONSTRAINT campaign_id_set EXPECT (CampaignId IS NOT NULL) ON VIOLATION FAIL UPDATE,
  CONSTRAINT valid_industry EXPECT (Industry IS NOT NULL)
)

COMMENT "Campaign performance metrics by industry and country, aggregated across all prospects per campaign"
AS 
WITH event_metrics AS (
  SELECT
    e.CampaignId,
    e.ContactId,
    COUNT(CASE WHEN e.EventType = 'sent' THEN 1 END) AS emails_sent,
    COUNT(CASE WHEN e.EventType = 'delivered' THEN 1 END) AS emails_delivered,
    COUNT(CASE WHEN e.EventType = 'html_open' THEN 1 END) AS emails_opened,
    COUNT(CASE WHEN e.EventType = 'click' THEN 1 END) AS clicks,
    COUNT(CASE WHEN e.EventType = 'spam' THEN 1 END) AS spam_reports,
    COUNT(CASE WHEN e.EventType IN ('optout_click', 'optput_click') THEN 1 END) AS unsubscribes,
    MAX(DATE(e.EventDate)) AS latest_event_date
  FROM raw_events e
  GROUP BY e.CampaignId, e.ContactId
),
campaign_by_industry_country AS (
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
    AVG(p.AnnualRevenue) AS avg_annual_revenue,
    AVG(p.Employees) AS avg_employees,
    SUM(em.emails_sent) AS emails_sent,
    SUM(em.emails_delivered) AS emails_delivered,
    SUM(em.emails_opened) AS emails_opened,
    SUM(em.clicks) AS clicks,
    SUM(em.spam_reports) AS spam_reports,
    SUM(em.unsubscribes) AS unsubscribes,
    MAX(em.latest_event_date) AS latest_event_date
  FROM
    raw_campaigns c
    JOIN event_metrics em ON c.CampaignId = em.CampaignId
    JOIN raw_contacts ct ON em.ContactId = ct.ContactId
    JOIN raw_prospects p ON ct.ProspectId = p.ProspectId
  WHERE
    p.Industry IS NOT NULL 
    AND p.Country IS NOT NULL
  GROUP BY 
    c.CampaignId, c.CampaignName, c.CampaignDescription, 
    c.SubjectLine, c.Template, c.Cost, c.StartDate, c.EndDate,
    p.Industry, p.Country, p.City
)
SELECT
  CampaignId,
  CampaignName,
  CampaignDescription,
  SubjectLine,
  Template,
  Cost,
  StartDate,
  EndDate,
  Industry,
  Country,
  City,
  avg_annual_revenue AS AnnualRevenue,
  avg_employees AS Employees,
  emails_sent,
  emails_delivered,
  emails_opened,
  clicks,
  spam_reports,
  unsubscribes,
  -- Calculate engagement rates
  ROUND(emails_opened * 100.0 / NULLIF(emails_sent, 0), 2) AS open_rate,
  ROUND(clicks * 100.0 / NULLIF(emails_sent, 0), 2) AS click_rate,
  ROUND(emails_delivered * 100.0 / NULLIF(emails_sent, 0), 2) AS delivery_rate,
  ROUND(spam_reports * 100.0 / NULLIF(emails_sent, 0), 2) AS spam_rate,
  -- Calculate ROI metrics
  ROUND(clicks / NULLIF(Cost, 0), 2) AS clicks_per_dollar,
  -- Calculate engagement score (weighted metric)
  ROUND(
    (ROUND(emails_opened * 100.0 / NULLIF(emails_sent, 0), 2) * 0.3) + 
    (ROUND(clicks * 100.0 / NULLIF(emails_sent, 0), 2) * 0.5) + 
    (ROUND(clicks / NULLIF(Cost, 0), 2) * 0.2), 
    2
  ) AS engagement_score,
  latest_event_date
FROM campaign_by_industry_country
