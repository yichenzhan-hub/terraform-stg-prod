terraform {
  backend "gcs" {
    bucket  = "tf-state-mvn-sandbox-yichen"
    prefix  = "sandbox/application"
  }
}