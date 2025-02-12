# Module 3 Homework

## Question 1

**What is count of records for the 2024 Yellow Taxi Data?**
After uploading data into BigQuery and create an external table, Run SQL:

```
select count(*) from nytaxi.external_yellow_tripdata
```

The answer is

```
20332093
```

## Question 2

**Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.</br>
What is the **estimated amount** of data that will be read when this query is executed on the External Table and the Table?**
Create a materialized table for yellow_tripdata"

```sql
CREATE OR REPLACE TABLE `nytaxi.yellow_tripdata_non_partitoned` AS (
  select * from nytaxi.external_yellow_tripdata
);
```

Run SQL to count the distinct number of PULocationIDs:

```sql
select count(distinct PULocationID) from nytaxi.external_yellow_tripdata;
select count(distinct PULocationID) from nytaxi.yellow_tripdata_non_partitoned;
```

The answer is:

```
0 MB for the External Table and 155.12 MB for the Materialized Table
```

## Question 3

**Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?**

The estimated number of Bytes of querying two columns (PULocationID, DOLocationID) are about twice as many as querying one column (PULocationID).

Beacuse BigQuery is a columnar database, and it only scans the specific columns requested in the query.

The answer is:

```
BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires
reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.
```

## Question 4

**How many records have a fare_amount of 0?**
Run SQL:

```sql
select count(*) from nytaxi.yellow_tripdata_non_partitoned
where fare_amount=0;
```

The answer is:

```
8333
```

## Question 5

**What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)**
Partitiion this table by date of tpep_dropoff_datetime is a good choice and clustering the table by VendorID can accelerate the query of ordering the results by VendorID.
Create a partitioned and clustered table:

```sql
CREATE OR REPLACE TABLE nytaxi.yellow_tripdata_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM nytaxi.external_yellow_tripdata;
```

The answer is:

```
Partition by tpep_dropoff_datetime and Cluster on VendorID
```

## Question 6

**Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime
2024-03-01 and 2024-03-15 (inclusive)</br>**

**Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? </br>**

**Choose the answer which most closely matches.</br>**

Run the SQL:

```sql
select distinct VendorID from nytaxi.yellow_tripdata_non_partitoned
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15';

select distinct VendorID from nytaxi.yellow_tripdata_partitioned_clustered
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15';
```

The answer is:

```
310.24 MB for non-partitioned table and 26.84 MB for the partitioned table
```

## Question 7

**Where is the data stored in the External Table you created?**
The data stored in the External Table still in `GCP bucket`.

## Question 8

**It is best practice in Big Query to always cluster your data:**
The answer is:

```
False
```

**When Clustering is Beneficial:**

- Queries with Filters: Clustering is most effective when your queries frequently filter data on the clustering columns. BigQuery can then efficiently prune partitions and blocks of data that don't match the filter criteria, drastically reducing the amount of data scanned.
- Large Tables: Clustering is generally more beneficial for larger tables. The overhead of clustering is less significant compared to the performance gains.
- Data with High Cardinality Clustering Columns: Clustering on columns with high cardinality (many distinct values) is often more effective. This allows for more granular pruning.
- Common Query Patterns: If you have predictable query patterns (e.g., always filtering by date and then customer ID), clustering on those columns can be very advantageous.

**When Clustering Might Not Be Beneficial or Even Harmful:**

- Small Tables: For very small tables, the overhead of clustering might outweigh the benefits. BigQuery can often scan small tables quickly even without clustering.
- Tables with Low Cardinality Clustering Columns: Clustering on columns with low cardinality (few distinct values) might not provide much benefit, as there will be less granular pruning.
- Queries that Scan the Entire Table: If your queries frequently scan the entire table without filtering on the clustering columns, clustering won't provide any performance improvement and might even add a small overhead.
- Append-Only Workloads: While clustering can still be helpful with append-only workloads, the benefits might not be as pronounced if you're primarily adding new data and not frequently querying existing data with filters. Consider using ingestion-time partitioning in such scenarios.
- Data that Changes Frequently: If your data changes very frequently, the cost of maintaining the clustered structure (re-clustering) might become significant. Clustering is best suited for data that is relatively static or where changes are less frequent.
- Over-Clustering: Clustering on too many columns can sometimes be less efficient than clustering on a well-chosen subset of columns. It's important to select clustering columns that are frequently used in filters.

## Question 9

**Write a SELECT count(\*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?**

```sql
select count(*) from nytaxi.yellow_tripdata_non_partitoned
```

Zero byte. Beacause the count is already in the metadata, BigQuery doesn't need to scan any of the actual data within the table to answer the COUNT(\*) query. It simply retrieves the pre-calculated count from the metadata.
