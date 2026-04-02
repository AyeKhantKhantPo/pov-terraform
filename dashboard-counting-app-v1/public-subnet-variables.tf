# Just for note how to explore the module
# https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/main.tf
################################################################################
# Public Subnets
################################################################################

# locals {
#   create_public_subnets = local.create_vpc && local.len_public_subnets > 0

#   num_public_route_tables = var.create_multiple_public_route_tables ? local.len_public_subnets : 1
# }

# resource "aws_subnet" "public" {
#   count = local.create_public_subnets && (!var.one_nat_gateway_per_az || local.len_public_subnets >= length(var.azs)) ? local.len_public_subnets : 0

#   region = var.region

#   assign_ipv6_address_on_creation                = var.enable_ipv6 && var.public_subnet_ipv6_native ? true : var.public_subnet_assign_ipv6_address_on_creation
#   availability_zone                              = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
#   availability_zone_id                           = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
#   cidr_block                                     = var.public_subnet_ipv6_native ? null : element(concat(var.public_subnets, [""]), count.index)
#   enable_dns64                                   = var.enable_ipv6 && var.public_subnet_enable_dns64
#   enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.public_subnet_enable_resource_name_dns_aaaa_record_on_launch
#   enable_resource_name_dns_a_record_on_launch    = !var.public_subnet_ipv6_native && var.public_subnet_enable_resource_name_dns_a_record_on_launch
#   ipv6_cidr_block                                = var.enable_ipv6 && length(var.public_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, var.public_subnet_ipv6_prefixes[count.index]) : null
#   ipv6_native                                    = var.enable_ipv6 && var.public_subnet_ipv6_native
#   map_public_ip_on_launch                        = var.map_public_ip_on_launch
#   private_dns_hostname_type_on_launch            = var.public_subnet_private_dns_hostname_type_on_launch
#   vpc_id                                         = local.vpc_id

#   tags = merge(
#     {
#       Name = try(
#         var.public_subnet_names[count.index],
#         format("${var.name}-${var.public_subnet_suffix}-%s", element(var.azs, count.index))
#       )
#     },
#     var.tags,
#     var.public_subnet_tags,
#     lookup(var.public_subnet_tags_per_az, element(var.azs, count.index), {})
#   )
# }

# resource "aws_route_table" "public" {
#   count = local.create_public_subnets ? local.num_public_route_tables : 0

#   region = var.region

#   vpc_id = local.vpc_id

#   tags = merge(
#     {
#       "Name" = var.create_multiple_public_route_tables ? format(
#         "${var.name}-${var.public_subnet_suffix}-%s",
#         element(var.azs, count.index),
#       ) : "${var.name}-${var.public_subnet_suffix}"
#     },
#     var.tags,
#     var.public_route_table_tags,
#   )
# }

# resource "aws_route_table_association" "public" {
#   count = local.create_public_subnets ? local.len_public_subnets : 0

#   region = var.region

#   subnet_id      = element(aws_subnet.public[*].id, count.index)
#   route_table_id = element(aws_route_table.public[*].id, var.create_multiple_public_route_tables ? count.index : 0)
# }

# resource "aws_route" "public_internet_gateway" {
#   count = local.create_public_subnets && var.create_igw ? local.num_public_route_tables : 0

#   region = var.region

#   route_table_id         = aws_route_table.public[count.index].id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.this[0].id

#   timeouts {
#     create = "5m"
#   }
# }

# resource "aws_route" "public_internet_gateway_ipv6" {
#   count = local.create_public_subnets && var.create_igw && var.enable_ipv6 ? local.num_public_route_tables : 0

#   region = var.region

#   route_table_id              = aws_route_table.public[count.index].id
#   destination_ipv6_cidr_block = "::/0"
#   gateway_id                  = aws_internet_gateway.this[0].id
# }