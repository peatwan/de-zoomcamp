docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v /Users/di/Projects/de-zoomcamp/01_docker_terraform/2_docker_sql/ny_taxi_postgre_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    --network=pg-network\
    --name pg-database \
    postgres:13

docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4

python ingest_data.py \
    --user root \
    --password root \
    --host localhost \
    --port 5432 \
    --db  ny_taxi\
    --table_name yellow_taxi_data \
    --url https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz


docker run -it \
    --network=pg-network \
    --name ingestion \
    ingestion:002 \
    --user root \
    --password root \
    --host  pg-database \
    --port 5432 \
    --db  ny_taxi\
    --table_name yellow_taxi_data \
    --url https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz

