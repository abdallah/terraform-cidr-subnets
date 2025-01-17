module "short" {
  source = "../"

  prefix = "test"
  base_cidr_block = "10.0.0.0/8"
  networks = [
    {
      name     = "public"
      netmask = 24
      number = 2
    },
    {
      name     = "private"
      netmask = 24
      number = 2
    },
    {
      name     = "database"
      netmask = 27
    }
  ]
}
output "short" {
  value = module.short
}
module "simple" {
  source = "../"

  base_cidr_block = "10.0.0.0/8"
  networks = [
    {
      name     = "public/foo"
      netmask = 24
    },
    {
      name     = "public/bar"
      netmask = 24
    },
    {
      name     = "private/baz"
      netmask = 27
    },
    {
      name     = "private/beep"
      netmask = 24
    },
    {
      name     = "test/boop"
      netmask = 27
    },
  ]
}

# data "testing_assertions" "simple" {
#   subject = "Simple call"

#   equal "network_cidr_blocks" {
#     statement = "has the expected network_cidr_blocks"

#     got = module.simple.network_cidr_blocks
#     want = tomap({
#       foo  = "10.0.0.0/16"
#       bar  = "10.1.0.0/16"
#       baz  = "10.16.0.0/12"
#       beep = "10.32.0.0/16"
#       boop = "10.33.0.0/16"
#     })
#   }

#   equal "networks" {
#     statement = "has the expected networks"

#     got = module.simple.networks
#     want = tolist([
#       {
#         cidr_block = "10.0.0.0/16"
#         name       = "foo"
#         netmask   = 8
#       },
#       {
#         cidr_block = "10.1.0.0/16"
#         name       = "bar"
#         netmask   = 8
#       },
#       {
#         cidr_block = "10.16.0.0/12"
#         name       = "baz"
#         netmask   = 4
#       },
#       {
#         cidr_block = "10.32.0.0/16"
#         name       = "beep"
#         netmask   = 8
#       },
#       {
#         cidr_block = "10.33.0.0/16"
#         name       = "boop"
#         netmask   = 8
#       },
#     ])
#   }
# }

output "simple" {
  value = module.simple
}
