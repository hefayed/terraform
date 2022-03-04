#configure provider with your Cisco DCNM/NDFC credentials.
terraform {
  required_providers {
    dcnm = {
      source = "CiscoDevNet/dcnm"
    }
  }
}

provider "dcnm" {
  # Cisco DCNM/NDFC user name
  username = var.username
  # Cisco DCNM/NDFC password
  password = var.password
  # Cisco DCNM/NDFC url
  url      = var.url
  insecure = true
  platform = "nd"
}

module "fabric_switches" {
  source          = "../modules/ndfc_inventory"
  for_each        = var.inventory
  fabric_name     = each.value.fabric_name
  fabric_switches = each.value.switch_name
}
