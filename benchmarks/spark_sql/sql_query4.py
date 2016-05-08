import sys
from pyspark.sql import SQLContext
from pyspark import SparkContext

#QUERY_4_HQL = """DROP TABLE IF EXISTS url_counts_partial;
#                 CREATE TABLE url_counts_partial AS
#                   SELECT TRANSFORM (line)
#                   USING "python /nscratch/joao/bigdata_benchmark/runner/udf/url_count.py" as (sourcePage,
#                   destPage, count) from documents;
#                 DROP TABLE IF EXISTS url_counts_total;
#                 CREATE TABLE url_counts_total AS
#                   SELECT SUM(count) AS totalCount, destpage
#                   FROM url_counts_partial GROUP BY destpage;"""
#QUERY_4_HQL = """CREATE TABLE url_counts_partial AS
#                   SELECT TRANSFORM (line)
#                   USING "python /nscratch/joao/bigdata_benchmark/runner/udf/url_count.py" as (sourcePage,
#                   destPage, count) from documents;
#                 CREATE TABLE url_counts_total AS
#                   SELECT SUM(count) AS totalCount, destpage
#                   FROM url_counts_partial GROUP BY destpage;"""
QUERY_4_HQL = """ SELECT TRANSFORM (line) USING 'python /nscratch/joao/old/bigdata_benchmark/runner/udf/url_count.py' as (sourcePage,
                   destPage, count) from documents;"""
QUERY_4_HQL = " ".join(QUERY_4_HQL.replace("\n", "").split())

sc = SparkContext(appName="Query4")
sqlContext = SQLContext(sc)

#lines = sc.textFile("/nscratch/joao/rankings.txt")
#parts = lines.map(lambda l: l.split(","))
#rankings = parts.map(lambda p: {"pageURL": p[0], "pageRank": int(p[1]), "avgDuration":int(p[2])})
#schemaRanking = sqlContext.inferSchema(rankings)
#schemaRanking.registerAsTable("rankings")
#
#lines = sc.textFile("/nscratch/joao/uservisits.txt")
#parts = lines.map(lambda l: l.split(","))
#uservisits = parts.map(lambda p: {
#        "sourceIP": p[0], 
#        "destURL": p[1], 
#        "visitDate":p[2],
#        "adRevenue" : float(p[3]),
#        "userAgent": p[4],
#        "countryCode":p[5],
#        "languageCode":p[6],
#        "searchWord":p[7],
#        "duration":int(p[8])})
#
# Infer the schema, and register the SchemaRDD as a table.
# In future versions of PySpark we would like to add support for registering RDDs with other
# datatypes as tables
#schemaRanking = sqlContext.inferSchema(uservisits)
#schemaRanking.registerAsTable("uservisits")

urls = sqlContext.sql(QUERY_4_HQL)

#print "Collecting"
#urls.collect()
#for url in urls.collect():
#    print url

