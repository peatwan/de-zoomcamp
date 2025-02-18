# Load yellow taxi data by dlt

Using dlt to load yellow taxi data for homework 3 instead of using [this](../../../../03-data-warehouse/homework/load_yellow_taxi_data.py).

## Step 1

Intall requirements:

```sh
pip install -r requirements.txt
```

## Step 2

Create file `./dlt/secrets.toml`, fill GCP credentials and configs:

```toml
[destination.filesystem]
bucket_url = "gs://[your_bucket_name]" # replace with your bucket name,

[destination.filesystem.credentials]
client_email = "<client_email from services.json>"
private_key = "<private_key from services.json>"
project_id = "<project_id from services.json>"
```

## Step 3

Run [load_yellow_taxi_data_dlt.py](./load_yellow_taxi_data_dlt.py).

```sh
python load_yellow_taxi_data_dlt.py
```
