resource "aws_security_group" "image_builder" {
  #checkov:skip=CKV2_AWS_5:Ensure that Security Groups are attached to another resource
  #checkov:skip=CKV_AWS_382:Ensure no security groups allow egress from 0.0.0.0:0 to port -1

  name        = "${var.project_name}-${var.environment}"
  description = "Allow connections to external traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound from self"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  egress {
    description      = "Allow all outbound traffic by default"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    name = "${var.project_name}-${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
