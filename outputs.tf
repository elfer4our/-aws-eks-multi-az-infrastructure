output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of private subnets"
  value       = module.vpc.private_subnets
}

output "node_security_group_id" {
  description = "Security group ID of worker nodes"
  value       = module.eks.node_security_group_id
}

output "cluster_name" {
  description = "The name of Cluster"
  value       = module.eks.cluster_name
}