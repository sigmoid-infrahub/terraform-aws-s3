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

output "module" {
  description = "Full module outputs"
  value = {
    bucket_id                   = aws_s3_bucket.this.id
    bucket_arn                  = aws_s3_bucket.this.arn
    bucket_domain_name          = aws_s3_bucket.this.bucket_domain_name
    bucket_regional_domain_name = aws_s3_bucket.this.bucket_regional_domain_name
  }
}
