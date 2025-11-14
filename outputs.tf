output "fe_public_ip" {
  value = module.ec2.fe_public_ip
}

output "be_private_ip" {
  value = module.ec2.be_private_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
