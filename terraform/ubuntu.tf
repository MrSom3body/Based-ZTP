locals {
  all_ubuntus = merge(var.ubuntu_vms)
  build_loc   = "DiagNET/INFRA_THESAN" # temp
}

data "vsphere_content_library_item" "ubuntu_template" {
  name       = "PHX_template_ubuntu"
  library_id = data.vsphere_content_library.lib.id
  type       = "vm-template"
}

data "vsphere_virtual_machine" "ubuntu_template_information" {
  name          = data.vsphere_content_library_item.ubuntu_template.name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "ubuntu" {
  for_each                   = local.all_ubuntus
  name                       = each.key
  datastore_id               = data.vsphere_datastore.datastore.id
  resource_pool_id           = data.vsphere_resource_pool.default.id
  folder                     = local.build_loc
  num_cpus                   = each.value.cpu
  memory                     = each.value.memory
  guest_id                   = data.vsphere_virtual_machine.ubuntu_template_information.guest_id
  scsi_type                  = data.vsphere_virtual_machine.ubuntu_template_information.scsi_type
  firmware                   = data.vsphere_virtual_machine.ubuntu_template_information.firmware
  num_cores_per_socket       = each.value.num_cores_per_socket
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  dynamic "disk" {
    for_each = each.value.disk
    content {
      label            = disk.value.label
      size             = disk.value.size
      thin_provisioned = disk.value.thin_provisioned
    }
  }

  dynamic "network_interface" {
    for_each = each.value.network_interfaces
    content {
      network_id = local.all_networks[network_interface.value.network_name].id
    }
  }

  dynamic "cdrom" {
    for_each = each.value.iso_paths
    content {
      datastore_id = data.vsphere_datastore.datastore.id
      path         = cdrom.value
    }
  }

  extra_config = {
    "isolation.tools.copy.disable"         = "FALSE"
    "isolation.tools.paste.disable"        = "FALSE"
    "isolation.tools.setGUIOptions.enable" = "TRUE"
    "tools.guest.desktop.autolock"         = "FALSE"
  }

  clone {
    template_uuid = data.vsphere_content_library_item.ubuntu_template.id

    customize {
      linux_options {
        host_name = each.key
        domain    = ""
      }
      ipv4_gateway    = each.value.ipv4_gateway
      dns_server_list = each.value.dns_server_list
      dynamic "network_interface" {
        for_each = each.value.network_interfaces

        content {
          ipv4_address = network_interface.value.ipv4_address
          ipv4_netmask = network_interface.value.ipv4_netmask
        }
      }
    }
  }

}
