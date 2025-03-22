locals {
  namespace       = var.namespace
  stage           = var.stage
  name            = var.name
  attributes      = var.attributes
  s3_origin_id    = var.s3_origin_id
  api_origin_id   = var.api_origin_id
  api_service_name = coalesce(var.api_service_name, "${local.namespace}-${local.stage}-api-service")
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Get App Runner service information
data "aws_apprunner_service" "service" {
  service_name = local.api_service_name
}

# S3 bucket for frontend static assets
module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "3.1.2"

  acl                      = "private"
  versioning_enabled       = true
  allowed_bucket_actions   = ["s3:GetObject"]
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true

  context = module.this.context
  name    = local.name
  stage   = local.stage
  namespace = local.namespace
  attributes = local.attributes
  tags     = var.tags
}

# Origin Access Identity for CloudFront
resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "Origin Access Identity for ${module.s3_bucket.bucket_id}"
}

# Policy for CloudFront to access S3
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.default.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_bucket.bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}

# AWS WAF Web ACL
module "waf" {
  source  = "cloudposse/waf/aws"
  version = "0.0.7"

  scope = "CLOUDFRONT"
  
  managed_rule_group_statement_rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet"
      priority = 10
      override_action = "none"
      excluded_rules  = []
      statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesCommonRuleSet"
        sampled_requests_enabled   = true
      }
    },
    {
      name     = "AWSManagedRulesKnownBadInputsRuleSet"
      priority = 20
      override_action = "none"
      excluded_rules  = []
      statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
        sampled_requests_enabled   = true
      }
    }
  ]

  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.namespace}-${local.stage}-${local.name}-waf"
    sampled_requests_enabled   = true
  }

  context = module.this.context
  name    = local.name
  stage   = local.stage
  namespace = local.namespace
  attributes = local.attributes
  tags     = var.tags
}

# CloudFront Distribution
module "cloudfront" {
  source  = "cloudposse/cloudfront/aws"
  version = "0.14.0"

  aliases             = []  # Add your custom domain here if needed
  price_class         = var.price_class
  parent_zone_id      = null
  dns_alias_enabled   = false
  ipv6_enabled        = true
  minimum_protocol_version = "TLSv1.2_2021"

  # S3 origin configuration
  origins = [
    {
      domain_name = module.s3_bucket.bucket_regional_domain_name
      origin_id   = local.s3_origin_id
      origin_path = ""
      custom_origin_config = null
      s3_origin_config = {
        origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
      }
      custom_header = []
      origin_shield = null
    },
    {
      domain_name = data.aws_apprunner_service.service.service_url
      origin_id   = local.api_origin_id
      origin_path = ""
      s3_origin_config = null
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
        origin_keepalive_timeout = 5
        origin_read_timeout    = 30
      }
      custom_header = []
      origin_shield = null
    }
  ]

  # Default cache behavior for the frontend static assets
  default_cache_behavior = {
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
    query_string           = true
    cookies_forward        = "none"
    headers               = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
    cookies_whitelisted_names = null
    forward_query_string_cache_keys = []
    function_association  = []
    lambda_function_association = []
    trusted_signers       = null
    trusted_key_groups    = null
    min_ttl               = 0
    default_ttl           = 86400
    max_ttl               = 31536000
    use_forwarded_values  = true
  }

  # Cache behavior for the API
  ordered_cache = [
    {
      path_pattern           = "/api/*"
      target_origin_id       = local.api_origin_id
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods         = ["GET", "HEAD"]
      compress               = true
      query_string           = true
      cookies_forward        = "all"
      headers               = ["*"]
      cookies_whitelisted_names = null
      forward_query_string_cache_keys = []
      function_association  = []
      lambda_function_association = []
      trusted_signers       = null
      trusted_key_groups    = null
      min_ttl               = 0
      default_ttl           = 0
      max_ttl               = 0
      use_forwarded_values  = true
    }
  ]

  # Associate the WAF Web ACL with CloudFront
  web_acl_id = module.waf.web_acl_id

  # Custom error responses
  custom_error_response = [
    {
      error_caching_min_ttl = 300
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
    },
    {
      error_caching_min_ttl = 300
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
    }
  ]

  context = module.this.context
  name    = local.name
  stage   = local.stage
  namespace = local.namespace
  attributes = local.attributes
  tags     = var.tags
} 