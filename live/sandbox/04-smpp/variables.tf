variable "project" {
  description = "The GCP Project ID"
  type        = string
  default     = "mvn-sandbox-smsgw-yzhan"
}

variable "region" {
  type    = string
  default = "northamerica-northeast2"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "smpp-cluster" # REPLACE with your actual cluster name
}

variable "cluster_location" {
  description = "The region or zone of the cluster"
  type        = string
  default     = "northamerica-northeast2" 
}

variable "otel_collector_url" {
  description = "The endpoint URL for the OTel Collector"
  type        = string
}