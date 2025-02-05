resource "aws_imagebuilder_infrastructure_configuration" "image_builder" {
  name                          = "${var.project_name}-${var.environment}"
  description                   = "Infrastructure configuration"
  instance_profile_name         = aws_iam_instance_profile.image_builder.name
  instance_types                = ["t3.medium"]
  security_group_ids            = [aws_security_group.image_builder.id]
  subnet_id                     = var.build_subnet_id
  terminate_instance_on_failure = true

  logging {
    s3_logs {
      s3_bucket_name = aws_s3_bucket.image_builder.bucket
      s3_key_prefix  = "build-logs"
    }
  }
}
