locals {
  bucket_name = "${var.name_prefix}-client-bucket"
}

resource "aws_s3_bucket" "client_bucket" {
  bucket = local.bucket_name

  tags = {
    Name = local.bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "client_bucket_access" {
  bucket = aws_s3_bucket.client_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## cloudfront
resource "aws_cloudfront_origin_access_control" "client_bucket_cloudfront" {
  name                              = "client-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "ssl_certificate_virginia" {
  provider          = aws.us_east_1
  domain_name       = "myce.cloud"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate_virginia.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "ssl_certificate_virginia" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.ssl_certificate_virginia.arn
  validation_record_fqdns = [for r in aws_route53_record.acm_validation : r.fqdn]
}


resource "aws_cloudfront_distribution" "client_cloudfront_distribution" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.client_bucket.bucket_regional_domain_name ##s3 domain name
    origin_id                = "myce-clinet-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.client_bucket_cloudfront.id
    # origin_path = "/myce"
  }

  default_cache_behavior {
    target_origin_id       = "myce-clinet-origin" ## 어디로 연결되는지
    viewer_protocol_policy = "redirect-to-https" ## HTTP로 요청이 왔을 때 처리 방식 - allow-all / redirect-to-https / https-only

    allowed_methods = ["GET", "POST", "PUT", "OPTIONS", "DELETE", "PATCH", "HEAD"] ## 허용되는 HTTP METHOD
    cached_methods  = ["GET", "HEAD"] 

    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }

  restrictions {
    geo_restriction { //국가별 접근 제한 none / whitelist / blacklist
      restriction_type = "none"
    }
  }

  viewer_certificate { // HTTP 인증서 설정
    acm_certificate_arn = aws_acm_certificate.ssl_certificate_virginia.arn ## 내 도메인으로 HTTPS를 쓰게 해주는 증명서의 ID
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  web_acl_id = "arn:aws:wafv2:us-east-1:274213481132:global/webacl/CreatedByCloudFront-2eef1b0b/620a6ed9-7a01-4e58-8382-758f8194f539"

  depends_on = [ aws_acm_certificate_validation.ssl_certificate_virginia ]
  aliases = ["myce.cloud"]
}

data "aws_iam_policy_document" "client_bucket_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.client_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.client_cloudfront_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "client" {
  bucket = aws_s3_bucket.client_bucket.id
  policy = data.aws_iam_policy_document.client_bucket_policy.json

  depends_on = [
    aws_s3_bucket_public_access_block.client_bucket_access
  ]
}

data "aws_route53_zone" "main" {
    name = "myce.cloud"
}