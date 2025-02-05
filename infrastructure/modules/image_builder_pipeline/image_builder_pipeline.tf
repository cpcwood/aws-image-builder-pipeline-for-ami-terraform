resource "aws_imagebuilder_image_pipeline" "image_builder" {
  name                             = "${var.project_name}-${var.environment}"
  status                           = "ENABLED"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.image_builder.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.image_builder.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.image_builder.arn
}

resource "aws_cloudwatch_event_rule" "image_builder" {
  name                = "${var.project_name}-${var.environment}"
  description         = "Invokes ${aws_imagebuilder_image_pipeline.image_builder.name} image builder pipeline"
  schedule_expression = "cron(0/20 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "image_builder" {
  rule     = aws_cloudwatch_event_rule.image_builder.name
  arn      = aws_imagebuilder_image_pipeline.image_builder.arn
  role_arn = aws_iam_role.image_builder_cron.arn
}

data "aws_iam_policy_document" "image_builder_cron" {
  statement {
    actions   = ["imagebuilder:StartImagePipelineExecution"]
    resources = [aws_imagebuilder_image_pipeline.image_builder.arn]
  }
}

resource "aws_iam_role" "image_builder_cron" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "image_builder_cron" {
  description = "${var.project_name}-${var.environment} cron policy"
  policy      = data.aws_iam_policy_document.image_builder_cron.json
}

resource "aws_iam_role_policy_attachment" "image_builder_cron" {
  role       = aws_iam_role.image_builder_cron.name
  policy_arn = aws_iam_policy.image_builder_cron.arn
}
