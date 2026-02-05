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

resource "aws_s3_bucket_public_access_block" "this" {
    bucket = aws_s3_bucket.myce_media_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "this" {
    bucket = aws_s3_bucket.myce_media_bucket.id

    policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "Statement1",
                "Effect": "Allow",
                "Principal": "*",
                "Action": [
                    "s3:GetObject",
                    "s3:PutObject"
                ],
                "Resource": "arn:aws:s3:::${local.bucket_name}/*"
            }
        ]
    }
    POLICY
}