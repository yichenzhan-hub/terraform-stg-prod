# Read the "Networking" state to get the VPC link
data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = "tf-state-mvn-sandbox-yichen"
    prefix = "sandbox/networking" # Must match Layer 1's backend prefix exactly!
  }
}

# How to use this in your main.tf:
# private_network_self_link = data.terraform_remote_state.network.outputs.network_self_link