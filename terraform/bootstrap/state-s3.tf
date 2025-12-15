resource "aws_s3_bucket" "tf_state" {
    bucket = var.state_s3_name
    tags = {
        Name = var.state_s3_name
        Environment = var.env
    }
}

resource "aws_s3_bucket_versioning" "this" {
    bucket = aws_s3_bucket.tf_state.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_public_access_block" "this" {
    bucket = aws_s3_bucket.tf_state.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
    bucket = aws_s3_bucket.tf_state.id

    rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
    }
}

resource "aws_dynamodb_table" "this" {
    name = var.state_dynamodb_name
    hash_key = "LockID"
    billing_mode = "PAY_PER_REQUEST"
    
    attribute {
      name = "LockID"
      type = "S" # 문자열 타입
    }
}