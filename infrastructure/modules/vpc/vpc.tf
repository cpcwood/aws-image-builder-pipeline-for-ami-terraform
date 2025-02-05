module "vpc" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name = "${var.project_name}-${var.environment}"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = []
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  map_public_ip_on_launch = true
  enable_nat_gateway      = false
  enable_vpn_gateway      = false
}
