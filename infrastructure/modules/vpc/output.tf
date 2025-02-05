output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "build_subnet_id" {
  description = "The ID of a public subnet for building AMIs in"
  value       = element(module.vpc.public_subnets, 0)
}
