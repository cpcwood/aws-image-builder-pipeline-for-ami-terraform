resource "aws_imagebuilder_distribution_configuration" "image_builder" {
  #checkov:skip=CKV_AWS_199:Ensure Image Builder Distribution Configuration encrypts AMI's using KMS - a customer managed Key (CMK)
  name        = "${var.project_name}-${var.environment}"
  description = "Multi-region distribution"

  distribution {
    region = data.aws_region.current.name

    ami_distribution_configuration {
      ami_tags = {
        project     = var.project_name
        environment = var.environment
        ami_ref     = "${var.project_name}-${var.environment}"
      }

      name = "${var.project_name}-${var.environment}-${var.base_image}-{{ imagebuilder:buildDate }}"

      launch_permission {
        user_ids = [data.aws_caller_identity.current.account_id]
      }
    }
  }
}
