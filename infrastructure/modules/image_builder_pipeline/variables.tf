variable "environment" {
  type        = string
  description = "Environment"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "base_image" {
  type        = string
  description = "Base image"
}

variable "build_subnet_id" {
  type        = string
  description = "Subnet ID"
}
