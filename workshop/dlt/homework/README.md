# Workshop dlt

## Question 1

Intall dlt on Google Colab, print the version of dlt.
The answer is:

```
1.6.1
```

## Question 2

Complete code for the customized dlt source.

```py
import dlt
from dlt.sources.helpers.rest_client import RESTClient
from dlt.sources.helpers.rest_client.paginators import PageNumberPaginator


# your code is here
@dlt.resource(name="rides")   # <--- The name of the resource (will be used as the table name)
def ny_taxi():
    client = RESTClient(
        base_url="https://us-central1-dlthub-analytics.cloudfunctions.net",
        paginator=PageNumberPaginator(
            base_page=1,
            total_path=None
        )
    )

    for page in client.paginate("data_engineering_zoomcamp_api"):    # <--- API endpoint for retrieving taxi ride data
        yield page   # <--- yield data to manage memory

pipeline = dlt.pipeline(
    pipeline_name="ny_taxi_pipeline",
    destination="duckdb",
    dataset_name="ny_taxi_data"
)
```

Load the data into DuckDB to test:

```py
load_info = pipeline.run(ny_taxi)
print(load_info)
```

After loading data into duckdb, connect to the database to get the number of tables:

```py
import duckdb
from google.colab import data_table
data_table.enable_dataframe_formatter()

# A database '<pipeline_name>.duckdb' was created in working directory so just connect to it

# Connect to the DuckDB database
conn = duckdb.connect(f"{pipeline.pipeline_name}.duckdb")

# Set search path to the dataset
conn.sql(f"SET search_path = '{pipeline.dataset_name}'")

# Describe the dataset
conn.sql("DESCRIBE").df()

```

There a **4** tables: `_dlt_loads`, `_dlt_pipeline_state`, `_dlt_version` and `rides`.

## Question 3:

Run the code:

```py
df = pipeline.dataset(dataset_type="default").rides.df()
df
```

The answer is:

```
10000
```

## Question 4

Run the code:

```py
with pipeline.sql_client() as client:
    res = client.execute_sql(
            """
            SELECT
            AVG(date_diff('minute', trip_pickup_date_time, trip_dropoff_date_time))
            FROM rides;
            """
        )
    # Prints column values of the first row
    print(res)
```

The answer is:

```
12.3049
```
