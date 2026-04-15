variable "vsphere_user" { sensitive = true }
variable "vsphere_password" { sensitive = true }
variable "vsphere_server" {}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}
data "vsphere_datacenter" "datacenter" {
  name = "Cisco UCS"
}

data "vsphere_datastore" "datastore" {
  name          = "25-26-da-diagnet"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "DiagNet"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_distributed_virtual_switch" "dvs" {
  name          = "dvSwitch-diagnet"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "default" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = "10.40.1.27"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_content_library" "lib" {
  name = "25-26-da-shared"
}
