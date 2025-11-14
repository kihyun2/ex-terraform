output "vpc_id" {
  value = aws_vpc.main.id
}

################################
# Public Subnets
################################

# Public Subnet A (ap-northeast-2a)
output "public_subnet_a_id" {
  value = aws_subnet.public_a.id
}

# Public Subnet C (ap-northeast-2c)
output "public_subnet_c_id" {
  value = aws_subnet.public_c.id
}

################################
# Private Subnet
################################

output "private_subnet_a_id" {
  value = aws_subnet.private_a.id
}

################################
# Public Subnet CIDRs
################################

output "public_subnet_a_cidr" {
  value = aws_subnet.public_a.cidr_block
}

output "public_subnet_c_cidr" {
  value = aws_subnet.public_c.cidr_block
}
