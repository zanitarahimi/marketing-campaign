# 🚀 Quick Start: Marketing Campaign Pipeline

## What Changed?

This pipeline has been transformed from a **food supply chain analytics system** into a **B2B marketing campaign performance platform** while keeping all Databricks capabilities intact!

---

## 📊 Your Data Pipeline

### Input: 6 Marketing Tables

```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ raw_campaigns   │  │ raw_events      │  │ raw_contacts    │
│                 │  │                 │  │                 │
│ • CampaignId    │  │ • EventId       │  │ • ContactId     │
│ • Name          │  │ • CampaignId    │  │ • ProspectId    │
│ • SubjectLine   │  │ • ContactId     │  │ • Department    │
│ • Cost          │  │ • EventType     │  │ • JobTitle      │
│ • Dates         │  │ • EventDate     │  │ • Device        │
└─────────────────┘  └─────────────────┘  └─────────────────┘

┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ raw_prospects   │  │ raw_feedbacks   │  │ raw_issues      │
│                 │  │                 │  │                 │
│ • ProspectId    │  │ • CampaignId    │  │ • CampaignId    │
│ • Company       │  │ • Feedback      │  │ • ComplaintType │
│ • Industry      │  │ • ContactId     │  │ • ContactId     │
│ • Country/City  │  │                 │  │                 │
│ • Revenue       │  │                 │  │                 │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

### Output: AI-Powered Campaign Insights

```
┌──────────────────────────────────────────────────────────┐
│        top_campaigns_with_ai (Final Gold Table)          │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  Campaign Performance Metrics:                          │
│  ├─ Engagement Score (0-100)                            │
│  ├─ Open Rate, Click Rate, Bounce Rate                  │
│  ├─ Clicks per Dollar (ROI)                             │
│  └─ Industry & Geography Breakdown                      │
│                                                          │
│  AI-Generated Content:                                  │
│  ├─ Personalized B2B Marketing Copy                     │
│  ├─ Translated (Spanish, German, French)                │
│  └─ Sentiment Analysis                                  │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

## 🎯 What the AI Does

The pipeline uses **Claude 3.7 Sonnet** to generate personalized marketing copy:

**Example Input:**
- Industry: "Biotechnology"
- Location: "Amsterdam, Netherlands"
- Subject Line: "Unlock the Potential of Data with DBRX"
- Engagement Score: 85.5

**Example AI Output:**
> "In Amsterdam's thriving biotech sector, Databricks provides the data intelligence platform that accelerates drug discovery and clinical trial analysis while navigating GDPR compliance requirements. Life sciences leaders and data scientists in this innovation hub benefit from unified genomics data processing, real-time collaboration across research teams, and AI-powered insights that reduce time-to-market for breakthrough treatments. Join the Netherlands' top biotech firms leveraging Databricks to transform healthcare outcomes—schedule an exclusive demo with our European life sciences team."

Then automatically:
- ✅ Translates to Spanish, German, French
- ✅ Analyzes sentiment (positive/negative/neutral)
- ✅ Stores in final dashboard table

---

## 📋 Before You Deploy

### 1. Update Data Sources
Currently pointing to sample data. Update these files to use your actual tables:

**Bronze Layer** (`src/marketing-campaign-pipeline/transformations/1_bronze/`)
```sql
-- Change FROM STREAM(samples.bakehouse.raw_campaigns)
-- To your actual source:
FROM STREAM(your_catalog.your_schema.campaigns)
```

Do this for all 6 bronze tables:
- ✏️ `raw_campaigns.sql`
- ✏️ `raw_events.sql`
- ✏️ `raw_contacts.py`
- ✏️ `raw_prospects.sql`
- ✏️ `raw_feedbacks.py`
- ✏️ `raw_issues.sql`

### 2. Update Configuration
Edit `databricks.yml`:
```yaml
variables:
  prod_warehouse_id:
    default: YOUR_WAREHOUSE_ID  # Get from SQL Warehouse settings
  catalog_name:
    default: YOUR_CATALOG_NAME
```

### 3. Update Dashboard (Manual Step)
Edit `src/aibi_dashboard.json` and replace catalog/schema references:
```json
"SELECT * FROM marketing_campaigns.your_schema.top_campaigns_with_ai"
```

---

## 🚀 Deploy & Run

### Option 1: UI Deployment (Recommended)
1. Open your Databricks Workspace
2. Navigate to this folder
3. Click the **🚀 Deploy** icon in the left sidebar
4. Select target: `presenter`
5. Click **Deploy**
6. Once deployed, click **Run** on `marketing-campaign-workflow`

### Option 2: CLI Deployment
```bash
cd /path/to/Lakeflow-Gourmet-Pipeline
databricks bundle deploy -t presenter
databricks bundle run marketing-campaign-workflow -t presenter
```

---

## 🔍 Monitor Your Pipeline

After running the workflow, check:

1. **Job Runs** → `marketing-campaign-workflow`
   - ✅ 3 Lakeflow Connect pipelines complete
   - ✅ Main ETL pipeline creates bronze/silver/gold tables
   - ✅ AI enrichment generates personalized copy
   - ✅ Dashboard updates with latest data

2. **Data Explorer** → Your Catalog → Your Schema
   - `raw_campaigns`, `raw_events`, `raw_contacts`, `raw_prospects`, `raw_feedbacks`, `raw_issues`
   - `campaign_performance`
   - `top_campaigns`
   - `top_campaigns_with_ai` ← **Final table with AI content**

3. **Dashboards** → "Marketing Campaign Analytics"
   - View top performing campaigns
   - See AI-generated personalized copy
   - Compare engagement across industries/geographies

---

## 🎨 Customization Ideas

### Adjust Engagement Scoring
Edit `src/marketing-campaign-pipeline/transformations/3_gold/top_campaigns.sql`:
```sql
-- Current weights: 30% open rate, 50% click rate, 20% cost efficiency
-- Change to prioritize opens over clicks:
(cp.open_rate * 0.5) +    -- 50% weight
(cp.click_rate * 0.3) +    -- 30% weight
(cp.clicks_per_dollar * 0.2) -- 20% weight
```

### Customize AI Prompts
Edit `src/ai_query.sql` to match your brand voice:
```sql
'Create a B2B marketing campaign description...'
-- Change tone, style, length, or focus
```

### Add More Translations
Edit `src/sentiment_translate.sql`:
```sql
ai_translate(ai_generated_copy, 'ja') AS ai_copy_japanese,
ai_translate(ai_generated_copy, 'zh') AS ai_copy_chinese,
```

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Table not found" errors | Update sample data references to your actual tables |
| Dashboard shows no data | Manually edit `aibi_dashboard.json` with correct catalog/schema |
| AI functions fail | Ensure you have access to Foundation Model APIs in your workspace |
| Pipeline fails on constraints | Review data quality issues in bronze layer tables |

---

## 📚 Learn More

- **Lakeflow Connect**: [Documentation](https://docs.databricks.com/en/connect/index.html)
- **Spark Declarative Pipelines**: [Documentation](https://docs.databricks.com/en/delta-live-tables/index.html)
- **Databricks Asset Bundles**: [Documentation](https://docs.databricks.com/en/dev-tools/bundles/index.html)
- **AI Functions**: [Documentation](https://docs.databricks.com/en/large-language-models/ai-functions.html)

---

**You're all set! Deploy and watch your marketing campaigns get AI-powered insights! 🎉**
