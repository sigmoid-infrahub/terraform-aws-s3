resource "aws_s3_bucket" "this" {
  bucket        = var.bucket
  force_destroy = var.force_destroy

  tags = local.resolved_tags
}

resource "aws_s3_bucket_versioning" "this" {
  count  = local.versioning_status == null ? 0 : 1
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = local.versioning_status
  }
}
