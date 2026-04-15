variable "ubuntu_vms" {
  type = map(object({
    cpu                        = optional(number, 2)
    memory                     = optional(number, 2)
    computer_name              = optional(string, "UbuntuTerraform")
    num_cores_per_socket       = optional(number, 1)
    wait_for_guest_net_timeout = optional(number, 0)
    wait_for_guest_ip_timeout  = optional(number, 0)

    ipv4_gateway    = optional(string, null)
    dns_server_list = optional(list(string), ["8.8.8.8"])
    network_interfaces = list(object({
      network_name = string
      ipv4_address = optional(string, null)
      ipv4_netmask = optional(number, null)
    }))

    disk = list(object({
      label            = string
      size             = number
      thin_provisioned = optional(bool, true)
    }))

    iso_paths = optional(list(string), [])
  }))
}