![Marketing Campaign Pipeline](misc/marketing_campaign_pipeline.png)



# Marketing Campaign Pipeline: End-to-End Marketing Analytics with Lakeflow, AI, Databricks One and Databricks Asset Bundle

Marketing teams struggle with fragmented campaign data spread across multiple systems, making it impossible to understand what drives engagement. Without unified visibility into campaign performance across industries and geographies, marketing leaders can't optimize spend, personalize messaging, or prove ROI. The challenge is compounded by the need to create localized, industry-specific content at scale.

The new Lakeflow Marketing Campaign Pipeline solves these challenges! It provides an automated, end-to-end analytics platform that ingests campaign data, events, customer interactions, and prospect information with Lakeflow Connect, transforms them for analysis with Lakeflow Spark Declarative Pipelines, enriches campaign copy using LLMs and AI functions, and visualizes results on a real-time dashboard.


This project demonstrates a complete data engineering workflow using Databricks Asset Bundles. It covers everything from initial data ingestion to the final business intelligence dashboard served via Databricks One, providing a practical example of CI/CD and infrastructure-as-code for the Databricks Data Intelligence Platform.



### Running the Project from the Databricks Workspace

The asset bundle is designed to be deployed and run entirely from the Databricks UI, simplifying development and collaboration.

1.  **Clone the Git Repository into your Workspace**:
    *   Navigate to **Workspace** in the sidebar.
    *   Click the **Create** button and select **Git folder**.
    *   In the "Create Git folder" dialog, paste the URL.
    *   Select your Git provider (e.g., GitHub).
    *   Click **Create Git folder**. The repository will be cloned into your workspace.


2.   **Verify/Update the configuration** 

      * Before deploying, you need to make sure you have the proper settings defined in the `databricks.yml` file.
         * `catalog_name` and `schema_name` defines the location where the pipeline tables will be created. 
         * the ID of the Databricks SQL Warehouse (`prod_warehouse_id`) that will power the dashboard
         * Update the SQL for the dashboard to match the correct catalog and schema in `src/aibi_dashboard.json`. AI/BI dashboards cannot be parametrized currently, so you have to edit this manually. 

3.  **Deploy the Asset Bundle**:
    *   Navigate to the newly cloned folder in your Workspace.
    *   The `databricks.yml` file identifies this folder as an Asset Bundle. Click the **Deployments** icon (a rocket ship) in the left-hand pane.
    *   In the Deployments pane, select your target workspace (e.g., `presenter`).
    *   Click the **Deploy** button. Databricks will validate and deploy the resources defined in the bundle, such as jobs and pipelines.

3.  **Run the Workflow**:
    *   After a successful deployment, the "Bundle resources" section will populate with the assets created by the bundle.
    *   Under "Jobs," locate the `marketing-campaign-workflow` job.
    *   Click the **Run** (play) icon next to the job to trigger the workflow.
    *   You can monitor the job's progress in the **Job Runs** UI.


### Workflow Tasks

The core of this project is a multi-task workflow that ingests campaign, event, contact, prospect, feedback, and issue data via Lakeflow Connect, transforms it with Spark Declarative Pipelines to calculate engagement metrics, enriches it through LLM-based content generation with multi-language translation and sentiment analysis, and finally updates AI/BI dashboards and downstream systems.


## Data Architecture

### Bronze Layer (Raw Data Ingestion)
- **raw_campaigns**: Marketing campaign metadata (name, subject line, cost, dates)
- **raw_events**: Campaign events (sent, opened, clicked, bounced, unsubscribed)
- **raw_contacts**: Contact/lead information with device and opt-out status
- **raw_prospects**: Company/prospect data (industry, revenue, location, employees)
- **raw_feedbacks**: Customer feedback on campaigns
- **raw_issues**: Compliance issues and complaints (CAN-SPAM Act violations)

### Silver Layer (Business Logic)
- **campaign_performance**: Joined view of campaigns with calculated engagement metrics
  - Open rates, click rates, bounce rates
  - Clicks per dollar (ROI metric)
  - Aggregated by industry, country, and city

### Gold Layer (Analytics-Ready)
- **top_campaigns**: Top 10 performing campaigns ranked by engagement score
  - Weighted scoring: 30% open rate + 50% click rate + 20% cost efficiency
  - Filtered to exclude test campaigns (min 100 emails sent)

### AI Enrichment Layer
- **gen_personalized_campaign_copy()**: LLM function that generates industry and geography-specific B2B marketing copy
- **top_campaigns_with_ai**: Final table with AI-generated personalized campaign descriptions
- **Multi-language translations**: Spanish, German, French
- **Sentiment analysis**: Analyzes tone of AI-generated content


## Usage

- Run the workflow first
- Explore the dashboard showing real-time campaign performance with AI-generated localized marketing copy
- Explore the workflow that orchestrates all tasks without manual intervention
- Explore SDP for data transformation with the new Lakeflow pipeline editor
- Use the asset bundle to delete and deploy again


## Key Features Demonstrated

✅ **Lakeflow Connect**: Ingesting data from multiple sources (campaigns, events, prospects)  
✅ **Spark Declarative Pipelines (SDP)**: Mix of SQL and Python transformations  
✅ **Data Quality**: Built-in constraints and expectations at each layer  
✅ **Medallion Architecture**: Bronze → Silver → Gold data layers  
✅ **AI/ML Integration**: Claude 3.7 Sonnet for content generation  
✅ **AI Functions**: Translation and sentiment analysis  
✅ **Serverless Compute**: All pipelines run serverless  
✅ **DABs (Databricks Asset Bundles)**: Complete IaC deployment  
✅ **Conditional Workflows**: AI-enabled/disabled branching logic  
✅ **AI/BI Dashboard**: Real-time visualization with Databricks One  


## Requirements

- To run this you need a Databricks account. This demo does not run on the Databricks Free Edition.


## Troubleshooting

- Make sure you have the right parameters set in ```databricks.yml``` in particular DWH ID, catalog and schema name.
- If you deploy to a different catalog/schema you need to adjust the SQL in the dashboard yml file for catalog and schema since this cannot be parametrized yet. 
- Note: To keep the demo as flexible as possible and remove the requirement to have actual external connections, we use endpoint stubs for the data providers.


---
[Built with ❤️ using Databricks Lakeflow and Asset Bundles](https://www.databricks.com)
