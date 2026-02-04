data "terraform_remote_state" "redis" {
  backend = "gcs"
  config = {
    bucket = "tf-state-mvn-sandbox-yichen"  # Your bucket name
    prefix = "sandbox/redis"                # Points to Layer 9 state
  }
}