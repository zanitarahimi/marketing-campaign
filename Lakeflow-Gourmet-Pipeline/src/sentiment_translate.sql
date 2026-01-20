
USE CATALOG {{my_catalog}};
USE IDENTIFIER({{my_schema}});

-- Add sentiment analysis from customer feedback
CREATE OR REPLACE TABLE campaign_feedback_sentiment AS
SELECT
  CampaignId,
  COUNT(*) AS feedback_count,
  AVG(CASE 
    WHEN LOWER(ai_analyze_sentiment(Feedbacks)) LIKE '%positive%' THEN 1
    WHEN LOWER(ai_analyze_sentiment(Feedbacks)) LIKE '%negative%' THEN -1
    ELSE 0
  END) AS sentiment_score,
  COLLECT_LIST(STRUCT(Feedbacks, ai_analyze_sentiment(Feedbacks) AS sentiment)) AS feedback_details
FROM
  raw_feedbacks
WHERE
  Feedbacks IS NOT NULL
GROUP BY CampaignId;

-- Add translations and join with customer sentiment
CREATE OR REPLACE TABLE top_campaigns_with_ai AS
SELECT
  t.*,  -- Selects all original columns from the source table
  ai_translate(t.ai_generated_copy, 'es') AS ai_copy_es,
  ai_translate(t.ai_generated_copy, 'de') AS ai_copy_de,
  ai_translate(t.ai_generated_copy, 'fr') AS ai_copy_fr,
  COALESCE(f.sentiment_score, 0) AS customer_sentiment_score,
  COALESCE(f.feedback_count, 0) AS feedback_count,
  CASE 
    WHEN f.sentiment_score > 0.3 THEN 'Positive'
    WHEN f.sentiment_score < -0.3 THEN 'Negative'
    WHEN f.sentiment_score IS NULL THEN 'No Feedback'
    ELSE 'Neutral'
  END AS sentiment
FROM
  top_campaigns_with_ai t
LEFT JOIN
  campaign_feedback_sentiment f ON t.CampaignId = f.CampaignId;
