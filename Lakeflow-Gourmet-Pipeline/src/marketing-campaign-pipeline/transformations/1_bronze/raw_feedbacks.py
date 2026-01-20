from pyspark import pipelines as dp

# Create a SDP Streaming Table in Python for customer feedback
@dp.table()
@dp.expect_or_drop("CampaignId needs to be set", "CampaignId IS NOT NULL")
def raw_feedbacks():
    return spark.readStream.table("zanita_rahimi.dbdemos_aibi_cme_marketing_campaign.raw_feedbacks")
