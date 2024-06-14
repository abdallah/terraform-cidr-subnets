locals {
  cidr_netmask  = tonumber(split("/", var.base_cidr_block)[1])
  total_subnets = sum([for net in var.networks : net.number])

  # Create a list of all possible subnets with their associated netmask and name
  networks_netmask_to_bits = flatten([
    for i, net in var.networks : [
      for j in range(net.number) : {
        name     = anytrue([for n in var.networks : n.number > 1]) ? "${net.name}/${var.prefix}-${j}" : net.name
        new_bits = tonumber(net.netmask - local.cidr_netmask)
      }
    ]
  ])


  name_prefixes = toset([for name, _ in local.addrs_by_name : split(var.separator, name)[0]])

  addrs_by_idx      = cidrsubnets(var.base_cidr_block, local.networks_netmask_to_bits[*].new_bits...)
  addrs_by_name     = { for i, n in local.networks_netmask_to_bits : n.name => local.addrs_by_idx[i] if n.name != null }
  map_addrs_by_name = tomap(local.addrs_by_name)
  network_objs = [for i, n in local.networks_netmask_to_bits : {
    name       = n.name
    netmask    = n.name != null ? split("/", local.map_addrs_by_name[n.name])[1] : split("/", local.addrs_by_idx[i])[1]
    bits       = n.new_bits
    cidr_block = n.name != null ? local.map_addrs_by_name[n.name] : local.addrs_by_idx[i]
  }]

}
