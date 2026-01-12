# Read Layer 1 (Networking)
data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = "tf-state-mvn-sandbox-yichen"
    prefix = "sandbox/networking"
  }
}

# Read Layer 2 (Database)
data "terraform_remote_state" "db" {
  backend = "gcs"
  config = {
    bucket = "tf-state-mvn-sandbox-yichen"
    prefix = "sandbox/database"
  }
}

# How to use these in your main.tf:
# vpc_connector = data.terraform_remote_state.network.outputs.connector_self_link
# env_vars = [ { name = "DB_HOST", value = data.terraform_remote_state.db.outputs.private_ip } ]