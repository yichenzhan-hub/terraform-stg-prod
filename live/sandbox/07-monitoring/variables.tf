variable "project" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The GCP Region"
  type        = string
}

variable "email_notification_address" {
  description = "Email address to receive alerts"
  type        = string
}