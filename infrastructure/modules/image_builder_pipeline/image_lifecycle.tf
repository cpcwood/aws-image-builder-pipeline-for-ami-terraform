resource "aws_imagebuilder_lifecycle_policy" "image_builder_lifecycle" {
  name           = "${var.project_name}-${var.environment}"
  description    = "Delete old images, keep latest 3"
  execution_role = aws_iam_role.image_builder_lifecycle.arn
  resource_type  = "AMI_IMAGE"

  policy_detail {
    action {
      type = "DELETE"
    }
    filter {
      type  = "COUNT"
      value = 3
    }
  }

  resource_selection {
    tag_map = {
      ami_ref = "${var.project_name}-${var.environment}"
    }
  }

  depends_on = [aws_iam_role_policy_attachment.image_builder_lifecycle]
}

resource "aws_iam_role" "image_builder_lifecycle" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "imagebuilder.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "image_builder_lifecycle" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/EC2ImageBuilderLifecycleExecutionPolicy"
  role       = aws_iam_role.image_builder_lifecycle.name
}
