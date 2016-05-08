import sys,os

assert len(sys.argv) == 2

from pyspark import SparkContext
sc = SparkContext(appName="BDB")

# sc is an existing SparkContext.
from pyspark.sql import SQLContext
sqlContext = SQLContext(sc)

# Load a text file and convert each line to a dictionary.
lines = sc.textFile("../../../../bdb/rankings/rankings.txt")

parts = lines.map(lambda l: l.split(","))
rankings = parts.map(lambda p: {"pageURL": p[0], "pageRank": int(p[1]), "avgDuration":int(p[2])})

schemaRanking = sqlContext.inferSchema(rankings)
schemaRanking.registerAsTable("rankings")

print "Running query: ", sys.argv[1]
num_query = int(sys.argv[1])

print "Num_query: " + str(num_query) + "\n"

if num_query == 1:
    urls = sqlContext.sql("SELECT pageURL, pageRank FROM rankings WHERE pageRank > 10")
elif num_query == 2:
    urls = sqlContext.sql("SELECT pageURL, pageRank FROM rankings WHERE pageRank > 100")
elif num_query == 3:
    urls = sqlContext.sql("SELECT pageURL, pageRank FROM rankings WHERE pageRank > 1000")
elif num_query == 4:
    urls = sqlContext.sql("SELECT pageURL, pageRank FROM rankings WHERE pageRank > 1000")
else: assert 0

#for url in urls.collect():
#    print url
urls.collect()
