locals {
  bucket_name = "${var.name_prefix}-media-bucket"
}

resource "aws_s3_bucket" "myce_media_bucket" {
    bucket = local.bucket_name
    tags = {
        Name = local.bucket_name
        Environment = "product"
    }
}

resource "aws_s3_bucket_versioning" "this" {
    bucket = aws_s3_bucket.myce_media_bucket.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_public_access_block" "media_bucket_access" {
    bucket = aws_s3_bucket.myce_media_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

data "aws_iam_policy_document" "media_bucket_policy" {
    statement {
        effect = "Allow"
        actions = ["s3:GetObject", "s3:PutObject"]
        resources = ["${aws_s3_bucket.myce_media_bucket.arn}/*"]

        principals {
            type = "Service"
            identifiers = ["cloudfront.amazonaws.com"]
        }
    }
}

resource "aws_s3_bucket_policy" "media_policy" {
  bucket = aws_s3_bucket.myce_media_bucket.id
  policy = data.aws_iam_policy_document.media_bucket_policy.json

  depends_on = [
    aws_s3_bucket_public_access_block.media_bucket_access
  ]
}