data "aws_iam_policy_document" "image_builder" {
  #checkov:skip=CKV_AWS_356:Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions
  #checkov:skip=CKV_AWS_108:IAM policies does not allow data exfiltration
  #checkov:skip=CKV_AWS_111:Ensure IAM policies does not allow write access without constraints

  statement {
    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply",
      "imagebuilder:GetComponent"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.image_builder.arn}/*"]
  }

  statement {
    actions   = ["kms:Decrypt"]
    resources = ["*"]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "kms:EncryptionContextKeys"
      values   = ["aws:imagebuilder:arn"]
    }

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"
      values   = ["imagebuilder.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.image_builder.arn,
      "${aws_cloudwatch_log_group.image_builder.arn}/*"
    ]
  }

  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::ec2imagebuilder*"]
  }
}

resource "aws_iam_role" "image_builder" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "image_builder" {
  role = aws_iam_role.image_builder.name
}

resource "aws_iam_policy" "image_builder" {
  description = "${var.project_name}-${var.environment} build policy"
  policy      = data.aws_iam_policy_document.image_builder.json
}

resource "aws_iam_role_policy_attachment" "image_builder" {
  role       = aws_iam_role.image_builder.name
  policy_arn = aws_iam_policy.image_builder.arn
}

resource "aws_iam_role_policy_attachment" "ssm_instance" {
  role       = aws_iam_role.image_builder.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
