from pyspark import pipelines as dp

# Create a SDP Streaming Table in Python for contacts
@dp.table()
@dp.expect_or_drop("ContactId needs to be set", "ContactId IS NOT NULL")
@dp.expect_or_drop("ProspectId needs to be set", "ProspectId IS NOT NULL")
def raw_contacts():
    return spark.readStream.table("samples.bakehouse.raw_contacts")
