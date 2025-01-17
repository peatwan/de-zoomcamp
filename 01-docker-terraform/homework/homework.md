# Module 1 Homework: Docker & SQL

## Question 1. Understanding docker first run

Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.

```bash
docker run -it --entrypoint bash python:3.12.8
```

Then, get the version of pip

```bash
pip -V
```

The output is:

```
pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)
```

The answer is:

```
24.3.1
```

## Question 2. Understanding Docker networking and docker-compose

To make pgadmin connect the postgres database, we need to find the hostname and port of postgres. In this config file, the service name of postgres is `db`, and port mapping is `5433:5432`.

What is hostname in docker compose?

> By default Compose sets up a single network for your app. Each container for a service joins the default network and is both reachable by other containers on that network, and discoverable by the service's name.

So `db` is the hostname.

For port mapping, the rule is `HOST_PORT:CONTAINER_PORT`. Since both services are defined in the same Docker Compose file, they share the same network. Therefore, pgAdmin can refer to the postgres container by its name (`db`) and the specified port (`5432`).

The answer is:

```
db:5432
```

## Question 3. Trip Segmentation Count

After data ingestion, writing SQL to find eligible trips.

```sql
select sum(case when t.trip_distance <= 1 then 1 else 0 end)                          as cnt1,
       sum(case when t.trip_distance > 1 and t.trip_distance <= 3 then 1 else 0 end)  as cnt2,
       sum(case when t.trip_distance > 3 and t.trip_distance <= 7 then 1 else 0 end)  as cnt3,
       sum(case when t.trip_distance > 7 and t.trip_distance <= 10 then 1 else 0 end) as cnt4,
       sum(case when t.trip_distance > 10 then 1 else 0 end)                          as cnt5
from green_taxi_data t
where t.lpep_dropoff_datetime >= '2019-10-01'
  and t.lpep_dropoff_datetime < '2019-11-01';
```

The answer is:

```
104802,198924,109603,27678,35189
```

## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance?

```sql
select 'date'
from (select t.lpep_pickup_datetime::date as                   day,
             row_number() over (order by t.trip_distance desc) rn
      from green_taxi_data t) t1
where rn = 1;
```

The answer is:

```
2019-10-31
```

## Question 5. Three biggest pickup zones

```sql
select t4."Zone"
from (select t2."PULocationID", t2.total_amount
      from (select t1."PULocationID", sum(t1.total_amount) as total_amount
            from green_taxi_data t1
            where t1.lpep_pickup_datetime::date = '2019-10-18'
            group by t1."PULocationID") t2
      where t2.total_amount > 13000) t3
         join taxi_zone t4 on t3."PULocationID" = t4."LocationID"
order by t3.total_amount desc;
```

The answer is:

```
East Harlem North, East Harlem South, Morningside Heights
```

## Question 6. Largest tip

```sql
select t3."Zone", t1.tip_amount
from green_taxi_data t1
         join taxi_zone t2 on t1."PULocationID" = t2."LocationID"
         join taxi_zone t3 on t1."DOLocationID" = t3."LocationID"
where to_char(t1.lpep_pickup_datetime, 'YYYY-MM') = '2019-10'
  and t2."Zone" = 'East Harlem North'
order by t1.tip_amount desc;
```

The answer is:

```
JFK Airport
```

## Question 7. Terraform Workflow

The answer is:

```
terraform init, terraform apply -auto-approve, terraform destroy
```

Explainations of these commands:

- `terraform init`:This is always the first step to initialize a Terraform project, download plugins, and configure the backend.
- `terraform apply -auto-approve`: This combines the planning and application steps. terraform apply creates the execution plan and then applies the changes to your infrastructure. The `-auto-approve` flag bypasses the confirmation prompt, automatically applying the plan.
- `terraform destroy`: This command is used to destroy all the resources managed by your Terraform configuration.

See terraform files can click [here](../1_terraform_gcp/).
