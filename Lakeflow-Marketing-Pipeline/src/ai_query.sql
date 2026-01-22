-- Use params from DAB
USE CATALOG {{my_catalog}};
USE IDENTIFIER({{my_schema}});

DROP FUNCTION IF EXISTS gen_personalized_campaign_copy;


-- FUNCTION: gen_personalized_campaign_copy
-- Description: Generates industry and geography-specific marketing campaign copy using AI

CREATE FUNCTION gen_personalized_campaign_copy(
    industry STRING COMMENT 'Industry sector like Biotechnology, Finance, Healthcare', 
    country STRING COMMENT 'Country code like US, NL, DE', 
    city STRING COMMENT 'City name like Amsterdam, New York, Berlin',
    subject_line STRING COMMENT 'Original email subject line',
    engagement_score DOUBLE COMMENT 'Campaign engagement score (0-100)'
) RETURNS STRING

COMMENT 
    'Generates personalized, localized marketing campaign copy for B2B tech marketing campaigns.

    Returns: 3-sentence campaign description formatted as:
    1. How Databricks addresses specific industry challenges and local market context
    2. Why decision-makers in this industry/location would benefit from this solution
    3. Call-to-action that resonates with local business culture and the engagement level

    Agent Usage: Call this function to create personalized B2B marketing content that resonates 
    with industry verticals and geographical markets while maintaining brand consistency.

    AI Model: Uses databricks-claude-3-7-sonnet for natural language generation.'

RETURN 
  ai_query(
    'databricks-claude-3-7-sonnet',
    'Create a B2B marketing campaign description for Databricks targeting the ' || industry || 
    ' industry in ' || city || ', ' || country || 
    '. The original subject line was: "' || subject_line || 
    '". The campaign has an engagement score of ' || CAST(engagement_score AS STRING) || 
    ' out of 100. Format: First sentence - Describe how Databricks and data intelligence addresses specific challenges in the ' || industry ||
    ' industry and connects to the local business environment in ' || city || '. ' ||
    'Second sentence - Explain why decision-makers and technical leaders in this industry and location would benefit from this solution, considering their specific business drivers and regulatory environment. ' ||
    'Third sentence - Create a compelling call-to-action that resonates with the local business culture and reflects the campaign engagement level (higher scores deserve more premium positioning). ' ||
    'Keep it professional, data-driven, and make sure each sentence flows naturally while highlighting the value proposition for this specific vertical and geography.'
    );

-- Create gold table for dashboard with AI-generated personalized campaign copy
DROP TABLE IF EXISTS top_campaigns_with_ai;

CREATE TABLE top_campaigns_with_ai AS 
SELECT 
    *,
    gen_personalized_campaign_copy(
        Industry, 
        Country, 
        City, 
        SubjectLine,
        engagement_score
    ) AS ai_generated_copy
FROM 
    top_campaigns;

-- You can test the function like this:
-- SELECT gen_personalized_campaign_copy('Biotechnology', 'NL', 'Amsterdam', 'Unlock the Potential of Data with DBRX', 85.5);
