output "bucket_id" {
  description = "Bucket name"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "Bucket ARN"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Bucket domain name"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Bucket regional domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "encryption_enabled" {
  description = "Whether server-side encryption is enabled on the bucket"
  value       = var.encryption
}

output "kms_key_id" {
  description = "KMS key ID used for SSE-KMS. Empty when SSE-S3 is in use"
  value       = local.has_kms_key ? var.kms_key_id : ""
}

output "module" {
  description = "Full module outputs"
  value = {
    bucket_id                   = aws_s3_bucket.this.id
    bucket_arn                  = aws_s3_bucket.this.arn
    bucket_domain_name          = aws_s3_bucket.this.bucket_domain_name
    bucket_regional_domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    encryption_enabled          = var.encryption
    kms_key_id                  = local.has_kms_key ? var.kms_key_id : ""
  }
}
