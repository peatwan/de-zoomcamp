# Module 2 Homework

## Question 1

**Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?**

Execute [this](./hw01.yaml) Kestra flow. Check the output file size:
The answer is:

```
128.3 MB
```

## Question 2

**What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?**

First Check the variable file in yaml:

```
file: "{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv"
```

The answer is:

```
green_tripdata_2020-04.csv
```

## Question 3

**How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?**

Execute backfills of [06_gcp_taxi_scheduled](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/02-workflow-orchestration/flows/06_gcp_taxi_scheduled.yaml) for yellow taxi data in year 2020.

After all yellow taxi data in 2020 being loaded into BigQuery, run SQL to count number of rows:

```
SELECT count(*) FROM zoomcamp.yellow_tripdata
WHERE EXTRACT(YEAR from tpep_pickup_datetime) = 2020
```

The answer is:

```
24648235
```

## Question 4

**How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?**
Execute backfills. After all green taxi data in 2020 being loaded into BigQuery, run SQL to count number of rows:

```
SELECT count(*) FROM zoomcamp.green_tripdata
where EXTRACT(YEAR from lpep_pickup_datetime) = 2020
```

The answer is:

```
1734039
```

## Question 5

**How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?**
Execute backfills. After all yellow taxi data in 2021 being loaded into BigQuery, run SQL to count number of rows:

```
SELECT count(*) FROM zoomcamp.yellow_tripdata
WHERE EXTRACT(MONTH from tpep_pickup_datetime) = 03
and EXTRACT(YEAR from tpep_pickup_datetime) = 2021
```

The answer is:

```
1925130
```

## Question 6

**How would you configure the timezone to New York in a Schedule trigger?**

Check offcial docs from Kestra. A schedule that runs daily at midnight US Eastern time:

```
triggers:
  - id: daily
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "@daily"
    timezone: America/New_York
```

The answer is:

```
Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
```
