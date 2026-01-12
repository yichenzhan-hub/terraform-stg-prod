terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    # This is the provider required for the time_sleep resource
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}