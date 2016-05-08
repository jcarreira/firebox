import sys
from pyspark.sql import SQLContext
from pyspark import SparkContext


QUERY_3a_HQL = """SELECT sourceIP,
             sum(adRevenue) as totalRevenue,
             avg(pageRank) as pageRank
             FROM
             rankings R JOIN
             (SELECT sourceIP, destURL, adRevenue
              FROM uservisits UV
              WHERE UV.visitDate > "1980-01-01"
              AND UV.visitDate < "1980-04-01")
            NUV ON (R.pageURL = NUV.destURL)
            GROUP BY sourceIP
            ORDER BY totalRevenue DESC
            LIMIT 1"""
QUERY_3a_HQL = " ".join(QUERY_3a_HQL.replace("\n", "").split())
QUERY_3b_HQL = QUERY_3a_HQL.replace("1980-04-01", "1983-01-01")
QUERY_3c_HQL = QUERY_3a_HQL.replace("1980-04-01", "2010-01-01")

assert len(sys.argv) == 2

sc = SparkContext(appName="Query3")
sqlContext = SQLContext(sc)


#lines = sc.textFile("/nscratch/joao/rankings.txt")
lines = sc.textFile("/data/joao/rankings.txt")
parts = lines.map(lambda l: l.split(","))
rankings = parts.map(lambda p: {"pageURL": p[0], "pageRank": int(p[1]), "avgDuration":int(p[2])})
schemaRanking = sqlContext.inferSchema(rankings)
schemaRanking.registerAsTable("rankings")

lines = sc.textFile("/nscratch/joao/uservisits.txt")
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

# Infer the schema, and register the SchemaRDD as a table.
# In future versions of PySpark we would like to add support for registering RDDs with other
# datatypes as tables
schemaRanking = sqlContext.inferSchema(uservisits)
schemaRanking.registerAsTable("uservisits")

num_query = int(sys.argv[1])

print "Running query ", num_query

# SQL can be run over SchemaRDDs that have been registered as a table.
#urls = sqlContext.sql("SELECT pageURL FROM rankings WHERE pageRank > 1")
if num_query == 1:
    urls = sqlContext.sql(QUERY_3a_HQL)
elif num_query == 2:
    urls = sqlContext.sql(QUERY_3a_HQL)
elif num_query == 3:
    urls = sqlContext.sql(QUERY_3a_HQL)
else: assert 0

print "Collecting"
urls.collect()
#for url in urls.collect():
#    print url



