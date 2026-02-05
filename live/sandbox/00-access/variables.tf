variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The default GCP region"
  type        = string
  default     = "northamerica-northeast2" # Optional default
}


# --- 1. THE OWNER ---
variable "iam_owners" {
  description = "Users with full access (Billing, IAM, Resource Deletion)"
  type        = list(string)
  default     = []
}

# --- 2. THE INFRA TEAM ---
variable "iam_admins" {
  description = "Users who manage resources (Network, SQL, Redis) but NOT IAM/Billing"
  type        = list(string)
  default     = []
}

# --- 3. THE APP TEAM ---
variable "iam_developers" {
  description = "Users who deploy code and view logs"
  type        = list(string)
  default     = []
}

# --- 4. THE DATA & OPS TEAM ---
variable "iam_data_viewers" {
  description = "Users who need BigQuery Read Access and Monitoring Dashboards"
  type        = list(string)
  default     = []
}