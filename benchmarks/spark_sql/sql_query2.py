import sys

assert len(sys.argv) == 2

from pyspark import SparkContext
sc = SparkContext(appName="Query2")

# sc is an existing SparkContext.
from pyspark.sql import SQLContext
sqlContext = SQLContext(sc)

# Load a text file and convert each line to a dictionary.
lines = sc.textFile("../../../../bdb/uservisits/uservisits.txt")
parts = lines.map(lambda l: l.split(","))
uservisits = parts.map(lambda p: {
        "sourceIP": p[0], 
        "destURL": p[1], 
        "visitDate":p[2],
        "adRevenue" : float(p[3]),
        "userAgent": p[4],
        "countryCode":p[5],
        "languageCode":p[6],
        "searchWord":p[7],
        "duration":int(p[8])})

schemaRanking = sqlContext.inferSchema(uservisits)
schemaRanking.registerAsTable("uservisits")

num_query = int(sys.argv[1])

print "Running query ", num_query

if num_query == 1:
    urls = sqlContext.sql("SELECT SUBSTR(sourceIP, 1, 8), SUM(adRevenue) FROM uservisits GROUP BY SUBSTR(sourceIP, 1, 8)")
elif num_query == 2:
    urls = sqlContext.sql("SELECT SUBSTR(sourceIP, 1, 10), SUM(adRevenue) FROM uservisits GROUP BY SUBSTR(sourceIP, 1, 10)")
elif num_query == 3:
    urls = sqlContext.sql("SELECT SUBSTR(sourceIP, 1, 12), SUM(adRevenue) FROM uservisits GROUP BY SUBSTR(sourceIP, 1, 12)")
else: assert 0

print "Collecting"
urls.collect()
#for url in urls.collect():
#    print url

