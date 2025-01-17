variable project {
  type        = string
  default     = "ardent-justice-447919-a5"
  description = "Project ID" 
}

variable region {
  type        = string
  default     = "us-central1"
  description = "Region"
}


variable "bq_dataset_name" {
  type        = string
  default     = "demp_dataset"
  description = "My BigQuery Dataset Name"
}

variable "gcs_bucket_name" {
  type        = string
  default     = "ardent-justice-447919-a5-terra-bucket"
  description = "My Storage Bucket Name"
}

variable "gcs_storage_class" {
  type        = string
  default     = "STANDARD"
  description = "Bucket storage class"
}


variable "location" {
  type        = string
  default     = "US"
  description = "Project Location"
}
