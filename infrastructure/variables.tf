variable "project_name" {
  type        = string
  description = "Project name"
  default     = "aws-image-builder-pipeline"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "development"
}

variable "aws_region" {
  type        = string
  description = "AWS region to build infrastructure in"
  default     = "eu-west-2"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile to access AWS API"
  default     = "aws-image-builder-pipeline"
}

variable "base_image" {
  type        = string
  description = "Base image to build from"
  default     = "ubuntu-server-24-lts-x86"
}
