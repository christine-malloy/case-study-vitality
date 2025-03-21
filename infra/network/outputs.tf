output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets_cidr_blocks" {
  value = module.public_private_subnets.public_subnet_cidrs
}

output "private_only_subnets_cidr_blocks" {
  value = module.private_only_subnets.private_subnet_cidrs
}

output "postgres_security_group_id" {
  description = "ID of the PostgreSQL security group"
  value       = module.sg_postgres.id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.ec2_bastion.public_ip
}
