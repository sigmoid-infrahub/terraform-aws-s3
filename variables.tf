variable "bucket" {
  type        = string
  description = "Bucket name"
}

variable "versioning" {
  type        = bool
  description = "Enable versioning"
  default     = false
}

variable "force_destroy" {
  type        = bool
  description = "Force destroy the bucket"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the bucket"
  default     = {}
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for automatic object expiration and transition"
  type = list(object({
    id                         = string
    enabled                    = optional(bool, true)
    prefix                     = optional(string, "")
    expiration_days            = optional(number, null)
    transition_days            = optional(number, null)
    transition_class           = optional(string, "GLACIER")
    noncurrent_expiration_days = optional(number, null)
  }))
  default = []
}

variable "encryption" {
  type        = bool
  description = "Enable server-side encryption (SSE-S3 by default, SSE-KMS when kms_key_id is set)"
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "KMS key ARN for SSE-KMS. When empty, SSE-S3 (AES256) is used"
  default     = ""
}

variable "bucket_key_enabled" {
  type        = bool
  description = "Enable S3 Bucket Keys to reduce KMS request costs"
  default     = true
}

variable "block_public_access" {
  type        = bool
  description = "Enable S3 Block Public Access (sets all four block flags to true)"
  default     = true
}

variable "block_public_acls" {
  type        = bool
  description = "Block public ACLs"
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Block public policies"
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  description = "Ignore public ACLs on objects"
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Restrict public bucket policies"
  default     = true
}

variable "object_ownership" {
  type        = string
  description = "Bucket owner object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred, ObjectWriter"
  default     = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership must be one of: BucketOwnerEnforced, BucketOwnerPreferred, ObjectWriter"
  }
}

variable "access_logs_target_bucket" {
  type        = string
  description = "Target bucket for S3 access logs. When empty, access logging is disabled"
  default     = ""
}

variable "access_logs_target_prefix" {
  type        = string
  description = "Prefix for access log objects in the target bucket"
  default     = ""
}

variable "cors_rules" {
  description = "CORS rules for cross-origin access. Empty list disables CORS"
  type = list(object({
    allowed_methods = list(string)
    allowed_origins = list(string)
    allowed_headers = optional(list(string), [])
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number, 0)
  }))
  default = []
}

variable "bucket_policy" {
  type        = string
  description = "IAM policy document JSON for the bucket. When empty, no bucket policy is attached"
  default     = ""
}

variable "intelligent_tiering" {
  type        = bool
  description = "Enable S3 Intelligent-Tiering for cost optimization"
  default     = false
}

# ====================================
# Sigmoid Tags Configuration
# ====================================

variable "sigmoid_environment" {
  description = "Sigmoid environment identifier for cost allocation"
  type        = string
  default     = ""
}

variable "sigmoid_project" {
  description = "Sigmoid project identifier for cost allocation"
  type        = string
  default     = ""
}

variable "sigmoid_team" {
  description = "Sigmoid team identifier for cost allocation"
  type        = string
  default     = ""
}
