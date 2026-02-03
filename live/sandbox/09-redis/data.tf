data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = "tf-state-mvn-sandbox-yichen"
    prefix = "sandbox/networking"
  }
}