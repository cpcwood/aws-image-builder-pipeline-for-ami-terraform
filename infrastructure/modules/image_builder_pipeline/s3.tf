resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "image_builder" {
  #checkov:skip=CKV2_AWS_6:Ensure that S3 bucket has a Public Access block
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled 
  #checkov:skip=CKV_AWS_18:Ensure S3 bucket has access logging enabled
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled 
  #checkov:skip=CKV_AWS_145:Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_21:Ensure all data stored in the S3 bucket have versioning enabled
  bucket        = "${var.project_name}-${var.environment}-${random_string.bucket_suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "image_builder" {
  bucket = aws_s3_bucket.image_builder.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "image_builder" {
  depends_on = [aws_s3_bucket_versioning.image_builder] # Must have bucket versioning enabled first

  bucket = aws_s3_bucket.image_builder.id

  rule {
    id     = "id-1"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}
