resource "aws_cloudwatch_log_group" "image_builder" {
  #checkov:skip=CKV_AWS_338:Ensure CloudWatch log groups retains logs for at least 1 year
  #checkov:skip=CKV_AWS_158: Ensure that CloudWatch Log Group is encrypted by KMS
  name              = "/aws/imagebuilder/${var.project_name}-${var.environment}"
  retention_in_days = 7
}
