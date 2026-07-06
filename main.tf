locals {
  block_public_acls_effective       = var.block_public_access ? true : var.block_public_acls
  block_public_policy_effective     = var.block_public_access ? true : var.block_public_policy
  ignore_public_acls_effective      = var.block_public_access ? true : var.ignore_public_acls
  restrict_public_buckets_effective = var.block_public_access ? true : var.restrict_public_buckets
  has_access_logs                   = length(trimspace(var.access_logs_target_bucket)) > 0
  cloudfront_oac_bucket_policy = length(var.cloudfront_distribution_arns) > 0 ? jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.this.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arns
          }
        }
      }
    ]
  }) : ""
  effective_bucket_policy = length(trimspace(var.bucket_policy)) > 0 ? var.bucket_policy : local.cloudfront_oac_bucket_policy
  has_bucket_policy       = length(trimspace(local.effective_bucket_policy)) > 0
  has_kms_key             = length(trimspace(var.kms_key_id)) > 0
  sse_algorithm           = local.has_kms_key ? "aws:kms" : "AES256"
}

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket
  force_destroy = var.force_destroy

  tags = local.resolved_tags
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = local.block_public_acls_effective
  block_public_policy     = local.block_public_policy_effective
  ignore_public_acls      = local.ignore_public_acls_effective
  restrict_public_buckets = local.restrict_public_buckets_effective
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.encryption ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = local.sse_algorithm
      kms_master_key_id = local.has_kms_key ? var.kms_key_id : null
    }
    bucket_key_enabled = local.has_kms_key ? var.bucket_key_enabled : null
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = local.versioning_status
  }
}

resource "aws_s3_bucket_logging" "this" {
  count  = local.has_access_logs ? 1 : 0
  bucket = aws_s3_bucket.this.id

  target_bucket = var.access_logs_target_bucket
  target_prefix = var.access_logs_target_prefix
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count  = length(var.cors_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = cors_rule.value.allowed_headers
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = local.has_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = local.effective_bucket_policy

  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  count  = var.intelligent_tiering ? 1 : 0
  bucket = aws_s3_bucket.this.id
  name   = "sigmoid-managed-intelligent-tiering"

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      filter {
        prefix = rule.value.prefix
      }

      dynamic "expiration" {
        for_each = rule.value.expiration_days != null ? [rule.value.expiration_days] : []
        content {
          days = expiration.value
        }
      }

      dynamic "transition" {
        for_each = rule.value.transition_days != null ? [rule.value.transition_days] : []
        content {
          days          = transition.value
          storage_class = rule.value.transition_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_expiration_days != null ? [rule.value.noncurrent_expiration_days] : []
        content {
          noncurrent_days = noncurrent_version_expiration.value
        }
      }
    }
  }
}
